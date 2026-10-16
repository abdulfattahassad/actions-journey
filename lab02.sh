#!/bin/bash

mkdir -p .github/workflows/

cat > .github/workflows/inspect.yml << 'EOF'

name: job02
on: push
jobs:
 job02:
     runs-on: ubuntu-latest
     steps:
        - name: download the repo 
          uses: actions/checkout@v4
        - name: list the file
          run: |
            uname -a
            ls -la   
        - name: print the file
          run: |
            find . -type f | wc -l
              
EOF

actionlint  .github/workflows/inspect.yml 

git add .

git commit -m "this is second workflow called isnpect"





cd /root/actions-journey

# Remove any broken/missing remote just in case
git remote remove origin 2>/dev/null || true

# Add your GitHub repository as the origin remote
git remote add origin https://github.com/abdulfattahassad/actions-journey.git


git pull origin main --allow-unrelated-histories

# Push your code to GitHub
git push -u origin main




