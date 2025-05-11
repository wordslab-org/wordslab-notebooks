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
    ram_total = round(ram.total / (1024**3), 0)  # Convert bytes to GB
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

wordslab_home = os.getenv('WORDSLAB_HOME')
wordslab_workspace = os.getenv('WORDSLAB_WORKSPACE')
wordslab_models = os.getenv('WORDSLAB_MODELS')

wordslab_paths = { "/", wordslab_home, wordslab_workspace, wordslab_models }
wordslab_paths_to_env_variable = { "/":"LINUX", wordslab_home:'WORDSLAB_HOME', wordslab_workspace:'WORDSLAB_WORKSPACE', wordslab_models:'WORDSLAB_MODELS'}

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
    env_variable: str
    path: Path
    size_used: float # GB

@dataclass
class DiskMetrics:
    name: str
    size_total: float # GB
    size_used: float  # GB
    directories: list[DirectoryMetrics]

def get_directory_size(path):
   # Use the 'du' command to get the total size of the directory
    result = subprocess.run(['du', '-s', '--block-size=1', path], capture_output=True, text=True, check=True)
    # The output is in the format: <size>\t<path>
    size = int(result.stdout.split('\t')[0])
    return size

def get_disks_metrics():
    worsdlab_paths_sizes = {path:get_directory_size(path) for path in [wordslab_home, wordslab_workspace, wordslab_models]}
    if wordslab_workspace.startswith(wordslab_home):
        worsdlab_paths_sizes[wordslab_home] -= worsdlab_paths_sizes[wordslab_workspace]
    if wordslab_models.startswith(wordslab_home):
        worsdlab_paths_sizes[wordslab_home] -= worsdlab_paths_sizes[wordslab_models]
    wordslab_devices_usage = {item[0]:psutil.disk_usage(item[1][0]) for item in wordslab_paths_devices.items()}
    disks_metrics = []
    for disk_name,disk_usage in wordslab_devices_usage.items():
        disk_metrics = DiskMetrics(
            name=disk_name,
            size_total=disk_usage.total / 1024**3,
            size_used=disk_usage.used / 1024**3,
            directories=[] 
        )
        disks_metrics.append(disk_metrics)
        already_counted_size = 0
        for path in reversed(wordslab_paths_devices[disk_name]):
            path_size = worsdlab_paths_sizes[path] if path!='/' else disk_usage.used
            path_size = path_size - already_counted_size
            dir_metrics = DirectoryMetrics(
                env_variable=wordslab_paths_to_env_variable[path],
                path=path,
                size_used=path_size / 1024**3
            )
            disk_metrics.directories.append(dir_metrics)
            already_counted_size = already_counted_size + path_size
    return disks_metrics

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
                env_variable=env_variable,
                path=vm_file_path,
                size_used=file_size / 1024**3
            )
        )
    return windows_disks_metrics

# --- User interface ---

from fasthtml.common import *
from monsterui.all import *

# Create your app with the theme
hdrs = Theme.blue.headers()
app, rt = fast_app(hdrs=(*hdrs, Link(rel="icon", type="image/jpg", href="/favicon.jpg")), static_path="images", debug=True, live=True)

@rt("/")
def get():
    return Title("Wordslab notebooks"), DivVStacked(
            A(DivHStacked(
                Img(src="wordslab-notebooks-small.jpg", width=96, height=96, cls="m-3"),
                H1("Wordslab notebooks"),
                Div(f"version {wordslab_version}", cls=TextT.meta)
            ), href="https://github.com/wordslab-org/wordslab-notebooks?tab=readme-ov-file#wordslab-notebooks---learn-and-build-with-ai-at-home", target="_blank"),
            DivCentered(
                H4("Applications"),
                DividerLine(y_space=1),
                cls="w-full"
            ),
            DivHStacked(
                ToolCard("Open WebUI", "Chat", "openwebui.jpg", openwebui_url),
                ToolCard("Jupyter Lab", "Learn", "jupyterlab.jpg", jupyterlab_url),
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
                GPUCard()
#                DisksCard("Virtual disks", "hard-drive", get_disks_metrics()),
#                DisksCard("Windows disks", "database", get_windows_disks_metrics()) if windows_disks else None
            )           
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
                    P(f"{int(cpumetrics.ram_total)} GB RAM"),
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
        style="width:300px"
    )

def GPUCard():
    if not cpu_only:
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
            Div(f"Wordslab notebooks will not use any GPU", cls="text-xs text-gray-400"),
            cls="space-y-2"
        ),
        style="width:300px"
    )

def DisksCard(title, icon, disks_metrics):
    return Card(Div(
            DivHStacked(
                UkIcon(icon=icon, width=24, height=24),
                H3(title),
                cls="space-x-2"
            ),
            cls="space-y-2"
        ),
        style="width:300px"
    )


serve(port=dashboard_port)
