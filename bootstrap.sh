#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm git openssh

REPO_SSH="git@github.com:sunbox-sudo/FlaxENV.git"
REPO_HTTPS="https://github.com/sunbox-sudo/FlaxENV.git"
DEST="$HOME/.FlaxENV"

# Clones git repo (SSH first, HTTPS as fallback)
if [ -d "$DEST/.git" ]; then
	echo "Already installed"
else
	if GIT_SSH_COMMAND="ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10" \
		git clone "$REPO_SSH" "$DEST"; then
		echo "Cloned with SSH"
	else
		echo "SSH clone failed, falling back to HTTPS"
		rm -rf "$DEST"   # remove any partial clone
		if git clone "$REPO_HTTPS" "$DEST"; then
			echo "Cloned with HTTPS"
			echo "Tip: once your SSH key is set up, run: git -C \"$DEST\" remote set-url origin $REPO_SSH"
		else
			echo "Both SSH and HTTPS clones failed" >&2
			exit 1
		fi
	fi
fi

# Create symlink for flax-env
mkdir -p "$HOME/.local/bin"
ln -sf "$DEST/flax-env" "$HOME/.local/bin/flax-env"
