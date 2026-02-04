# mas installed in brew-cask.sh

# Install apps by id

# 418412301 Clean (1.0.3)
# 425955336 Skitch (2.8.2)
# 668208984 GIPHY CAPTURE (4.1)
# 531349534 Tadam (2.0.1)
# 425424353 The Unarchiver (4.1.0)
# 407963104 Pixelmator (3.8.2)
# 638332853 Logitech Camera Settings (3.31.623)
# 585829637 Todoist (7.1.2)

appIds=(
  #418412301
  #425955336
  #668208984
  531349534
  #425424353
  #407963104
  #638332853
  585829637
)

mas install "${appIds[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
#brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webpquicklook suspicious-package && qlmanage -r
