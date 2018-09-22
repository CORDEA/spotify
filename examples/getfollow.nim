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
# date  : 2018-09-15

import ospaths
import httpclient
import .. / src / spotify / scope
import .. / src / spotify / follow
import .. / src / spotify / spotifyclient

const
  artists = @["74ASZWbe4lXaubB36ztrGX", "08td7MxkoHQkXnWAYD8d6Q"]
  users = @["exampleuser01"]
  playlist = "2v3iNvBX8Ay1Gt2uXtUKUT"

let
  token = newHttpClient().authorizationCodeGrant(
    getEnv("SPOTIFY_ID"),
    getEnv("SPOTIFY_SECRET"),
    @[ScopeUserFollowRead, ScopeUserFollowModify, ScopePlaylistModifyPublic]
  )
  client = newSpotifyClient(token)
  isFollowArtist = client.isFollowArtist(artists).data
  isFollowUser = client.isFollowUser(users).data
  isFollowPlaylist = client.isFollowPlaylist("jmperezperez", playlist, @["possan", "elogain"]).data
  followedArtists = client.getFollowedArtists().data

echo $isFollowArtist
echo $isFollowUser
echo $isFollowPlaylist

for artist in followedArtists.items:
  echo artist.name

let
  followedArtist = client.followArtist(artists)
  followedUser = client.followUser(users)
  followedPlaylist = client.followPlaylist(playlist)

echo followedArtist.isSuccess
echo $followedArtist.code

echo followedUser.isSuccess
echo followedPlaylist.isSuccess

let
  unfollowedArtist = client.unfollowArtist(artists)
  unfollowedUser = client.unfollowUser(users)
  unfollowedPlaylist = client.unfollowPlaylist(playlist)

echo unfollowedArtist.isSuccess
echo $unfollowedArtist.code

echo unfollowedUser.isSuccess
echo unfollowedPlaylist.isSuccess
