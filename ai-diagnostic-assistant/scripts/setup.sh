#!/bin/bash

# Setup script for the project

set -e

# Copy .env.example to .env if not exists
if [ ! -f .env ]; then
  cp .env.example .env
  echo ".env created. Please edit it with your API keys."
else
  echo ".env already exists."
fi

# You can add more setup steps here if needed

echo "Setup complete. Run docker-compose up -d to start."
