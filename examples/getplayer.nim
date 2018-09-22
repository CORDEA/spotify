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
  client = newSpotifyClient(token)
  devices = client.getUserDevices().data
  context = client.getUserCurrentlyPlayingContext().data
  track = client.getUserCurrentlyPlayingTrack().data

for device in devices:
  echo device.id
  echo device.name

echo $context.repeatState
echo context.isPlaying

echo track.item.name
echo track.progressMs

let
  pause = client.pause()
  seek = client.seek(track.progressMs + 5000)
  repeat = client.setRepeat(StateTrack)
  volume = client.setVolume(0)
  next = client.next()
  previous = client.previous()
  play = client.play()
  shuffle = client.shuffle(true)

echo pause.isSuccess
echo seek.isSuccess
echo repeat.isSuccess
echo volume.isSuccess
echo next.isSuccess
echo previous.isSuccess
echo play.isSuccess
echo shuffle.isSuccess

if devices.len > 1:
  let transfer = client.transferPlayback(@[devices[1].id])
  echo transfer.isSuccess
