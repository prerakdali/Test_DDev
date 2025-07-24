# 🐳 Datadog ddev Docker Environment

This repository sets up a containerized development environment for working with **Datadog integrations** using `ddev`. It automates the following:

---

## ✅ What This Environment Does

1. **Uses Ubuntu 24.04.2 LTS (Noble Numbat)** as the base OS.
2. **Clones the following repos** to `/home/ubuntu/dd/`:
   - `https://github.com/DataDog/integrations-core.git`
   - `https://github.com/DataDog/integrations-extras.git`
3. **Installs Python 3.12, pip, pipx, and venv**, and ensures `pipx` is available in the shell path.
4. **Installs the Datadog `ddev` CLI tool** via pipx.
5. **Sets up Docker and Docker Compose**, and allows the container to access the host’s Docker daemon via socket mount.

---

## ⚙️ Requirements

- Docker Engine installed on the host
- Docker group exists on the host
- Docker Compose v2 (`docker compose`, not `docker-compose` legacy)

---

## 🧭 Usage Guide
## 🛠 1. Clone this repository

git clone <your-repo-url>
cd <your-repo-directory>

## 🔧 2. Fix Docker Socket Permissions (Host Machine)
sudo chgrp docker /var/run/docker.sock.
sudo chmod 660 /var/run/docker.sock

## 🧱 3. Build and Start the Container
docker compose build
docker compose up -d

## 🐚 4. Enter the Container
docker exec -it ddev-dev bash

## 🧪 5. Inside the Container
newgrp docker



