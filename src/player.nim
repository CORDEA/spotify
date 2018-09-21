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

import json
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / error
import objects / device
import objects / playhistory
import objects / spotifyresponse
import objects / jsonunmarshaller
import objects / internalunmarshallers
import objects / currentlyplayingtrack
import objects / currentlyplayingcontext

const
  GetUserDevicesPath = "/me/player/devices"
  GetUserCurrentlyPlayingContextPath = "/me/player"
  GetUserRecentlyPlayedTracksPath = "/me/player/recently-played"
  GetUserCurrentlyPlayingTrackPath = "/me/player/currently-playing"
  PausePath = "/me/player/pause"
  SeekPath = "/me/player/seek"
  SetRepeatPath = "/me/player/repeat"
  SetVolumePath = "/me/player/volume"
  NextPath = "/me/player/next"
  PreviousPath = "/me/player/previous"
  PlayPath = "/me/player/play"
  ShufflePath = "/me/player/shuffle"
  TransferPlaybackPath = "/me/player"

proc getUserDevices*(client: SpotifyClient | AsyncSpotifyClient
  ): Future[SpotifyResponse[seq[Device]]] {.multisync.} =
  let
    response = await client.request(GetUserDevicesPath)
    body = await response.body
    code = response.code
    unmarshaller = newJsonUnmarshaller(deviceReplaceTargets)
  if code.is2xx:
    result = success(code, toSeq[Device](unmarshaller, body, "devices"))
  else:
    result = failure[seq[Device]](code, body)

proc getUserCurrentlyPlayingContext*(client: SpotifyClient | AsyncSpotifyClient,
  market = ""): Future[SpotifyResponse[CurrentlyPlayingContext]] {.multisync.} =
  let
    path = buildPath(GetUserCurrentlyPlayingContextPath, @[newQuery("market", market)])
    response = await client.request(path)
    unmarshaller = newJsonUnmarshaller(deviceReplaceTargets)
  result = await toResponse[CurrentlyPlayingContext](unmarshaller, response)

proc getUserRecentlyPlayedTracks*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, after, before = 0): Future[SpotifyResponse[PlayHistory]] {.multisync.} =
  var queries = @[newQuery("limit", $limit)]
  if after > 0:
    queries.add(newQuery("after", $after))
  if before > 0:
    queries.add(newQuery("after", $before))
  let
    path = buildPath(GetUserRecentlyPlayedTracksPath, queries)
    response = await client.request(path)
  result = await toResponse[PlayHistory](response)

proc getUserCurrentlyPlayingTrack*(client: SpotifyClient | AsyncSpotifyClient,
  market = ""): Future[SpotifyResponse[CurrentlyPlayingTrack]] {.multisync.} =
  let
    path = buildPath(GetUserCurrentlyPlayingTrackPath, @[newQuery("market", market)])
    response = await client.request(path)
  result = await toResponse[CurrentlyPlayingTrack](response)

proc pause*(client: SpotifyClient | AsyncSpotifyClient,
  deviceId = ""): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(PausePath, @[newQuery("device_id", deviceId)])
    response = await client.request(path, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc seek*(client: SpotifyClient | AsyncSpotifyClient,
  positionMs: int, deviceId = ""): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(SeekPath, @[
      newQuery("position_ms", $positionMs),
      newQuery("device_id", deviceId)
    ])
    response = await client.request(path, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc setRepeat*(client: SpotifyClient | AsyncSpotifyClient,
  state: RepeatState, deviceId = ""): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(SetRepeatPath, @[
      newQuery("state", $state),
      newQuery("device_id", deviceId)
    ])
    response = await client.request(path, httpMethod = HttpPut)
    body = await response.body
  result = await toEmptyResponse(response)

proc setVolume*(client: SpotifyClient | AsyncSpotifyClient,
  volumePercent: int, deviceId = ""): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(SetVolumePath, @[
      newQuery("volume_percent", $volumePercent),
      newQuery("device_id", deviceId)
    ])
    response = await client.request(path, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc next*(client: SpotifyClient | AsyncSpotifyClient,
  deviceId = ""): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(NextPath, @[newQuery("device_id", deviceId)])
    response =await client.request(path, httpMethod = HttpPost)
  result = await toEmptyResponse(response)

proc previous*(client: SpotifyClient | AsyncSpotifyClient,
  deviceId = ""): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(PreviousPath, @[newQuery("device_id", deviceId)])
    response = await client.request(path, httpMethod = HttpPost)
  result = await toEmptyResponse(response)

proc internalPlay(client: SpotifyClient | AsyncSpotifyClient,
  deviceId: string, body: JsonNode): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(PlayPath, @[newQuery("device_id", deviceId)])
    response = await client.request(path, body = $body, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc play*(client: SpotifyClient | AsyncSpotifyClient,
  deviceId, contextUri = "", uris: seq[string] = @[],
  offsetPosition, positionMs = -1): Future[SpotifyResponse[void]] {.multisync.} =
  var body = %* {
    "context_uri": contextUri,
    "uris": uris
  }
  if offsetPosition >= 0:
    body["offset"] = %* {"position": offsetPosition}
  if positionMs >= 0:
    body["position_ms"] = %* positionMs
  result = await client.internalPlay(deviceId, body)

proc play*(client: SpotifyClient | AsyncSpotifyClient,
  deviceId, contextUri = "", uris: seq[string] = @[],
  offsetUri = "", positionMs = -1): Future[SpotifyResponse[void]] {.multisync.} =
  var body = %* {
    "context_uri": contextUri,
    "uris": uris
  }
  if offsetUri != "":
    body["offset"] = %* {"uri": offsetUri}
  if positionMs >= 0:
    body["position_ms"] = %* positionMs
  result = await client.internalPlay(deviceId, body)

proc shuffle*(client: SpotifyClient | AsyncSpotifyClient,
  shuffle: bool, deviceId = ""): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(ShufflePath, @[
      newQuery("state", $shuffle),
      newQuery("device_id", deviceId)
    ])
    response = await client.request(path, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc transferPlayback*(client: SpotifyClient | AsyncSpotifyClient,
  deviceIds: seq[string], play = false): Future[SpotifyResponse[void]] {.multisync.} =
  let
    body = %* {"device_ids": deviceIds, "play": play}
    response = await client.request(TransferPlaybackPath,
      body = $body, httpMethod = HttpPut)
  result = await toEmptyResponse(response)
