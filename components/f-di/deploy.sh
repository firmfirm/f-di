#!/bin/bash
set -e # exit with nonzero exit code if anything fails

git config --global user.name "Travis CI"
git config --global user.email "martynas@firmfirm.co"
git config --global push.default matching
git config --global url."https://${GH_TOKEN}@".insteadOf            git://
git config --global url."https://${GH_TOKEN}@github.com/".insteadOf git@github.com:
git config --global url."https://${GH_TOKEN}@github.com/".insteadOf https://github.com/

# Update bower version
bower version patch -m "[ci skip] publish version %s to Bower"
git remote set-url origin "https://${GH_TOKEN}@${GH_REF}"
git push --follow-tags origin HEAD:master > /dev/null 2>&1

# Push to gh-pages
npm install -g yo firmfirm/generator-polymer
echo -e "firmfirm\n\n\n\n" | yo polymer:gh > /dev/null 2>&1
