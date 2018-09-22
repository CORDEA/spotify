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
# date  : 2018-09-02

const
  # Spotify Connect
  ScopeUserModifyPlaybackState* = "user-modify-playback-state"
  ScopeUserReadCurrentlyPlaying* = "user-read-currently-playing"
  ScopeUserReadPlaybackState* = "user-read-playback-state"

  # Library
  ScopeUserLibraryModify* = "user-library-modify"
  ScopeUserLibraryRead* = "user-library-read"

  # Playback
  ScopeStreaming* = "streaming"
  ScopeAppRemoteControl* = "app-remote-control"

  # Users
  ScopeUserReadEmail* = "user-read-email"
  ScopeUserReadPrivate* = "user-read-private"
  ScopeUserReadBirthdate* = "user-read-birthdate"

  # Follow
  ScopeUserFollowRead* = "user-follow-read"
  ScopeUserFollowModify* = "user-follow-modify"

  # Playlists
  ScopePlaylistReadPrivate* = "playlist-read-private"
  ScopePlaylistReadCollaborative* = "playlist-read-collaborative"
  ScopePlaylistModifyPublic* = "playlist-modify-public"
  ScopePlaylistModifyPrivate* = "playlist-modify-private"

  # Listening History
  ScopeUserReadRecentlyPlayed* = "user-read-recently-played"
  ScopeUserTopRead* = "user-top-read"

  # Image
  ScopeUgcImageUpload* = "ugc-image-upload"
