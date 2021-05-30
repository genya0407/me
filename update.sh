#!/bin/bash
set -ue

echo "generate sites..."
cd /app
bundle exec ruby site.rb
echo "finished generation"

