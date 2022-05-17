#!/bin/bash

### WARNING: Please ensure to navigate to the directory containing WHG repos
###          before executing this script. This way the hooks will only be set
###          up for the repos under that directory, leaving others unaffected.

WHG_CONFIG_FILENAME=git-whg-hook.gitconfig
HOOK_REPO="git-hooks"
WHG_HOOKS_REPO="git@github.com:whitehatgaming/$HOOK_REPO.git"

# Formatting helpers
bold=$(tput bold)
normal=$(tput sgr0)

# Assume this script is run from the directory containing other WHG repos.
WHG_REPO_DIR=$(pwd)
echo "The directory '${bold}${WHG_REPO_DIR}${normal}' will be configured so git"
echo "adds WHG commit hooks to all git repos in it."
echo
echo "Press ENTER to continue or Control-C to cancel."
read

## Create the WHG git hook config file, replacing it if it already exists to
## allow for updates to this script.
cat > $WHG_CONFIG_FILENAME << HOOK
[core]
    hooksPath = $WHG_REPO_DIR/$HOOK_REPO
HOOK

## Clone the hooks repo, or update to the latest version if it already exists.
if [ ! -d $HOOK_REPO/.git ]
then
    git clone $WHG_HOOKS_REPO
else
    cd $HOOK_REPO
    git pull --rebase
    cd ..
fi

## Ensure the user's main gitconfig knows to include the hook for WHG repos.
## Using the git command ensures we can run this script multiple times without
## issue.
git config --global \
    "includeIf.gitdir:$WHG_REPO_DIR/.path" \
    "$WHG_REPO_DIR/$WHG_CONFIG_FILENAME"
