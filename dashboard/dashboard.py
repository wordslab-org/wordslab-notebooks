from fasthtml.common import *
import os

version = os.getenv("WORDSLAB_VERSION")

dashboard_port = int(os.getenv("DASHBOARD_PORT"))
jupyterlab_port = int(os.getenv("JUPYTERLAB_PORT"))
vscode_port = int(os.getenv("VSCODE_PORT"))
openwebui_port = int(os.getenv("OPENWEBUI_PORT"))
vllm_port = int(os.getenv("VLLM_PORT"))
gradio_port = int(os.getenv("GRADIO_PORT"))
argilla_port = int(os.getenv("ARGILLA_PORT"))
app1_port = int(os.getenv("USER_APP1_PORT"))
app2_port = int(os.getenv("USER_APP2_PORT"))
app3_port = int(os.getenv("USER_APP3_PORT"))

app,rt = fast_app()

@rt("/")
def get(): return Titled(f"wordslab notebooks {version}",
                         H3("Main tools"),
                         Ul(
                             ToolLink("JupyterLab", jupyterlab_port),
                             ToolLink("Visual Studio Code", vscode_port),
                             ToolLink("Open WebUI", openwebui_port)),
                         H3("Reserved ports"),
                         Ul(
                             ToolLink("vLLM", vllm_port),
                             ToolLink("Gradio", gradio_port),
                             ToolLink("Argilla", argilla_port)),
                         H3("User apps"),
                         Ul(
                             ToolLink("User application 1", app1_port),
                             ToolLink("User application 2", app2_port),
                             ToolLink("User application 3", app3_port)
                         )
                        )

def ToolLink(name, port):
    url = f"http://127.0.0.1:{port}"
    return Li(name + ": ", A(url, href=url, target="_blank"))  

serve(port=dashboard_port)