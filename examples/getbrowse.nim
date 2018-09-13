# Copyright 2018 Yoshihiro Tanaka
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

  # http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Author: Yoshihiro Tanaka <contact@cordea.jp>
# date  : 2018-09-13

import ospaths
import httpclient
import .. / src / browse
import .. / src / spotifyclient

let
  token = newHttpClient().authorizationCodeGrant(
    getEnv("SPOTIFY_ID"),
    getEnv("SPOTIFY_SECRET"),
    @[]
  )
  client = newSpotifyClient(token.accessToken, token.refreshToken, token.expiresIn)
  category = client.getCategory("party")
  playlists = client.getCategoryPlaylists("party")
  categories = client.getCategories()
  featuredPlaylists = client.getFeaturedPlaylists()
  newReleases = client.getNewReleases()

echo category.name

for playlist in playlists.items:
  echo playlist.name
  echo playlist.owner.displayName

for category in categories.items:
  echo category.name

echo featuredPlaylists.message
for playlist in featuredPlaylists.playlists.items:
  echo playlist.name
  echo playlist.owner.displayName

for release in newReleases.items:
  echo release.name
