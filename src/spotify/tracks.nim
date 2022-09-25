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

import sequtils
import strformat
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / track
import objects / error
import objects / audiofeature
import objects / audioanalysis
import objects / spotifyresponse
import objects / internalunmarshallers

const
  GetAudioAnalysisPath = "/audio-analysis/{id}"
  GetAudioFeaturePath = "/audio-features/{id}"
  GetAudioFeaturesPath = "/audio-features"
  GetTrackPath = "/tracks/{id}"
  GetTracksPath = "/tracks"

proc getAudioAnalysis*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[SpotifyResponse[AudioAnalysis]] {.multisync.} =
  let
    path = buildPath(GetAudioAnalysisPath.fmt, @[])
    response = await client.request(path)
    body = await response.body
  result = await toResponse[AudioAnalysis](response)

proc getAudioFeature*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[SpotifyResponse[AudioFeature]] {.multisync.} =
  let
    path = buildPath(GetAudioFeaturePath.fmt, @[])
    response = await client.request(path)
  result = await toResponse[AudioFeature](response)

proc getAudioFeatures*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[SpotifyResponse[seq[AudioFeature]]] {.multisync.} =
  let
    path = buildPath(GetAudioFeaturesPath, @[
      newQuery("ids", ids.foldr(a & "," & b)),
    ])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code, toSeq[AudioFeature](body, "audio_features"))
  else:
    result = failure[seq[AudioFeature]](code, body)

proc getTrack*(client: SpotifyClient | AsyncSpotifyClient,
  id: string, market = ""): Future[SpotifyResponse[Track]] {.multisync.} =
  let
    path = buildPath(GetTrackPath.fmt, @[])
    response = await client.request(path)
  result = await toResponse[Track](response)

proc getTracks*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string], market = ""): Future[SpotifyResponse[seq[Track]]] {.multisync.} =
  let
    path = buildPath(GetTracksPath, @[
      newQuery("ids", ids.foldr(a & "," & b)),
    ])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code, toSeq[Track](body, "tracks"))
  else:
    result = failure[seq[Track]](code, body)
