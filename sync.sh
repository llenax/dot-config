# clear the shell's hash table
hash -r

CONFIG_DIR=$HOME/.config
GIT_DIR=$CONFIG_DIR/git

SSH_PUBKEY_FILE=$HOME/.ssh/id_ed25519.pub
SSH_ALLOWED_SIGNERS_FILE=$GIT_DIR/allowed_signers

require_apt_pkg() {
  local package_apt=$1
  local package_name=$2

  if [ -z "$package_name" ]; then
    package_name=$package_apt
  fi

  echo "checking for: $package_name"

  if [ -f "$(command -v $package_name)" ]; then
    echo "found: $(command -v $package_name)"
  else
    echo "$package_name not found. Attempting to install..."
    if sudo apt install -y $package_apt; then
      echo "$package_name installed successfully"
    else
      echo "failed to install $package_name"
      exit 1
    fi
  fi

  echo ----------------------
}

link_local_scripts () {
  local file_path=$1
  local file_name=$(basename $file_path)

  touch $file_path
  echo '#!/usr/bin/env bash' > $file_path
  echo 'export PATH=$PATH:$HOME/.local/scripts' >> $file_path

  if ! grep -qs "source $file_path" $HOME/.bashrc; then
    echo "linking scripts: $file_name"
    echo -e "\\nsource $file_path" >> $HOME/.bashrc
  fi
}

for dir in ./*; do
  if [ -d $dir ]; then
    remote=$CONFIG_DIR/${dir:2}

    rm -rf $remote
    mkdir -p $remote
    cp -r "$dir"/* "$remote"
  fi
done

# TODO: add another way of getting packages
# most apt package versions are old
# (achieving "stable" ^-^)
# latest stable versions are not same
# with APT's "stable" versions.
require_apt_pkg "git"
require_apt_pkg "gnupg2" "gpg2"
require_apt_pkg "ripgrep" "rg"
require_apt_pkg "sqlite3"

if [ -d $GIT_DIR ] && [ -f $SSH_PUBKEY_FILE ]; then
    email=$(git config --get user.email)
    ns="namespaces=\"git\""
    pubkey=$(cat $SSH_PUBKEY_FILE)
    echo "$email $ns $pubkey" >> $SSH_ALLOWED_SIGNERS_FILE
fi

if [ -f "./local_apps" ]; then
  rm $HOME/.local_apps > /dev/null 2>&1;
  cp ./local_apps $HOME/.local_apps
  source ./local_apps
fi

if [ -f "$HOME/.local_scripts" ]; then
  rm $HOME/.local_scripts > /dev/null 2>&1;
fi

link_local_scripts "$HOME/.local_scripts"
