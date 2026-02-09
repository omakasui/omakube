#! /bin/bash

echo "Updating Spotify GPG key..."

if omakub-pkg-present spotify-client; then
  curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  echo "deb [signed-by=/etc/apt/trusted.gpg.d/spotify.gpg] https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
fi