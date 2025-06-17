#!/bin/bash
echo "Simple Steam Login Test (Working Method)"
echo "======================================="

read -p "Enter Steam username: " STEAM_USER
read -s -p "Enter Steam password: " STEAM_PASS
echo ""

echo "Testing login for user: $STEAM_USER using the method that works..."

docker run --rm -it \
  -v "$(pwd):/data" \
  steamcmd/steamcmd:latest \
  +login "$STEAM_USER" "$STEAM_PASS" +quit

echo ""
echo "If login was successful, your credentials will work in GitHub Actions!"
