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

git push -u origin main


