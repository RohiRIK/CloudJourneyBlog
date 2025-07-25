#!/bin/bash

# Fabric AI First-Time Setup Script
# Reference: https://github.com/danielmiessler/Fabric/tree/main

echo "[Fabric Setup] Checking for Go installation..."
if ! command -v go &> /dev/null; then
  echo "Go is not installed. Please install Go from https://go.dev/doc/install and re-run this script."
  exit 1
fi

echo "[Fabric Setup] Installing Fabric..."
go install github.com/danielmiessler/fabric/cmd/fabric@latest

echo "[Fabric Setup] Running Fabric setup..."
fabric --setup --env .env

echo "[Fabric Setup] Fabric is installed and initialized!"

echo "\n---"
echo "[INFO] To use Ollama and Gemini as fallback models:"
echo "- Fabric supports multiple models. You can set the model using the --model flag."
echo "- For Ollama, make sure you have Ollama installed (https://ollama.com/download) and running."
echo "- For Gemini, you need an API key and endpoint."
echo "- Example usage: fabric --model ollama --pattern summarize 'your text'"
echo "- Example usage: fabric --model gemini --pattern summarize 'your text'"
echo "- You can list available models with: fabric --listmodels"

echo "For more details, see: https://github.com/danielmiessler/Fabric/tree/main"
