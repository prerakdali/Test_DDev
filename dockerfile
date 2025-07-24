FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Step 1: Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    curl \
    ca-certificates \
    gnupg \
    git \
    sudo \
    python3.12 \
    python3.12-venv \
    python3-pip && \
    apt-get clean

# Step 2: Create non-root user with sudo
RUN useradd -m -s /bin/bash ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ubuntu
WORKDIR /home/ubuntu

# Step 3: Update PATH and bashrc
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
ENV PATH="/home/ubuntu/.local/bin:$PATH"

# Step 4: Install pipx and ddev
RUN python3.12 -m pip install --user pipx --break-system-packages && \
    ~/.local/bin/pipx ensurepath && \
    ~/.local/bin/pipx install "git+https://github.com/DataDog/integrations-core.git#subdirectory=ddev"

# Step 5: Clone integrations repos
RUN mkdir -p /home/ubuntu/dd && cd /home/ubuntu/dd && \
    git clone https://github.com/DataDog/integrations-core.git && \
    git clone https://github.com/DataDog/integrations-extras.git

# Step 6: Configure ddev
RUN /home/ubuntu/.local/bin/ddev config set core /home/ubuntu/dd/integrations-core && \
    /home/ubuntu/.local/bin/ddev config set extras /home/ubuntu/dd/integrations-extras

# Step 7: Install Docker CLI
USER root
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu noble stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 8: Ensure 'docker' group exists and add user
RUN groupadd -f docker && usermod -aG docker ubuntu

# Final switch back to user and working directory
USER ubuntu
WORKDIR /home/ubuntu/dd
CMD ["/bin/bash"]
