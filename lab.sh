#!/bin/bash

# 1. Navigate to repository directory
cd /root/actions-journey

# 2. Configure Git identity
git config --global user.name "abdulfattahassad"
git config --global user.email "fattahassad@gmail.com"
git config --global pull.rebase false

# 3. Ensure remote URL is correct
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/abdulfattahassad/actions-journey.git

# 4. Create workflow directory and file
mkdir -p .github/workflows
cat > .github/workflows/inspect.yml <<'YML'
name: inspect
on: push
jobs:
  inspect:
    runs-on: ubuntu-latest
    steps:
      - name: Check out the repository
        uses: actions/checkout@v4
      - name: Show runner details
        run: |
          uname -a
          ls -la
      - name: Count files in the repository
        run: find . -type f | wc -l
YML

# 5. Git workflow: Pull remote changes first, commit, then push
git add .
git commit -m "Add inspect workflow" || echo "Already committed"
git pull origin main --allow-unrelated-histories || true
git push -u origin main

# ==========================================
# Instructor's Verification Polling Script
# ==========================================
echo "Waiting for GitHub Actions run to complete..."

tok=$(cat /root/.github/token)
login=$(curl -s -H "Authorization: token $tok" https://api.github.com/user | jq -r '.login // empty')
[ -n "$login" ] || { echo "No GitHub login - check /root/.github/token" >&2; exit 1; }

sha=$(git -C /root/actions-journey rev-parse HEAD)
run=""

for _ in $(seq 1 18); do
  run=$(curl -s -H "Authorization: token $tok" \
    "https://api.github.com/repos/$login/actions-journey/actions/workflows/inspect.yml/runs?per_page=20" \
    | jq -c --arg sha "$sha" '[.workflow_runs[]? | select(.head_sha == $sha and .status == "completed")][0] // empty')
  [ -n "$run" ] && break
  sleep 10
done

[ -n "$run" ] || { echo "inspect.yml has no finished run for $sha after 180s" >&2; exit 1; }

printf '%s' "$run" | jq -r '"run \(.id) finished with conclusion \(.conclusion)"'
