brew install nvm

nvm install 6.3.0
nvm use 6.3.0
nvm alias default 6.3.0

# Globally install with npm

packages=(
    eslint
    grunt
    gulp
    http-server
    nodemon
    release-it
    spot
    svgo
    tldr
    underscore
    vtop
)

npm install -g "${packages[@]}"
