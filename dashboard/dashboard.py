# --- Applications properties ---

import os

wordslab_version = os.getenv("WORDSLAB_VERSION")
dashboard_port=int(os.getenv("DASHBOARD_PORT"))

jupyterlab_url = os.getenv("JUPYTERLAB_URL")
vscode_url = os.getenv("VSCODE_URL")
openwebui_url = os.getenv("OPENWEBUI_URL")

app1_url = os.getenv("USER_APP1_URL")
app2_url = os.getenv("USER_APP2_URL")
app3_url = os.getenv("USER_APP3_URL")
app4_url = os.getenv("USER_APP2_URL")
app5_url = os.getenv("USER_APP3_URL")

# --- Machine properties ---

from dataclasses import dataclass
from pathlib import Path
import psutil
import pynvml
import subprocess

cpu_only_file = Path(os.getenv('WORDSLAB_WORKSPACE', '')) / '.cpu-only'
cpu_only = cpu_only_file.exists()

@dataclass 
class CPUMetrics:
    cpu_model: str
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
        cpu_cores=cpu_cores,
        cpu_frequency=cpu_frequency,
        cpu_usage=cpu_usage,
        ram_total=ram_total,
        ram_used=ram_used
    )

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
                )),
                cls="space-x-10"
            ),
            DivCentered(
                H4("Machine", cls="mt-4"),
                DividerLine(y_space=1),
                cls="w-full"
            ),
            DivHStacked(
                CPUCard(),
                GPUCard(),
                Card("Disk")
            )           
        )

def ToolCard(name, subtitle, image, url):
    return Card(
            A(DivVStacked(
            H3(name),
            DivCentered(
            Img(src=image, style="height:96px; width:96px; object-fit:contain"),            
            P(subtitle, cls="text-lg text-gray-400")
            , cls="space-y-1"),
            Span(url),
            cls="space-y-3"), href=url, target="_blank")
          )

def ToolLink(name, url):
    return Li(A(
        DivHStacked(Span(name, cls=TextPresets.muted_sm), Span(url), cls="space-x-5"), 
        href=url, target="_blank"), cls="my-2")

def CPUCard():
    cpumetrics = get_cpu_metrics()
    return Card(Div(
            DivHStacked(
                UkIcon(icon="microchip", width=24, height=24),
                H3("CPU"),
                Div(
                    P(f"{cpumetrics.cpu_cores} cores @ {cpumetrics.cpu_frequency} Mhz"),
                    P(f"{int(cpumetrics.ram_total)} GB memory"),
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
    gpumetrics = get_gpu_metrics()
    return Card(Div(
            DivHStacked(
                UkIcon(icon="cpu", width=24, height=24),
                H3("GPU"),
                Div(
                    P(gpumetrics.gpu_model),
                    P(f"{int(gpumetrics.vram_total)} GB VRAM"),
                    cls="space-y-1 pl-2"
                ),
                cls="space-x-2"
            ),
            Grid(
                P("Usage"),P(f"{gpumetrics.gpu_usage:.1f} %"),Progress(value=gpumetrics.gpu_usage, max=100),
                P("Memory"),P(f"{gpumetrics.vram_used:.1f} GB"),Progress(value=gpumetrics.vram_used, max=gpumetrics.vram_total),
            cols=3, cls="space-y-2"),
            Div(f"CUDA version {gpumetrics.cuda_version}", cls="text-xs text-gray-400"),
            cls="space-y-2"
        ),
        style="width:300px"
    )

serve(port=dashboard_port)
