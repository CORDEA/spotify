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
# date  : 2018-09-17

import ospaths
import httpclient
import .. / src / scope
import .. / src / player
import .. / src / spotifyclient
import .. / src / objects / currentlyplayingcontext

let
  token = newHttpClient().authorizationCodeGrant(
    getEnv("SPOTIFY_ID"),
    getEnv("SPOTIFY_SECRET"),
    @[ScopeUserReadPlaybackState, ScopeUserReadRecentlyPlayed, ScopeUserReadCurrentlyPlaying, ScopeUserModifyPlaybackState]
  )
  client = newSpotifyClient(token.accessToken, token.refreshToken, token.expiresIn)
  devices = client.getUserDevices()
  context = client.getUserCurrentlyPlayingContext()
  track = client.getUserCurrentlyPlayingTrack()

for device in devices:
  echo device.id
  echo device.name

echo $context.repeatState
echo context.isPlaying

echo track.item.name
echo track.progressMs

client.pause()
client.seek(track.progressMs + 5000)
client.setRepeat(StateTrack)
client.setVolume(0)
client.next()
client.previous()
client.play()
client.shuffle(true)

if devices.len > 1:
  client.transferPlayback(@[devices[1].id])
