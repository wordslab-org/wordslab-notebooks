from fasthtml.common import *
import os

version = os.getenv("WORDSLAB_VERSION")

dashboard_port=int(os.getenv("DASHBOARD_PORT"))

jupyterlab_url = os.getenv("JUPYTERLAB_URL")
vscode_url = os.getenv("VSCODE_URL")
openwebui_url = os.getenv("OPENWEBUI_URL")
app1_url = os.getenv("USER_APP1_URL")
app2_url = os.getenv("USER_APP2_URL")
app3_url = os.getenv("USER_APP3_URL")
app4_url = os.getenv("USER_APP2_URL")
app5_url = os.getenv("USER_APP3_URL")

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
                             ToolLink("User application 1", app1_url),
                             ToolLink("User application 2", app2_url),
                             ToolLink("User application 3", app3_url),
                             ToolLink("User application 4", app4_url),
                             ToolLink("User application 5", app5_url)
                         )
                        )

def ToolLink(name, url):
    return Li(name + ": ", A(url, href=url, target="_blank"))

serve(port=dashboard_port)
