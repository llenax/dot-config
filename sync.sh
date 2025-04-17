# clear the shell's hash table
hash -r

CONFIG_DIR=$HOME/.config
GIT_DIR=$CONFIG_DIR/git

SSH_PUBKEY_FILE=$HOME/.ssh/id_ed25519.pub
SSH_ALLOWED_SIGNERS_FILE=$GIT_DIR/allowed_signers

require_apt_pkg() {
    package_apt=$1
    package_name=$2

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


for dir in ./*; do
    if [ -d $dir ]; then
	remote=$CONFIG_DIR/${dir:2}
	
	rm -rf $remote
	mkdir -p $remote
	cp -r "$dir"/* "$remote"
    fi
done

require_apt_pkg "git"
require_apt_pkg "gnupg2" "gpg2"
require_apt_pkg "ripgrep" "rg"

if [ -d $GIT_DIR ] && [ -f $SSH_PUBKEY_FILE ]; then
    email=$(git config --get user.email)
    ns="namespaces=\"git\""
    pubkey=$(cat $SSH_PUBKEY_FILE)
    echo "$email $ns $pubkey" >> $SSH_ALLOWED_SIGNERS_FILE
fi

