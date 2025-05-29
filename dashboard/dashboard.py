# --- Applications properties ---

import os

wordslab_version = os.getenv("WORDSLAB_VERSION")
wordslab_platform = os.getenv("WORDSLAB_PLATFORM")
dashboard_port=int(os.getenv("DASHBOARD_PORT"))

jupyterlab_url = os.getenv("JUPYTERLAB_URL")
vscode_url = os.getenv("VSCODE_URL")
openwebui_url = os.getenv("OPENWEBUI_URL")

app1_url = os.getenv("USER_APP1_URL")
app2_url = os.getenv("USER_APP2_URL")
app3_url = os.getenv("USER_APP3_URL")
app4_url = os.getenv("USER_APP2_URL")
app5_url = os.getenv("USER_APP3_URL")

# --- Virtual Machine properties ---

from dataclasses import dataclass
from pathlib import Path
import psutil
import pynvml
import subprocess

# --- CPU --

@dataclass 
class CPUMetrics:
    cpu_model: str
    cpu_vendor: str
    cpu_cores: int
    cpu_frequency: int
    cpu_usage: float
    ram_total: float  # GB
    ram_used: float   # GB

def get_cpu_metrics() -> CPUMetrics:
    # Get CPU model
    try:
        with open('/proc/cpuinfo', 'r') as f:
            for line in f:
                if line.startswith('model name'):
                    cpu_model = line.split(':')[1].strip()
                    break
    except:
        cpu_model = "Unknown"
    
    if "Intel" in cpu_model:
        cpu_vendor = "Intel"
    elif "AMD" in cpu_model:
        cpu_vendor = "AMD"
    else:
        cpu_vendor = None  

    cpu_frequency = int(round(psutil.cpu_freq().current, -2))
    
    # Get number of logical cores
    cpu_cores = psutil.cpu_count(logical=True)
    
    # Get CPU usage percentage
    cpu_usage = psutil.cpu_percent()
    
    # Get RAM info in GB
    ram = psutil.virtual_memory()
    ram_total = round(ram.total / (1024**3), 1)  # Convert bytes to GB
    ram_used = round(ram.used / (1024**3), 2)    # Convert bytes to GB
    
    return CPUMetrics(
        cpu_model=f"{cpu_model} {cpu_frequency} MHz",
        cpu_vendor=cpu_vendor,
        cpu_cores=cpu_cores,
        cpu_frequency=cpu_frequency,
        cpu_usage=cpu_usage,
        ram_total=ram_total,
        ram_used=ram_used
    )

# --- GPU ---

cpu_only_file = Path(os.getenv('WORDSLAB_WORKSPACE', '')) / '.cpu-only'
cpu_only = cpu_only_file.exists()

@dataclass
class GPUMetrics:
    gpu_model: str
    cuda_version: str
    gpu_usage: float  # percentage
    vram_total: float # GB
    vram_used: float  # GB

def get_gpu_metrics(gpu_id=0):
    pynvml.nvmlInit()
    handle = pynvml.nvmlDeviceGetHandleByIndex(gpu_id)

    gpu_model = pynvml.nvmlDeviceGetName(handle)
    driver_cuda_version = pynvml.nvmlSystemGetCudaDriverVersion_v2()
    cuda_version = f"{driver_cuda_version//1000}.{(driver_cuda_version%1000)//10}"

    utilization = pynvml.nvmlDeviceGetUtilizationRates(handle)
    gpu_usage = utilization.gpu
    vram_info = pynvml.nvmlDeviceGetMemoryInfo(handle)
    vram_total = round(vram_info.total / 1024**3,0)  # Convert bytes to GB
    vram_used = round(vram_info.used / 1024**3,2)   # Convert bytes to GB

    pynvml.nvmlShutdown()
    
    metrics = GPUMetrics(
        gpu_model=gpu_model,
        cuda_version=cuda_version,
        gpu_usage=gpu_usage,
        vram_total=vram_total,
        vram_used=vram_used
    )

    return metrics

# --- Disks ---

import ollama
import re

wordslab_home = os.getenv('WORDSLAB_HOME')
wordslab_workspace = os.getenv('WORDSLAB_WORKSPACE')
wordslab_models = os.getenv('WORDSLAB_MODELS')

wordslab_paths = { "/", wordslab_home, wordslab_workspace, wordslab_models }
wordslab_paths_to_env_variable = { "/":"System", wordslab_home:'WORDSLAB_HOME', wordslab_workspace:'WORDSLAB_WORKSPACE', wordslab_models:'WORDSLAB_MODELS'}

ollama_models_path = os.getenv('OLLAMA_DIR')
hf_home = os.getenv('HF_HOME')

mountpoints = {part.mountpoint:part.device for part in set(psutil.disk_partitions(all=True)) if part.fstype in {'ext4','xfs','fuse','overlay'} and not any(substring in part.mountpoint for substring in ["/mnt/", "nvidia", ".so"])}

def map_paths_to_devices(wordslab_paths, mountpoints):
    wordslab_paths_devices = {}
    sorted_mountpoints = sorted(mountpoints.keys(), key=len, reverse=True)
    for path in wordslab_paths:
        for mountpoint in sorted_mountpoints:
            if path.startswith(mountpoint):
                device = mountpoints[mountpoint]
                if device not in wordslab_paths_devices:
                    wordslab_paths_devices[device] = [path]
                else:
                    wordslab_paths_devices[device].append(path)
                break
    return wordslab_paths_devices

wordslab_paths_devices = map_paths_to_devices(wordslab_paths, mountpoints)

windows_disks = wordslab_platform == "WindowsSubsystemForLinux"
if windows_disks:
    wordslab_windows_home = (Path(wordslab_home) / ".WORDSLAB_WINDOWS_HOME").read_text().strip()
    wordslab_windows_workspace = (Path(wordslab_workspace) / ".WORDSLAB_WINDOWS_WORKSPACE").read_text().strip()
    wordslab_windows_models = (Path(wordslab_models) / ".WORDSLAB_WINDOWS_MODELS").read_text().strip()

    def windows_path_to_linux_vm_file(env_variable, windows_path):
        # Replace backslashes with forward slashes
        windows_path = windows_path.replace('\\', '/')
        # Replace the drive letter with /mnt/<drive>
        if len(windows_path) > 1 and windows_path[1] == ':':
            drive_letter = windows_path[0].lower()
            drive_path = f"/mnt/{drive_letter}"
            linux_file = Path(f"{drive_path}{windows_path[2:]}") / "ext4.vhdx"
        return (windows_path[:2], psutil.disk_usage(drive_path), env_variable, f"{windows_path}\\ext4.vhdx", linux_file.stat().st_size) 

    wordslab_windows_home_vm_file = windows_path_to_linux_vm_file("WORDSLAB_WINDOWS_HOME", wordslab_windows_home)
    wordslab_windows_workspace_vm_file = windows_path_to_linux_vm_file("WORDSLAB_WINDOWS_WORKSPACE", wordslab_windows_workspace)
    wordslab_windows_models_vm_file = windows_path_to_linux_vm_file("WORDSLAB_WINDOWS_MODELS", wordslab_windows_models)
   
@dataclass
class DirectoryMetrics: 
    name: str
    path: Path
    size: float # bytes

    def size_mb(self):
        return int(self.size/1024**2)
        
    def size_gb(self):
        return int(self.size/1024**3)

@dataclass
class DiskMetrics:
    name: str
    size_total: float # GB
    size_used: float  # GB
    directories: list[DirectoryMetrics]  

class KnownDirectoriesMetrics:
    operating_system: DirectoryMetrics
    root_user: DirectoryMetrics
    python_packages: list[DirectoryMetrics]
    jupyterlab: DirectoryMetrics
    codeserver: DirectoryMetrics
    ollama: DirectoryMetrics
    openwebui: DirectoryMetrics    
    jupyterlab_data: DirectoryMetrics
    codeserver_data: DirectoryMetrics
    openwebui_data: DirectoryMetrics
    workspace_projects: list[DirectoryMetrics]
    ollama_models: list[DirectoryMetrics]
    huggingface_models: list[DirectoryMetrics]

def get_directory_size(path):
   # Use the 'du' command to get the total size of the directory
    result = subprocess.run(['du', '-s', '--block-size=1', path], capture_output=True, text=True, check=True)
    # The output is in the format: <size>\t<path>
    size = int(result.stdout.split('\t')[0])
    return size

def get_vm_disks_metrics():
    wordslab_devices_usage = {item[0]:psutil.disk_usage(item[1][0]) for item in wordslab_paths_devices.items()}
    vm_disks_metrics = {}
    for disk_name,disk_usage in wordslab_devices_usage.items():
        vm_disk_metrics = DiskMetrics(
            name=disk_name,
            size_total=disk_usage.total / 1024**3,
            size_used=disk_usage.used / 1024**3,
            directories=[] 
        )
        vm_disks_metrics[disk_name] = vm_disk_metrics
        for path in reversed(wordslab_paths_devices[disk_name]):            
            dir_metrics = DirectoryMetrics(
                name=wordslab_paths_to_env_variable[path],
                path=path,
                size=-1
            )
            vm_disk_metrics.directories.append(dir_metrics)
    return vm_disks_metrics

def get_windows_disks_metrics():
    windows_disks_metrics = {}
    for disk_letter,disk_usage,env_variable,vm_file_path,file_size in [wordslab_windows_home_vm_file, wordslab_windows_workspace_vm_file, wordslab_windows_models_vm_file]:
        if disk_letter in windows_disks_metrics:
            windows_disk_metrics = windows_disks_metrics[disk_letter]
        else:
            windows_disk_metrics = DiskMetrics(
                name=disk_letter,
                size_total=disk_usage.total / 1024**3,
                size_used=disk_usage.used / 1024**3,
                directories=[] 
            )
            windows_disks_metrics[disk_letter] = windows_disk_metrics
        windows_disk_metrics.directories.append(
            DirectoryMetrics(
                name=env_variable,
                path=vm_file_path,
                size=file_size / 1024**3
            )
        )
    return windows_disks_metrics

def get_known_directories_metrics():
    dirs_metrics = KnownDirectoriesMetrics()
    # Operating system
    os_size = get_directory_size("/usr/bin") + get_directory_size("/usr/lib/x86_64-linux-gnu/") + get_directory_size("/usr/libexec") + get_directory_size("/usr/share")
    dirs_metrics.operating_system = DirectoryMetrics(name="Operating system", path="/usr", size=os_size)
    # Root user
    root_user_size = get_directory_size("/root")
    dirs_metrics.root_user = DirectoryMetrics(name="Root user", path="/root", size=root_user_size)
    # Python packages
    dirs_metrics.python_packages = []
    python_archive = f"{wordslab_home}/python/archive-v0/"
    for entry in os.listdir(python_archive):
        full_path = os.path.join(python_archive, entry)
        if os.path.isdir(full_path):
            for item in os.listdir(full_path):
                if item.endswith(".dist-info"):
                    package_name = item[:-len(".dist-info")]
                    size_bytes = get_directory_size(full_path)
                    if size_bytes > (1024 * 1024):
                        dirs_metrics.python_packages.append(DirectoryMetrics(name=package_name, path=full_path, size=size_bytes))
                    break  # Only process first .dist-info found
    dirs_metrics.python_packages.sort(key=lambda x: x.size, reverse=True)
    # Wordslab software
    path = f"{wordslab_home}/jupyterlab"
    dirs_metrics.jupyterlab = DirectoryMetrics(name="JupyterLab", path=path, size=get_directory_size(path))
    path = f"{wordslab_home}/code-server"
    dirs_metrics.codeserver = DirectoryMetrics(name="Visual Studio", path=path, size=get_directory_size(path))
    path = f"{wordslab_home}/ollama"
    dirs_metrics.ollama = DirectoryMetrics(name="Ollama", path=path, size=get_directory_size(path))
    path = f"{wordslab_home}/open-webui"
    dirs_metrics.openwebui = DirectoryMetrics(name="Open WebUI", path=path, size=get_directory_size(path))  
    path = f"{wordslab_workspace}/.jupyter"
    dirs_metrics.jupyterlab_data = DirectoryMetrics(name="JupyterLab data", path=path, size=get_directory_size(path))
    path = f"{wordslab_workspace}/.codeserver"
    dirs_metrics.codeserver_data = DirectoryMetrics(name="Visual Studio data", path=path, size=get_directory_size(path))
    path = f"{wordslab_workspace}/.openwebui"
    dirs_metrics.openwebui_data = DirectoryMetrics(name="Open WebUI data", path=path, size=get_directory_size(path))
    # Workspace projects
    dirs_metrics.workspace_projects = []
    project_dirs = [
        name for name in os.listdir(wordslab_workspace)
        if not name.startswith('.') and os.path.isdir(os.path.join(wordslab_workspace, name))
    ]
    for project_dir in project_dirs:
        project_fullpath = os.path.join(wordslab_workspace, project_dir)
        size_bytes = get_directory_size(project_fullpath)
        if size_bytes > (1024 * 1024):
            dirs_metrics.workspace_projects.append(DirectoryMetrics(name=project_dir, path=project_fullpath, size=size_bytes))
    dirs_metrics.workspace_projects.sort(key=lambda x: x.size, reverse=True)
    # Ollama models
    dirs_metrics.ollama_models = []
    try:
        models = ollama.list().models
    except:
        models = []
    models.sort(key=lambda m: m.size, reverse=True)
    for model in models:
        dirs_metrics.ollama_models.append(DirectoryMetrics(name=model.model, path=ollama_models_path, size=model.size))
    # Huggingface models
    dirs_metrics.huggingface_models = []
    hf_home_size = get_directory_size(hf_home)
    if hf_home_size > 0:    
        cache_dir = Path(hf_home) / "hub"
        hf_models_size = 0
        pattern = re.compile(r"models--([^/\\]+)--([^/\\]+)")
        for path in cache_dir.iterdir():
            if path.is_dir():
                match = pattern.fullmatch(path.name)
                if match:
                    org, model = match.groups()
                    model_id = f"{org}/{model}"
                    model_size = get_directory_size(path)
                    hf_models_size += model_size
                    dirs_metrics.huggingface_models.append(DirectoryMetrics(name=model_id, path=path.resolve(), size=model_size))    
        dirs_metrics.huggingface_models.sort(key=lambda x: x.size, reverse=True)
        dirs_metrics.huggingface_models.append(DirectoryMetrics(name="Models cache", path=hf_home, size=hf_home_size-hf_models_size))
    return dirs_metrics
    
# --- User interface ---

from fasthtml.common import *
from monsterui.all import *

# Create your app with the theme
hdrs = Theme.blue.headers()
app, rt = fast_app(hdrs=(*hdrs, Link(rel="icon", type="image/jpg", href="/favicon.jpg")), static_path="images")

@rt("/")
def get():
    return Title("Wordslab notebooks"), DivVStacked(
            A(DivHStacked(
                Img(src="wordslab-notebooks-small.jpg", width=96, height=96, cls="m-3"),
                Div(H1("Wordslab notebooks"),
                Div("Click on the title to access the documentation", cls=TextT.meta)),
                Div(wordslab_version, cls=TextT.meta)
            ), href="https://github.com/wordslab-org/wordslab-notebooks?tab=readme-ov-file#wordslab-notebooks---learn-and-build-with-ai-at-home", target="_blank"),
            DivCentered(
                H4("Applications"),
                DividerLine(y_space=1),
                cls="w-full"
            ),
            DivHStacked(
                ToolCard("Open WebUI", "Chat", "openwebui.jpg", openwebui_url),
                ToolCard("JupyterLab", "Learn", "jupyterlab.jpg", jupyterlab_url),
                ToolCard("Visual Studio", "Code", "vscode.jpg", vscode_url),
                Card(DivVStacked(
                    H3("User applications"),
                    Ol(
                        ToolLink("USER_APP1_PORT", app1_url),
                        ToolLink("USER_APP2_PORT", app2_url),
                        ToolLink("USER_APP3_PORT", app3_url),
                        ToolLink("USER_APP4_PORT", app4_url),
                        ToolLink("USER_APP5_PORT", app5_url)
                    )
                ))
            ),
            DivCentered(
                DivHStacked(H4("Virtual Machine", cls="mr-2"),P(f"on {wordslab_platform}", cls=TextT.meta), cls="mt-4"),
                DividerLine(y_space=1),
                cls="w-full"
            ),
            DivHStacked(
                CPUCard(),
                GPUCard() if not cpu_only else None,
                Card(Div("Linux disks: loading ..."), style="width:400px", hx_get=f"/vmdisks", hx_trigger="every 1s", hx_swap="outerHTML") if not windows_disks else None,
                Card(Div("Windows disks: loading ..."), style="width:400px", hx_get=f"/windisks", hx_trigger="every 1s", hx_swap="outerHTML") if windows_disks else None
            ),
            DivCentered(
                DivHStacked(H4("Storage directories size (MB)", cls="mr-2"), cls="mt-4"),
                DividerLine(y_space=1),
                cls="w-full"
            ),
            DivHStacked(Card(Div("Storage directories: loading ...")), hx_get=f"/knowndirs", hx_trigger="every 1s", hx_swap="outerHTML")
        )

def ToolCard(name, subtitle, image, url):
    return Card(
                A(DivVStacked(
                    H3(name),
                    DivCentered(
                        Img(src=image, style="height:96px; width:96px; object-fit:contain"),            
                        P(subtitle, cls="text-lg text-gray-400"),
                        cls="space-y-1"
                    ),
                    Span(url),
                    cls="space-y-3"), 
                href=url, target="_blank"),
            style="width:250px")
            
def ToolLink(name, url):
    return Li(A(
        DivHStacked(Span(name, cls=TextPresets.muted_sm), Span(url), cls="space-x-5"), 
        href=url, target="_blank"), cls="my-2")

@app.get("/cpu")
def CPUCard():
    cpumetrics = get_cpu_metrics()
    cpudesc = f"{cpumetrics.cpu_cores} cores @ {cpumetrics.cpu_frequency} Mhz"
    if cpumetrics.cpu_vendor is not null:
        cpudesc = f"{cpumetrics.cpu_vendor} " + cpudesc
    return Card(Div(
            DivHStacked(
                UkIcon(icon="microchip", width=24, height=24),
                H3("CPU"),
                Div(
                    P(cpudesc),
                    P(f"{cpumetrics.ram_total:.1f} GB RAM"),
                    cls="space-y-1 pl-2"
                ),
                cls="space-x-2"
            ),
            Grid(
                P("Usage"),P(f"{cpumetrics.cpu_usage} %"),Progress(value=cpumetrics.cpu_usage, max=100),
                P("Memory"),P(f"{cpumetrics.ram_used:.1f} GB"),Progress(value=cpumetrics.ram_used, max=cpumetrics.ram_total),
            cols=3, cls="space-y-2"),
            Div(cpumetrics.cpu_model, cls="text-xs text-gray-400"),
            cls="space-y-2"
        ),
        style="width:300px", hx_get=f"/cpu", hx_trigger="every 2s", hx_swap="outerHTML"
    )

@app.get("/gpu")
def GPUCard():
    gpumetrics = get_gpu_metrics()
    return Card(Div(
            DivHStacked(
                UkIcon(icon="cpu", width=24, height=24),
                H3("GPU"),
                Div(
                    P(gpumetrics.gpu_model),
                    P(f"{int(gpumetrics.vram_total)} GB VRAM"),
                    cls="space-y-1 pl-2"
                ) if not cpu_only else 
                Div(
                    P("Not available"),
                    P("CPU-only install"),
                    cls="space-y-1 pl-2"
                ),
                cls="space-x-2"
            ),
            Grid(
                P("Usage"),P(f"{gpumetrics.gpu_usage:.1f} %"),Progress(value=gpumetrics.gpu_usage, max=100),
                P("Memory"),P(f"{gpumetrics.vram_used:.1f} GB"),Progress(value=gpumetrics.vram_used, max=gpumetrics.vram_total),
            cols=3, cls="space-y-2") if not cpu_only else
            Grid(
                P("Usage"),P("Not available"),
                P("Memory"),P("Not available"),
            cols=2, cls="space-y-2"),
            Div(f"Cuda version: {gpumetrics.cuda_version}", cls="text-xs text-gray-400"),
            cls="space-y-2"
        ),
        style="width:300px", hx_get=f"/gpu", hx_trigger="every 2s", hx_swap="outerHTML"
    )

@app.get("/vmdisks")
def VmDisksCard():    
    return Card(DisksCardContent("Linux disks", "hard-drive", get_vm_disks_metrics()),
        style="width:400px", hx_get=f"/vmdisks", hx_trigger="every 60s", hx_swap="outerHTML"
    )

@app.get("/windisks")
def WindowsDisksCard():    
    return Card(DisksCardContent("Windows disks", "database", get_windows_disks_metrics()),
        style="width:400px", hx_get=f"/windisks", hx_trigger="every 60s", hx_swap="outerHTML"
    )

def DisksCardContent(title, icon, disks_metrics):
    return Div(
            DivHStacked(
                UkIcon(icon=icon, width=24, height=24),
                H3(title),
                cls="space-x-2"
            ),
            *[Div(Div(f"{disk_metrics.name} - {disk_metrics.size_used/disk_metrics.size_total*100:.1f} % used - {disk_metrics.size_used:.1f} GB / {disk_metrics.size_total:.1f} GB", cls="font-bold"),
                  Ul(*[Li(Div(f"{dir_metrics.name} - {dir_metrics.size:.1f} GB"), Div(dir_metrics.path, cls="text-gray-500 text-xs"), cls="ml-2 mt-2") for dir_metrics in disk_metrics.directories if dir_metrics.size>=0],
                    *[Li(Span(f"{dir_metrics.name} - "),Span(dir_metrics.path, cls="text-gray-500 text-xs")) for dir_metrics in disk_metrics.directories if dir_metrics.size<0])
                 ) for disk_metrics in disks_metrics.values()],
            cls="space-y-2"
        )
    
@app.get("/knowndirs")
def KnownDirectories():
    kdm = get_known_directories_metrics()
    table1 = Table(
        Th("System", span="2"),
        Tr(Td(kdm.operating_system.name),Td(kdm.operating_system.size_mb())),
        Tr(Td(kdm.root_user.name),Td(kdm.root_user.size_mb()))
    )
    table2 = Table(
        Th("Applications", span="2"),
        Tr(Td(kdm.jupyterlab.name),Td(kdm.jupyterlab.size_mb())),
        Tr(Td(kdm.codeserver.name),Td(kdm.codeserver.size_mb())),
        Tr(Td(kdm.ollama.name),Td(kdm.ollama.size_mb())),
        Tr(Td(kdm.openwebui.name),Td(kdm.openwebui.size_mb()))
    )
    table3_lines = []
    for idx,python_package in enumerate(kdm.python_packages):
        if idx>10: break
        table3_lines.append(Tr(Td(python_package.name),Td(python_package.size_mb())))
    table3 = Table(Th("Python packages", span="2"),*table3_lines)
    table4 = Table(
        Th("Applications data", span="2"),
        Tr(Td(kdm.jupyterlab_data.name),Td(kdm.jupyterlab_data.size_mb())),
        Tr(Td(kdm.codeserver_data.name),Td(kdm.codeserver_data.size_mb())),
        Tr(Td(kdm.openwebui_data.name),Td(kdm.openwebui_data.size_mb()))
    )
    table5_lines = []
    for idx,workspace_project in enumerate(kdm.workspace_projects):
        if idx>10: break
        table5_lines.append(Tr(Td(workspace_project.name),Td(workspace_project.size_mb())))
    table5 = Table(Th("Workspace projects", span="2"),*table5_lines)   
    table6_lines = []
    for idx,ollama_model in enumerate(kdm.ollama_models):
        if idx>10: break
        table6_lines.append(Tr(Td(ollama_model.name),Td(ollama_model.size_mb())))
    table6 = Table(Th("Ollama models", span="2"),*table6_lines) 
    table7_lines = []
    for idx,huggingface_model in enumerate(kdm.huggingface_models):
        if idx>10: break
        table7_lines.append(Tr(Td(huggingface_model.name),Td(huggingface_model.size_mb())))
    table7 = Table(Th("vLLM models", span="2"),*table7_lines) 
    return DivHStacked(
                Card(table1,table2,table4,cls="h-96 overflow-y-auto"),
                Card(table5,table3,cls="h-96 overflow-y-auto"),
                Card(table6,table7,cls="h-96 overflow-y-auto"),
                hx_get=f"/knowndirs", hx_trigger="every 60s", hx_swap="outerHTML"
            )
    
serve(port=dashboard_port)
