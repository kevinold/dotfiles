# Install Caskroom

#brew tap caskroom/cask
#brew install brew-cask
#brew tap caskroom/versions
brew tap homebrew/cask-versions

# Install packages

apps=(
    firefox
    google-chrome
    iterm2
    keepingyouawake
    moom
    slack
#    docker
    visual-studio-code
    notion
    obsidian
)

brew install --cask "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
#brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webpquicklook suspicious-package && qlmanage -r
