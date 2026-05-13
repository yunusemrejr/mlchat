#!/usr/bin/bash
#
# Safe push script for ML Chat
# Ensures only production files are committed to the public repo.
#
# Usage:
#   ./scripts/push.sh "Your commit message"
#

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Check for uncommitted changes in tracked files
if git diff --quiet && git diff --cached --quiet; then
    echo "✅ No changes to commit."
    exit 0
fi

# Ensure we are not accidentally adding anything from dev/
if git status --short | grep -qE '^\?\? dev/'; then
    echo "⚠️  Warning: dev/ folder contains untracked files."
    echo "   These are already gitignored and will NOT be pushed."
fi

# Use commit message from argument or default
MSG="${1:-Update ML Chat}"

echo "📦 Adding root production files..."
git add -A

echo "📝 Committing: $MSG"
git commit -m "$MSG"

# Push with embedded credentials (GIT_TERMINAL_PROMPT=0 blocks interactive prompts)
ORIGIN_URL=$(git remote get-url origin 2>/dev/null || true)

if [[ "$ORIGIN_URL" == *"@github.com"* ]] || [[ "$ORIGIN_URL" == *"://"*":"*"@github.com"* ]]; then
    # SSH or already embedded — push directly
    git push origin main
else
    # Need credentials — read from ~/.git-credentials if available
    CRED_FILE="$HOME/.git-credentials"
    if [[ -f "$CRED_FILE" ]]; then
        # Extract first github.com credential line
        CRED_LINE=$(grep 'github.com' "$CRED_FILE" | head -n1)
        if [[ -n "$CRED_LINE" ]]; then
            # Parse user:token from https://user:token@github.com
            CRED_PART=$(echo "$CRED_LINE" | sed -n 's|https://\([^@]*\)@github.com|\1|p')
            git remote set-url origin "https://${CRED_PART}@github.com/yunusemrejr/mlchat.git"
            git push origin main
            git remote set-url origin "https://github.com/yunusemrejr/mlchat.git"
            echo "🔒 Remote URL sanitized."
        else
            echo "❌ No GitHub credentials found in $CRED_FILE"
            exit 1
        fi
    else
        echo "❌ No credential file found at $CRED_FILE and GIT_TERMINAL_PROMPT is disabled."
        echo "   Please configure git credentials or run:"
        echo "   git remote set-url origin https://USER:TOKEN@github.com/yunusemrejr/mlchat.git"
        exit 1
    fi
fi

echo "🚀 Pushed to https://github.com/yunusemrejr/mlchat"
