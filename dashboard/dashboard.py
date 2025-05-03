from fasthtml.common import *
from monsterui.all import *
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

# Create your app with the theme
hdrs = Theme.blue.headers()
app, rt = fast_app(hdrs=(*hdrs, Link(rel="icon", type="image/jpg", href="/favicon.jpg")), static_path="images", debug=True, live=True)

@rt("/")
def get():
    return Title("Wordslab notebooks"), DivVStacked(
            A(DivHStacked(
                Img(src="wordslab-notebooks-small.jpg", width=96, height=96, cls="m-3"),
                H1("Wordslab notebooks"),
                Div("version 2025-04", cls=TextT.meta)
            ), href="https://github.com/wordslab-org/wordslab-notebooks?tab=readme-ov-file#wordslab-notebooks---learn-and-build-with-ai-at-home", target="_blank"),
            DividerLine(lwidth=2, y_space=4),
            DivHStacked(
                ToolCard("Open WebUI", "openwebui.jpg", openwebui_url),
                ToolCard("Jupyter Lab", "jupyterlab.jpg", jupyterlab_url),
                ToolCard("Visual Studio", "vscode.jpg", vscode_url),
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
            )           
        )

def ToolCard(name, image, url):
    return Card(
            A(DivVStacked(
            H3(name),
            Img(src=image, style="height:96px; width:96px; object-fit:contain"),
            Span(url)
            ), href=url, target="_blank")
          )

def ToolLink(name, url):
    return Li(A(
        DivHStacked(Span(name, cls=TextPresets.muted_sm), Span(url), cls="space-x-5"), 
        href=url, target="_blank"), cls="my-1")

serve(port=dashboard_port)
