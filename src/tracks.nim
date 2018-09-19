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

import subexes
import sequtils
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / track
import objects / audiofeature
import objects / audioanalysis

const
  GetAudioAnalysisPath = "/audio-analysis/$#"
  GetAudioFeaturePath = "/audio-features/$#"
  GetAudioFeaturesPath = "/audio-features"
  GetTrackPath = "/tracks/$#"
  GetTracksPath = "/tracks"

proc getAudioAnalysis*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[AudioAnalysis] {.multisync.} =
  let
    path = buildPath(subex(GetAudioAnalysisPath) % [id], @[])
    response = await client.request(path)
    body = await response.body
  result = body.toAudioAnalysis()

proc getAudioFeature*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[AudioFeature] {.multisync.} =
  let
    path = buildPath(subex(GetAudioFeaturePath) % [id], @[])
    response = await client.request(path)
    body = await response.body
  result = body.toAudioFeature()

proc getAudioFeatures*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[seq[AudioFeature]] {.multisync.} =
  let
    path = buildPath(GetAudioFeaturesPath, @[
      newQuery("ids", ids.foldr(a & "," & b)),
    ])
    response = await client.request(path)
    body = await response.body
  result = body.toAudioFeatures()

proc getTrack*(client: SpotifyClient | AsyncSpotifyClient,
  id: string, market = ""): Future[Track] {.multisync.} =
  let
    path = buildPath(subex(GetTrackPath) % [id], @[])
    response = await client.request(path)
    body = await response.body
  result = body.toTrack()

proc getTracks*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string], market = ""): Future[seq[Track]] {.multisync.} =
  let
    path = buildPath(GetTracksPath, @[
      newQuery("ids", ids.foldr(a & "," & b)),
    ])
    response = await client.request(path)
    body = await response.body
  result = body.toTracks()
