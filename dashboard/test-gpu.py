from dataclasses import dataclass
from pathlib import Path
import os
import pynvml

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

# Example usage:

cpu_only_file = Path(os.getenv('WORDSLAB_WORKSPACE', '')) / '.cpu-only'
if not cpu_only_file.exists():
    metrics = get_gpu_metrics()
    print(metrics)
else:
    print("CPU only install")
