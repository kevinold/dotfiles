#brew install nvm

nvm install --lts
nvm use --lts

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
    npm-check-updates
)

npm install -g "${packages[@]}"
