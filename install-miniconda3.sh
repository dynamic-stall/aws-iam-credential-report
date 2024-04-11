#!/bin/bash

# Check the OS type
OS=$(uname -s)

# Function to install Miniconda3
install_miniconda() {
    # Determine Miniconda download URL based on OS
    case "$OS" in
        Linux*)
            MACHINE=$(uname -m)
            if [ "$MACHINE" = "x86_64" ]; then
                MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
            elif [ "$MACHINE" = "aarch64" ]; then
                MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
            elif [ "$MACHINE" = "armv7l" ]; then
                MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-armv7l.sh"
            else
                echo "Unsupported machine architecture: $MACHINE"
                exit 1
            fi
            ;;
        Darwin*)
            MACHINE=$(uname -m)
            if [ "$MACHINE" = "x86_64" ]; then
                MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
            elif [ "$MACHINE" = "arm64" ]; then
                MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
            else
                echo "Unsupported machine architecture: $MACHINE"
                exit 1
            fi
            ;;
        *)
            echo "Unsupported OS: $OS"
            exit 1
            ;;
    esac

    # Download Miniconda3 installer
    echo "Downloading Miniconda3 installer..."
    curl -O $MINICONDA_URL || { echo "Error: Failed to download Miniconda installer"; exit 1; }

    # Install Miniconda3
    echo "Installing Miniconda3..."
    sudo bash Miniconda3-latest*.sh -b -p /usr/bin/miniconda3

    # Cleanup
    rm Miniconda3-latest*.sh
}

# Check if Miniconda3 is already installed
if [ ! -d "miniconda3" ]; then
    echo "Miniconda3 not found. Installing..."
    install_miniconda
else
    echo "Miniconda3 is already installed."
fi

