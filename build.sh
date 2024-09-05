#!/bin/bash

# Check the operating system and install the cross-compiler.
if [[ $(uname) == "Darwin" ]]; then
    # MacOS (after installing MacPorts)
    sudo port install x86_64-w64-mingw32-gcc
elif [[ $(uname) == "Linux" ]]; then
    # Ubuntu
    sudo apt-get install mingw-w64
else
    echo "Unsupported operating system."
fi

# Check if Rust is already installed
if ! command -v rustc &> /dev/null; then
    echo "Rust is not installed. Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Rust is already installed."
fi

# Create output dir.
mkdir -p binary/

# Build for Linux/MacOS.
cargo build
cp target/debug/webserver_code_generator binary
rm -r target

# Build for Windows
rustup target add x86_64-pc-windows-gnu
cargo build --target x86_64-pc-windows-gnu
cp target/x86_64-pc-windows-gnu/debug/webserver_code_generator.exe binary
rm -r target
