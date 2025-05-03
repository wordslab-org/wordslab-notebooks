import psutil
import subprocess
from dataclasses import dataclass

@dataclass 
class CPUMetrics:
    cpu_model: str
    cpu_cores: int
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
        cpu_usage=cpu_usage,
        ram_total=ram_total,
        ram_used=ram_used
    )

# Example usage
metrics = get_cpu_metrics() 
print(metrics)
