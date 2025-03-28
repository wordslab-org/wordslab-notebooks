from fasthtml.common import *
import os

version = os.getenv("WORDSLAB_VERSION")

jupyterlab_url = int(os.getenv("JUPYTERLAB_URL"))
vscode_url = int(os.getenv("VSCODE_URL"))
openwebui_url = int(os.getenv("OPENWEBUI_URL"))
app1_url = int(os.getenv("USER_APP1_URL"))
app2_url = int(os.getenv("USER_APP2_URL"))
app3_url = int(os.getenv("USER_APP3_URL"))
app4_url = int(os.getenv("USER_APP2_URL"))
app5_url = int(os.getenv("USER_APP3_URL"))

app,rt = fast_app()

@rt("/")
def get(): return Titled(f"wordslab notebooks {version}",
                         H3("Main tools"),
                         Ul(
                             ToolLink("JupyterLab", jupyterlab_url),
                             ToolLink("Visual Studio Code", vscode_url),
                             ToolLink("Open WebUI", openwebui_url)),
                         H3("User apps"),
                         Ul(
                             ToolLink("User application 1", app1_port),
                             ToolLink("User application 2", app2_port),
                             ToolLink("User application 3", app3_port),
                             ToolLink("User application 4", app4_port),
                             ToolLink("User application 5", app5_port)
                         )
                        )

def ToolLink(name, url):
    return Li(name + ": ", A(url, href=url, target="_blank"))  

serve(port=dashboard_port)
