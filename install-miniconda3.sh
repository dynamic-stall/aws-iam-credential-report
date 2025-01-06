#!/bin/bash

##################################################
# Linux/macOS installation script for Miniconda3 #
##################################################

OS=$(uname -s)

install_miniconda_linux() {
    MACHINE=$(uname -m)
    DEFAULT_SH=$(basename "$SHELL")

    case "$MACHINE" in
        x86_64)
            MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
            ;;
        aarch64)
            MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
            ;;
        armv7l)
            MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-armv7l.sh"
            ;;
        s390x)
            MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-s390x.sh"
        *)
            echo "Unsupported machine architecture: $MACHINE"
            echo "Please install manually. Instructions found at 'https://docs.anaconda.com/miniconda/install/'"
            echo "Exiting..."
            exit 1
            ;;
    esac

    case "$DEFAULT_SH" in
      bash|zsh)
        SH_FLAGS="-b -u -p ~/miniconda3"
        ;;
      fish)
        SH_FLAGS="-u -p ~/miniconda3"
        ;;
      ksh)
        echo "ksh is not fully supported for Miniconda installation."
        echo "Please refer to the Miniconda documentation for ksh-specific instructions."
        echo "Exiting..."
        exit 1
        ;;
      *)
        echo "Unknown shell: $SHELL"
        echo "Please close and re-open your terminal window for the installation to take effect."
        echo "Then, run 'conda init --all'."
        echo "Exiting..."
        exit 1
        ;;
    esac

    mkdir -p ~/miniconda3
    wget "$MINICONDA_URL" -O ~/miniconda3/miniconda.sh || { echo "Error: Failed to download Miniconda installer"; exit 1; }
    "$DEFAULT_SH" ~/miniconda3/miniconda.sh $SH_FLAGS
    rm -f ~/miniconda3/miniconda.sh

    if [[ "$DEFAULT_SH" == "bash" || "$DEFAULT_SH" == "zsh" ]]; then
      source ~/.${DEFAULT_SH}rc
    elif [[ "$DEFAULT_SH" == "fish" ]]; then
        source ~/.config/fish/config.fish
    fi

    conda init --all

    echo "Miniconda installed and initialized."
}

install_miniconda_macos() {
    MACHINE=$(uname -m)
    case "$MACHINE" in
        x86_64)
            MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
            ;;
        arm64)
            MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
            ;;
        *)
            echo "Unsupported machine architecture: $MACHINE"
            echo "Exiting..."
            exit 1
            ;;
    esac

    mkdir -p ~/miniconda3
    curl "$MINICONDA_URL" -o ~/miniconda3/miniconda.sh || {
        echo "Error: Failed to download Miniconda installer"; exit 1;
    }

    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
    source ~/miniconda3/bin/activate
    conda init --all
    echo "Miniconda installed and initialized."
}

# main install logic
case "$OS" in
    Linux*)
        echo "Detected OS: Linux"
        if [ ! -d "~/miniconda3" ]; then
            echo "Miniconda3 not found. Installing..."
            install_miniconda_linux
        else
            echo "Miniconda3 is already installed."
        fi
        ;;
    Darwin*)
        echo "Detected OS: macOS"
        if [ ! -d "~/miniconda3" ]; then
            echo "Miniconda3 not found. Installing..."
            install_miniconda_macos
        else
            echo "Miniconda3 is already installed."
        fi
        ;;
    *)
        echo "Unsupported OS: $OS"
        echo "Exiting..."
        exit 1
        ;;
esac
