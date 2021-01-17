# Install Homebrew

#ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#brew tap homebrew/versions
#brew tap homebrew/dupes
#brew update
#brew upgrade

# Install packages

apps=(
    ack
    ag
    bats
    #cmake
    coreutils
    dockutil
    ffmpeg
    fasd
    gifsicle
    git
    gnu-sed
    grep
    #gnu-sed --with-default-names
    #grep --with-default-names
    hub
    httpie
    imagemagick
    jq
    mackup
    peco
    psgrep
    python
    shellcheck
    ssh-copy-id
    tmux
    tree
    vim
    wget
    awscli
    #aws-sam-cli
    dos2unix
    ssh-copy-id
    tree
    git-extras
)

brew install "${apps[@]}"

# Git comes with diff-highlight, but isn't in the PATH
#ln -sf "$(brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight" /usr/local/bin/diff-highlight
