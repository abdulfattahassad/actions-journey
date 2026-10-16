#!/bin/bash

git init 

git config-global user.name"abdulfattahassad"
git config-global user.email"fattahassad@gmail.com"


git branch -M main

 


mkdir -p .github/workflows

cat > .github/workflows/hello.yml << 'EOF'


name: lab01
on: push 
jobs:
 lab01:
   runs-on: ubuntu-latest
   steps:
      -run: echo "hello"


EOF

git add .

git commit -m "create second orflow"


git remote add origin https://github.com/abdulfattahassad/actions-journey.git
git push -u origin main


