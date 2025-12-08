#!/bin/bash

# LLM Research Marketplace Installation Script
# Installs the complete LLM research skills collection

set -e

echo "🚀 Installing LLM Research Marketplace..."

# Check if running from the repository directory
if [ -f ".claude-plugin/marketplace.json" ] && [ -d "skills" ]; then
    echo "📍 Installing from local directory..."
    LOCAL_INSTALL=true
else
    echo "📥 Installing from GitHub..."
    LOCAL_INSTALL=false
fi

if [ "$LOCAL_INSTALL" = true ]; then
    # Local installation
    MARKETPLACE_PATH=$(pwd)
    echo "🔧 Adding local marketplace from: $MARKETPLACE_PATH"
    claude plugin marketplace add "$MARKETPLACE_PATH"

    echo "📦 Installing LLM Research Marketplace plugin..."
    claude plugin install llm-research@LLM-Research-Marketplace
else
    # Remote installation
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    echo "📥 Cloning llm-research-marketplace from GitHub..."
    git clone https://github.com/syfyufei/llm-research-marketplace.git
    cd llm-research-marketplace

    echo "🔧 Adding marketplace..."
    claude plugin marketplace add .

    echo "📦 Installing LLM Research Marketplace plugin..."
    claude plugin install llm-research@LLM-Research-Marketplace

    echo "🧹 Cleaning up temporary files..."
    cd ~
    rm -rf "$TEMP_DIR"
fi

echo ""
echo "✨ LLM Research Marketplace installed successfully!"
echo ""
echo "📚 Available Skills:"
echo "   - research-memory: Academic research memory management"
echo ""
echo "🎉 You can now use these skills in any Claude Code session:"
echo "   'Research Memory, help me get back up to speed with my project'"
echo "   'Log this work session to Research Memory'"
echo ""
echo "📚 Commands:"
echo "   - List plugins: claude plugin list"
echo "   - Update: claude plugin update llm-research"
echo "   - Uninstall: claude plugin uninstall llm-research"
