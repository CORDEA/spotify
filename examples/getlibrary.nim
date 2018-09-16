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
# date  : 2018-09-16

import ospaths
import httpclient
import .. / src / scope
import .. / src / library
import .. / src / spotifyclient

const
  targetAlbums = @["0pJJgBzj26qnE1nSQUxaB0", "5ZAKzV4ZIa5Gt7z29OYHv0"]
  targetTracks = @["0udZHhCi7p1YzMlvI4fXoK", "3SF5puV5eb6bgRSxBeMOk9"]

let
  token = newHttpClient().authorizationCodeGrant(
    getEnv("SPOTIFY_ID"),
    getEnv("SPOTIFY_SECRET"),
    @[ScopeUserLibraryRead, ScopeUserLibraryModify]
  )
  client = newSpotifyClient(token.accessToken, token.refreshToken, token.expiresIn)
  isSavedAlbums = client.isSavedAlbums(targetAlbums)
  isSavedTracks = client.isSavedTracks(targetTracks)
  savedAlbums = client.getSavedAlbums()
  savedTracks = client.getSavedTracks()

echo $isSavedAlbums
echo $isSavedTracks

for album in savedAlbums.items:
  echo album.album.name

for track in savedTracks.items:
  echo track.track.name

client.saveAlbums(targetAlbums)
client.saveTracks(targetTracks)

client.deleteSavedAlbums(targetAlbums)
client.deleteSavedTracks(targetTracks)
