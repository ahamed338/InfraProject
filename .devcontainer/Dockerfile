FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies & tools
RUN apt-get update && apt-get install -y \
    unzip curl wget jq python3-pip awscli apt-transport-https ca-certificates gnupg software-properties-common bash-completion

# Install Terraform
ARG TERRAFORM_VERSION=1.4.6
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install cloudflared
RUN curl -LO https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared-linux-amd64.deb && \
    rm cloudflared-linux-amd64.deb

# Install LocalStack
RUN pip3 install localstack

# Set environment variables
ENV AWS_ACCESS_KEY_ID=test
ENV AWS_SECRET_ACCESS_KEY=test
ENV AWS_REGION=us-east-1
ENV AWS_DEFAULT_REGION=us-east-1
ENV LOCALSTACK_HOST=localhost
ENV AWS_ENDPOINT_URL=http://localhost:4566

WORKDIR /workspace

COPY . /workspace

# Expose ports for LocalStack and nginx etc.
EXPOSE 4566 8080 8000

CMD ["bash", "-c", "localstack start & bash"]
