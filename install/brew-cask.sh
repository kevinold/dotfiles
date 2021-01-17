# Install Caskroom

#brew tap caskroom/cask
#brew install brew-cask
#brew tap caskroom/versions
brew tap homebrew/cask-versions

# Install packages

apps=(
    alfred
    arq
    box-sync
    dropbox
    firefox
#    google-chrome
    #google-drive
#    iterm2
    keepingyouawake
#    mailplane
    moom
    slack
    #virtualbox
    #mas
#    docker
#    visual-studio-code
    evernote
    notion
)

brew install --cask "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
#brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webpquicklook suspicious-package && qlmanage -r
