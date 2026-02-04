#!/bin/bash
set -euo pipefail

echo "Setting macOS defaults..."

# Expanding the save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Saving to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable smart quotes and smart dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Enable full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Key repeat speed
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 2

# VS Code key repeat (only if installed)
if [[ -d "/Applications/Visual Studio Code.app" ]]; then
  defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
fi

# Safari Developer menu (only if Safari is default browser)
if defaults read com.apple.Safari &>/dev/null 2>&1; then
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
fi

# Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "macOS defaults set. Some changes require logout/restart."
