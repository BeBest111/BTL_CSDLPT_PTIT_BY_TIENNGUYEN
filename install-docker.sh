#!/bin/bash
# ============================================================================
# DOCKER INSTALLATION SCRIPT FOR LINUX
# ============================================================================
# Mục đích: Tự động cài đặt Docker và Docker Compose trên Linux
# Tác giả: Nhóm 5 - CSDLPT - PTIT
# Nguồn: https://docs.docker.com/desktop/setup/install/linux/
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# ============================================================================
# DETECT OS
# ============================================================================

detect_os() {
    print_header "DETECTING OPERATING SYSTEM"
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VER=$VERSION_ID
        print_success "Detected OS: $PRETTY_NAME"
    else
        print_error "Cannot detect OS!"
        exit 1
    fi
    echo ""
}

# ============================================================================
# INSTALL DOCKER ENGINE (Ubuntu/Debian)
# ============================================================================

install_docker_ubuntu() {
    print_header "INSTALLING DOCKER ENGINE ON UBUNTU/DEBIAN"
    
    # Update package index
    print_info "Updating package index..."
    sudo apt-get update
    
    # Install prerequisites
    print_info "Installing prerequisites..."
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    # Add Docker's official GPG key
    print_info "Adding Docker's GPG key..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Set up repository
    print_info "Setting up Docker repository..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index again
    sudo apt-get update
    
    # Install Docker Engine
    print_info "Installing Docker Engine, containerd, and Docker Compose..."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    print_success "Docker Engine installed successfully!"
    echo ""
}

# ============================================================================
# CONFIGURE DOCKER
# ============================================================================

configure_docker() {
    print_header "CONFIGURING DOCKER"
    
    # Add current user to docker group
    print_info "Adding user '$USER' to docker group..."
    sudo usermod -aG docker $USER
    
    # Start and enable Docker service
    print_info "Starting Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker
    
    print_success "Docker service started and enabled"
    echo ""
}

# ============================================================================
# VERIFY INSTALLATION
# ============================================================================

verify_installation() {
    print_header "VERIFYING INSTALLATION"
    
    # Check Docker version
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version)
        print_success "Docker installed: $DOCKER_VERSION"
    else
        print_error "Docker not found!"
        exit 1
    fi
    
    # Check Docker Compose
    if docker compose version &> /dev/null; then
        COMPOSE_VERSION=$(docker compose version)
        print_success "Docker Compose installed: $COMPOSE_VERSION"
    else
        print_error "Docker Compose not found!"
        exit 1
    fi
    
    # Test Docker
    print_info "Testing Docker with hello-world image..."
    if sudo docker run --rm hello-world &> /dev/null; then
        print_success "Docker is working correctly!"
    else
        print_warning "Docker test failed, but installation is complete"
    fi
    
    echo ""
}

# ============================================================================
# POST-INSTALLATION MESSAGE
# ============================================================================

post_installation() {
    print_header "INSTALLATION COMPLETED!"
    
    echo -e "${GREEN}✓ Docker Engine installed${NC}"
    echo -e "${GREEN}✓ Docker Compose installed${NC}"
    echo -e "${GREEN}✓ Docker service started${NC}"
    echo -e "${GREEN}✓ User added to docker group${NC}"
    echo ""
    
    print_warning "IMPORTANT: You need to logout and login again for group changes to take effect!"
    echo ""
    echo "Or run this command to apply changes immediately:"
    echo -e "${YELLOW}  newgrp docker${NC}"
    echo ""
    
    print_info "After logout/login, verify Docker:"
    echo "  docker --version"
    echo "  docker compose version"
    echo "  docker run hello-world"
    echo ""
    
    print_info "Then run the setup script:"
    echo "  ./docker-setup.sh"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    clear
    print_header "DOCKER INSTALLATION FOR LINUX"
    echo "This script will install Docker Engine and Docker Compose"
    echo ""
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_error "Do not run this script as root!"
        echo "Run as normal user: ./install-docker.sh"
        exit 1
    fi
    
    detect_os
    
    # Check if Docker is already installed
    if command -v docker &> /dev/null; then
        print_warning "Docker is already installed!"
        docker --version
        echo ""
        read -p "Do you want to reinstall? (yes/no): " REINSTALL
        if [ "$REINSTALL" != "yes" ]; then
            echo "Installation cancelled."
            exit 0
        fi
        echo ""
    fi
    
    # Install based on OS
    case $OS in
        ubuntu|debian|pop)
            install_docker_ubuntu
            ;;
        *)
            print_error "Unsupported OS: $OS"
            echo "Please install Docker manually: https://docs.docker.com/engine/install/"
            exit 1
            ;;
    esac
    
    configure_docker
    verify_installation
    post_installation
    
    print_success "Setup completed successfully! 🎉"
}

# Run main function
main
