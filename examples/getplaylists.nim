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
import .. / src / scope
import .. / src / playlists
import .. / src / spotifyclient

const
  testPlaylistId = "***"
  ownId = "***"

let
  token = newHttpClient().authorizationCodeGrant(
    getEnv("SPOTIFY_ID"),
    getEnv("SPOTIFY_SECRET"),
    @[ScopePlaylistReadPrivate, ScopePlaylistModifyPublic]
  )
  client = newSpotifyClient(token.accessToken, token.refreshToken, token.expiresIn)
  ownPlaylists = client.getUserPlaylists()
  userPlaylists = client.getPlaylists("wizzler")
  playlistTracks = client.getPlaylistTracks("21THa8j9TaSGuXYNBU5tsC")
  playlist = client.getPlaylist(testPlaylistId)

for p in ownPlaylists.items:
  echo p.name

for p in userPlaylists.items:
  echo p.name

echo playlist.name

for track in playlistTracks.items:
  echo track.track.name

let snapshot = client.postTracksToPlaylist(testPlaylistId, @[
  "spotify:track:4iV5W9uYEdYUVa79Axb7Rh",
  "spotify:track:1301WleyT98MSxVHPZCA6M"
])
echo snapshot.snapshotId

client.changePlaylistDetails(testPlaylistId, "Test playlist")

let postedPlaylist = client.postPlaylist(ownId, "Test2")
echo postedPlaylist.name

let deleteSnapshot = client.deleteTracksFromPlaylist(testPlaylistId, @[
  "spotify:track:4iV5W9uYEdYUVa79Axb7Rh",
  "spotify:track:1301WleyT98MSxVHPZCA6M"
])
echo deleteSnapshot.snapshotId

let reorderSnapshot = client.reorderPlaylistTracks(testPlaylistId, 2, 0)
echo reorderSnapshot.snapshotId

client.replacePlaylistTracks(testPlaylistId, @[
  "spotify:track:4iV5W9uYEdYUVa79Axb7Rh",
  "spotify:track:1301WleyT98MSxVHPZCA6M"
])
