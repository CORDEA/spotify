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
# date  : 2018-09-18

import ospaths
import httpclient
import .. / src / search
import .. / src / spotifyclient

let
  token = newHttpClient().authorizationCodeGrant(
    getEnv("SPOTIFY_ID"),
    getEnv("SPOTIFY_SECRET"),
    @[]
  )
  client = newSpotifyClient(token.accessToken, token.refreshToken, token.expiresIn)
  searchResult = client.search("ed sheeran", @[TypeAlbum, TypeArtist, TypePlaylist, TypeTrack]).data

for album in searchResult.albums.items:
  echo album.name

for artist in searchResult.artists.items:
  echo artist.name

for playlist in searchResult.playlists.items:
  echo playlist.name

for track in searchResult.tracks.items:
  echo track.name
