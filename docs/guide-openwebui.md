# Concepts

Instance: an private installation of Open WebUI on your machine.

Data privacy and security: all data is locally stored on your machine. Open WebUI ensures strict confidentiality and no external requests for enhanced privacy and security.

Users: the first account created on your Open WebUI instance gains Administrator privileges, subsequent sign-ups start with Pending status, requiring Administrator approval for access.

Administrator: controls user management and system settings

Groups: sets of users who can access the same protected resources.

Models: personalized assistants which can be built with Open WebUI. Models can reference private knowledge and access private resources, they can cost money if they use external services.

Language Models: local or remote AI services which can execute text (and image) instructions and return text answers. Language models are then configured and extended with knowledge, tools, filters groupes in complex pipelines to create Open WebUI "models".

Models access control: All models are private by default. Models must be explicitly shared via groups or by being made public. If a model is assigned to a group, only members of that group can see it. If a model is made public, anyone on the instance can see it.
 
Single-User mode / Multi-account mode: the first time your start your instance, you can set the environment variable WEBUI_AUTH=False to bypass the login page and configure a single-user setup. Turning off authentication is only possible for fresh installations without any existing users. If there are already users registered, you cannot disable authentication directly. You cannot switch between single-user mode and multi-account mode after this change.

# Configuration

## Launch

Command line syntax
- ENV_VAR1=VAL1 ENV_VAR2=VAL2 **open-webui serve** --host 0.0.0.0 --port 8080
- ENV_VARx=VALx : set environments variables as needed to configure your Open WebUI instance, all the environment variables are described below
- --host 0.0.0.0 : Open WebUI web server will listen on this host (use 127.0.0.1 to restrict access from your machine only, use 0.0.0.0 to enable access from other machines on your local network).
- --port 8080 : Open WebUI web server will listen on this port.

RESET_CONFIG_ON_START (default: False)
- Resets the config.json file on startup.

SAFE_MODE (default: False)
- Enables safe mode, which disables potentially unsafe features
- To be more specific: updates the database and deactivates all functions during Open WebUI startup

## Instance setup

WEBUI_URL (default: http://localhost:3000)
- Specifies the URL where the Open WebUI is reachable
- Used to generate links, for hooks and callbacks

DEFAULT_LOCALE (default: en)
- Sets the default locale for the application.

DATA_DIR (default: ./data)
- Specifies the base directory for data storage, including uploads, cache, vector database, etc.

FUNCTIONS_DIR (default: ./functions)
- Specifies the directory for custom functions.

USE_CUDA_DOCKER (default: False)
- True	: requires a Nvidia GPU in your machine and Pytorch installed with CUDA 12+ support
- for audio - speech to text: loads the WhisperModel from faster_whisper on the device "cuda" (GPU) or "cpu"
- retrieval augmented generation - knowledge: loads the SentenceTransformer from sentence_transformers on the device "cuda" (GPU) or "cpu"

ENV (default: dev)
- dev	: Enables the FastAPI API docs on /docs
  - set docs_url="/docs" and openapi_url="/openapi.json"
  - open a route "/ef/{text}" to get text embeddings
- prod	: Automatically configures several environment variables
  - sets OLLAMA_BASE_URL="http://host.docker.internal:11434"

## Database config

DATABASE_URL
- Supports SQLite and Postgres
- Specifies the database URL to connect to, default is sqlite:///${DATA_DIR}/webui.db
- Note: changing the URL does not migrate data between databases
- Documentation of the URL scheme: https://docs.sqlalchemy.org/en/20/core/engines.html#database-urls

Database connection pool
- DATABASE_POOL_SIZE (default: 0) : Specifies the size of the database connexion pool. A value of 0 disables connexion pooling.
- DATABASE_POOL_MAX_OVERFLOW  (default: 0) : Specifies the database pool max overflow.
- DATABASE_POOL_TIMEOUT (default: 30) : Specifies the database pool timeout in seconds to get a connection.
- DATABASE_POOL_RECYCLE (default: 3600) : Specifies the database pool recycle time in seconds.
- Documentation of the database connexion pool: https://docs.sqlalchemy.org/en/20/core/pooling.html

## UI personalization

WEBUI_NAME (default: Open WebUI)
- Sets the main WebUI name. Appends (Open WebUI) if overridden

STATIC_DIR (default: ./static)
- Specifies the directory for static files, such as
  - {STATIC_DIR}/favicon.png
  - {STATIC_DIR}/splash.png

CUSTOM_NAME
- Polls https://api.openwebui.com/api/v1/custom/{CUSTOM_NAME} for json metadata
  - WEBUI_NAME = data["name"]
  - {STATIC_DIR}/favicon.png = download_url(data["logo"])
  - {STATIC_DIR}/splash.png = download_url(data['splash'])

WEBUI_BANNERS (default: [])
- list of dict, list of banners to show to users
- Format of banners are: [{"id": "string","type": "string [info, success, warning, error]","title": "string","content": "string","dismissible": False,"timestamp": 1000}]

## Authentication and security

WEBUI_AUTH (default: True)
- True	: Multi-account mode
- False	: Single-User mode, disables authentication

Single Sign On
- configure Single Sign On with ENABLE_OAUTH_SIGNUP=True and ENABLE_LOGIN_FORM=False
- configure WEBUI_AUTH_TRUSTED_EMAIL_HEADER / WEBUI_AUTH_TRUSTED_NAME_HEADER
- see https://docs.openwebui.com/features/sso

WEBUI_SECRET_KEY
- Overrides the randomly generated secret key used to encrypt and decrypt the user session data in the JSON Web Token
- If not explicitly provided through this environment variable, the secret key is randomly generated on the first start, then it is stored and reloaded from the file ".webui_secret_key" in the current directory

JWT_EXPIRES_IN (default: -1)
- int, sets the JWT expiration time in seconds, a value of -1 disables expiration

WEBUI_SESSION_COOKIE_SAME_SITE (default: lax)
- Sets the SameSite attribute for session cookies (fastapi.Response.set_cookie)
  - lax 	: Sets the SameSite attribute to lax, allowing session cookies to be sent with requests initiated by third-party websites
  - strict: Sets the SameSite attribute to strict, blocking session cookies from being sent with requests initiated by third-party websites.
  - none	: Sets the SameSite attribute to none, allowing session cookies to be sent with requests initiated by third-party websites, but only over HTTPS.

WEBUI_SESSION_COOKIE_SECURE (default: False)
- Sets the Secure attribute for session cookies if set to True (fastapi.Response.set_cookie)

CONTENT_SECURITY_POLICY
- Sets the content-security-policy HTTP header. The HTTP Content-Security-Policy response header allows website administrators to control resources the user agent is allowed to load for a given page. With a few exceptions, policies mostly involve specifying server origins and script endpoints. This helps guard against cross-site scripting attacks.
- Example: default-src 'self' 'unsafe-inline' 'unsafe-eval'; img-src 'self' https://* data:; child-src 'none'; font-src 'self' data:; worker-src 'self';

CORS_ALLOW_ORIGIN (default: *)
- Sets the allowed origins for Cross-Origin Resource Sharing (CORS).

## Users management

ENABLE_SIGNUP (default: True)
- True	: Enables user account creation
- False	: Disables user account creation

DEFAULT_USER_ROLE (default: pending)
- pending	: New users are pending until their accounts are manually activated by an admin
- user		: New users are automatically activated with regular user permissions
- admin		: New users are automatically activated with administrator permissions

SHOW_ADMIN_DETAILS (default: True)
- Toggles whether to show admin user details in the interface.

ADMIN_EMAIL
- Sets the admin email shown by SHOW_ADMIN_DETAILS

WEBHOOK_URL
- Sets a webhook for integration with Slack/Microsoft Teams
- Sends a message when a user signs up or when a model returns an answer while a user is not active

## Language Models

DEFAULT_MODELS
- name 	: Sets a default Language Model 	

ENABLE_MODEL_FILTER (default: False)
- False	: Disables Language Model filtering
- True	: Enable Language Model filtering with MODEL_FILTER_LIST

MODEL_FILTER_LIST
- Sets a Language Model filter list, semicolon-separated
- Example: llama3.1:instruct;gemma2:latest

AIOHTTP_CLIENT_TIMEOUT (default: 300)
- Specifies the maximum amount of time in seconds the client will wait for a response from a Language Model before timing out (connections to Ollama and OpenAI endpoints)
- If set to an empty string (' '), the timeout will be set to None, effectively disabling the timeout and allowing the client to wait indefinitely

## Chat features

USER_PERMISSIONS_CHAT_DELETION
- True	: Toggles user permission to delete chats.

USER_PERMISSIONS_CHAT_EDITING
- True	: Toggles user permission to edit chats.

USER_PERMISSIONS_CHAT_TEMPORARY
- True	: Toggles user permission to create temporary chats.

ENABLE_MESSAGE_RATING
- True	: Enables message rating feature.

## Chat privacy

ENABLE_ADMIN_EXPORT
- True	 : Controls whether admin users can export data.

ENABLE_ADMIN_CHAT_ACCESS
- True	: Enables admin users to access all chats.

ENABLE_COMMUNITY_SHARING
- True	: Controls whether users are shown the share to community button.

## Ollama API

ENABLE_OLLAMA_API (default: True)
- Enables the use of Ollama APIs.

OLLAMA_BASE_URL (default: http://localhost:11434)
- Configures the Ollama backend URL.

OLLAMA_BASE_URLS
- Configures load-balanced Ollama backend hosts, separated by ;. Takes precedence over OLLAMA_BASE_URL.

## OpenAI API

ENABLE_OPENAI_API (default: True)
- Description: Enables the use of OpenAI APIs.

OPENAI_API_BASE_URL (default: https://api.openai.com/v1)
- Configures the OpenAI base API URL.

OPENAI_API_BASE_URLS
- Supports balanced OpenAI base API URLs, semicolon-separated.
- Example: http://host-one:11434;http://host-two:11434

OPENAI_API_KEY
- Sets the OpenAI API key.

OPENAI_API_KEYS
- Supports multiple OpenAI API keys, semicolon-separated.
- Example: sk-124781258123;sk-4389759834759834

AIOHTTP_CLIENT_TIMEOUT_OPENAI_MODEL_LIST
- Sets the timeout in seconds for fetching the OpenAI model list. This can be useful in cases where network latency requires a longer timeout duration to successfully retrieve the model list.

ENABLE_FORWARD_USER_INFO_HEADERS (default: False)
- Forwards user information (name, id, email, and role) as X-headers to OpenAI API
- If enabled, the following headers are forwarded: X-OpenWebUI-User-Name, X-OpenWebUI-User-Id, X-OpenWebUI-User-Email, X-OpenWebUI-User-Role

## Tasks

TASK_MODEL
- The default model to use for tasks such as title and web search query generation when using Ollama models.

TASK_MODEL_EXTERNAL
- The default model to use for tasks such as title and web search query generation when using OpenAI-compatible endpoints.

TITLE_GENERATION_PROMPT_TEMPLATE
- Prompt to use when generating chat titles.
- Default: Create a concise, 3-5 word title with an emoji as a title for the prompt in the given language ...

SEARCH_QUERY_GENERATION_PROMPT_TEMPLATE
- Prompt to use when generating search queries.
- Default: Assess the need for a web search based on the current question and prior interactions ...

TOOLS_FUNCTION_CALLING_PROMPT_TEMPLATE
- Prompt to use when calling tools.
- Default: Available Tools: {{TOOLS}} ... if a function tool matches, construct and return a JSON object in the format {\"name\": \"functionName\", \"parameters\": {\"requiredFunctionParamKey\": \"requiredFunctionParamValue\"}} ...

## Retrieval Augmented Generation

RAG_TOP_K (default: 5)
- Sets the default number of results to consider when using RAG.

RAG_RELEVANCE_THRESHOLD (default: 0.0)
- Sets the relevance threshold to consider for documents when used with reranking.

ENABLE_RAG_HYBRID_SEARCH (default: False)
- Enables the use of ensemble search with BM25 + ChromaDB, with reranking using sentence_transformers models.

VECTOR_DB (default: chroma)
- Specifies which vector database system to use
  - 'chroma' for ChromaDB
  - 'milvus' for Milvus
- This setting determines which vector storage system will be used for managing embeddings.

CHROMA_TENANT (default: default_tenant)
- Sets the tenant for ChromaDB to use for RAG embeddings.

CHROMA_DATABASE (default: default_database)
- Sets the database in the ChromaDB tenant to use for RAG embeddings.

CHROMA_HTTP_HOST
- Description: Specifies the hostname of a remote ChromaDB Server.
- Uses a local ChromaDB instance if not set.

CHROMA_HTTP_PORT (default: 8000)
- Specifies the port of a remote ChromaDB Server.

CHROMA_HTTP_HEADERS
- Comma-separated list of HTTP headers to include with every ChromaDB request.
- Example: Authorization=Bearer heuhagfuahefj,User-Agent=OpenWebUI.

CHROMA_HTTP_SSL (default: False)
- Controls whether or not SSL is used for ChromaDB Server connections.

CHROMA_CLIENT_AUTH_PROVIDER
- Specifies auth provider for remote ChromaDB Server.
- Example: chromadb.auth.basic_authn.BasicAuthClientProvider

CHROMA_CLIENT_AUTH_CREDENTIALS
- Specifies auth credentials for remote ChromaDB Server.
- Example: username:password

MILVUS_URI (default: ${DATA_DIR}/vector_db/milvus.db)
- Specifies the URI for connecting to the Milvus vector database. 
- This can point to a local or remote Milvus server based on the deployment configuration.

ENABLE_RAG_WEB_LOADER_SSL_VERIFICATION (default: True)
- Enables TLS certification verification when browsing web pages for RAG.

RAG_EMBEDDING_ENGINE
- Selects an embedding engine to use for RAG.
  - Leave empty for Default (SentenceTransformers) - Uses SentenceTransformers for embeddings.
  - ollama - Uses the Ollama API for embeddings.
  - openai - Uses the OpenAI API for embeddings.

PDF_EXTRACT_IMAGES (default: False)
- extracts images from PDFs using OCR when loading documents.

RAG_EMBEDDING_MODEL (default: sentence-transformers/all-MiniLM-L6-v2)
- Sets a model for embeddings. Locally, a Sentence-Transformer model is used.

RAG_EMBEDDING_MODEL_AUTO_UPDATE (default: False)
- Toggles automatic update of the Sentence-Transformer model.

RAG_EMBEDDING_MODEL_TRUST_REMOTE_CODE (default: False)
- Determines whether or not to allow custom models defined on the Hub in their own modeling files.

RAG_TEMPLATE
- Template to use when injecting RAG documents into chat completion
- Default: You are given a user query, some textual context and rules, ... You have to answer the query based on the context while respecting the rules ...

RAG_RERANKING_MODEL
Type: str
Description: Sets a model for reranking results. Locally, a Sentence-Transformer model is used.
RAG_RERANKING_MODEL_AUTO_UPDATE
Type: bool
Default: False
Description: Toggles automatic update of the reranking model.
RAG_RERANKING_MODEL_TRUST_REMOTE_CODE
Type: bool
Default: False
Description: Determines whether or not to allow custom models defined on the Hub in their own modeling files for reranking.
RAG_OPENAI_API_BASE_URL
Type: str
Default: ${OPENAI_API_BASE_URL}
Description: Sets the OpenAI base API URL to use for RAG embeddings.
RAG_OPENAI_API_KEY
Type: str
Default: ${OPENAI_API_KEY}
Description: Sets the OpenAI API key to use for RAG embeddings.
RAG_EMBEDDING_OPENAI_BATCH_SIZE
Type: int
Default: 1
Description: Sets the batch size for OpenAI embeddings.
ENABLE_RAG_LOCAL_WEB_FETCH
Type: bool
Default: False
Description: Enables local web fetching for RAG. Enabling this allows Server Side Request Forgery attacks against local network resources.
YOUTUBE_LOADER_LANGUAGE
Type: str
Default: en
Description: Sets the language to use for YouTube video loading.
CHUNK_SIZE
Type: int
Default: 1500
Description: Sets the document chunk size for embeddings.
CHUNK_OVERLAP
Type: int
Default: 100
Description: Specifies how much overlap there should be between chunks.
CONTENT_EXTRACTION_ENGINE
Type: str (tika)
Options:
Leave empty to use default
tika - Use a local Apache Tika server
Description: Sets the content extraction engine to use for document ingestion.
TIKA_SERVER_URL
Type: str
Default: http://localhost:9998
Description: Sets the URL for the Apache Tika server.
RAG_FILE_MAX_COUNT
Type: int
Default: 10
Description: Sets the maximum number of files that can be uploaded at once for document ingestion.
RAG_FILE_MAX_SIZE
Type: int
Default: 100 (100MB)
Description: Sets the maximum size of a file that can be uploaded for document ingestion.

## Functions and tools




---




ENABLE_RAG_WEB_LOADER_SSL_VERIFICATION
- True 	: default
- False	: Bypass SSL Verification for RAG on Websites

FRONTEND_BUILD_DIR (default: ../build)
- Specifies the location of the built frontend files.

WEBUI_BUILD_HASH (default: dev-build)
- Used for identifying the Git SHA of the build for releases


Prepare the instance
----

Version 0.5.1 => "allow installing with Python 3.12"

- Dockefile - builds the Docker image with Pytorch CUDA support
  - installs pytorch cuda (cu121) or pytorch cpu
  - installs requirements.txt in both cases
  - loads SentenceTransformer(os.environ['RAG_EMBEDDING_MODEL'], device='cpu') in both cases
  - loads WhisperModel(os.environ['WHISPER_MODEL'], device='cpu', compute_type='int8', download_root=os.environ['WHISPER_MODEL_DIR']) in both cases
  - says # If you use CUDA the whisper and embedding model will be downloaded on first use
- Starts the backend with torch, cuddn and cublas libraries in LD_LIBRARY-PATH
  - says "CUDA is enabled, appending LD_LIBRARY_PATH to include torch/cudnn & cublas libraries."
  - exports LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/python3.11/site-packages/torch/lib:/usr/local/lib/python3.11/site-packages/nvidia/cudnn/lib"
- in the serve() function, if USE_CUDA_DOCKER is True
  - changes LD_LIBRARY_PATH in the same way
  - asserts if torch.cuda.is_available()
  - if it is not the case, reverts to USE_CUDA_DOCKER=False
- in env.py
  - sets DEVICE_TYPE = "cuda" or "cpu"
- in audio.py
  - from faster_whisper import WhisperModel

        faster_whisper_kwargs = {
            "model_size_or_path": model,
            "device": DEVICE_TYPE if DEVICE_TYPE and DEVICE_TYPE == "cuda" else "cpu",
            "compute_type": "int8",
            "download_root": WHISPER_MODEL_DIR,
            "local_files_only": not auto_update,
        }

        whisper_model = WhisperModel(**faster_whisper_kwargs)
- in retrieval.py
  - from sentence_transformers import SentenceTransformer
     
        ef = SentenceTransformer(
                get_model_path(embedding_model, auto_update),
                device=DEVICE_TYPE,
                trust_remote_code=RAG_EMBEDDING_MODEL_TRUST_REMOTE_CODE,
            )


- Enables GPU acceleration for local Whisper and embeddings