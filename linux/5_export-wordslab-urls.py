import os
from pathlib import Path
import socket

# Get wordslab container ports
jupyterlab_port = os.getenv("JUPYTERLAB_PORT")
vscode_port = os.getenv("VSCODE_PORT")
openwebui_port = os.getenv("OPENWEBUI_PORT")
user_app1_port = os.getenv("USER_APP1_PORT")
user_app2_port = os.getenv("USER_APP2_PORT")
user_app3_port = os.getenv("USER_APP3_PORT")
user_app4_port = os.getenv("USER_APP4_PORT")
user_app5_port = os.getenv("USER_APP5_PORT")
dahsboard_port = os.getenv("DASHBOARD_PORT")
wordslab_ports = [jupyterlab_port, vscode_port, openwebui_port, user_app1_port, user_app2_port, user_app3_port, user_app4_port, user_app5_port, dahsboard_port]

# Check if apps are exposed as https
workspace_path = Path(os.getenv("WORDSLAB_WORKSPACE"))
use_https = (workspace_path / ".secrets/certificate.pem").exists()
url_scheme = "https://" if use_https else "http://"

# Get platform and compute wordslab apps endpoints
platform = os.getenv("WORDSLAB_PLATFORM")

if platform=="WindowsSubsystemForLinux":
    home_path = Path(os.getenv("WORDSLAB_HOME"))
    windows_ip_address_file = home_path / ".WORDSLAB_WINDOWS_IP"
    if windows_ip_address_file.exists():
        ip_address = windows_ip_address_file.read_text().strip()
    else:
        ip_address = "127.0.0.1"
    endpoints = [f"{url_scheme}{ip_address}:{port}" for port in wordslab_ports]

elif platform=="Jarvislabs.ai":
    from jlclient import jarvisclient
    from jlclient.jarvisclient import *
    jarvislabs_api_token_file = workspace_path / ".secrets/jarvislabs-api-key"
    jarvislabs_api_token = jarvislabs_api_token_file.read_text().strip()
    jarvisclient.token = jarvislabs_api_token
    machine_id = os.getenv("MACHINE_ID")   
    instance = User.get_instance(machine_id)
    endpoints = instance.endpoints[1:]

elif platform=="Runpod.io": 
    pod_id = os.getenv("RUNPOD_POD_ID") 
    endpoints = [f"{url_scheme}{pod_id}-{port}.proxy.runpod.net" for port in wordslab_ports]

elif platform=="Vast.ai": 
    public_ip = os.getenv("PUBLIC_IPADDR")
    public_ports = [os.getenv(f"VAST_TCP_PORT_{port}") for port in wordslab_ports]
    endpoints = [f"{url_scheme}{public_ip}:{public_port}" for public_port in public_ports]

elif platform=="UnknownLinux":
    if use_https:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip_address = s.getsockname()[0]
        s.close()
    else:
        ip_address = "127.0.0.1"
    endpoints = [f"{url_scheme}{ip_address}:{port}" for port in wordslab_ports]

# Export URLs in environment variables
print(f"export JUPYTERLAB_URL={endpoints[0]}")
print(f"export VSCODE_URL={endpoints[1]}")
print(f"export OPENWEBUI_URL={endpoints[2]}")
print(f"export USER_APP1_URL={endpoints[3]}")
print(f"export USER_APP2_URL={endpoints[4]}")
print(f"export USER_APP3_URL={endpoints[5]}")
print(f"export USER_APP4_URL={endpoints[6]}")
print(f"export USER_APP5_URL={endpoints[7]}")

# For now, the dashboard URL is http only
print(f"export DASHBOARD_URL={endpoints[8].replace('https:','http:')}")
