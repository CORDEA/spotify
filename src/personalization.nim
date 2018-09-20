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
# date  : 2018-09-14

import subexes
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / track
import objects / artist
import objects / paging
import objects / jsonunmarshaller
import objects / internalunmarshallers

const
  GetUserTopDataPath = "/me/top/$#"

type
  TimeRange* = enum
    TypeLongTerm = "long_term"
    TypeMediumTerm = "medium_term"
    TypeShortTerm = "short_term"

proc internalGet(client: SpotifyClient | AsyncSpotifyClient,
  getType: string, limit = 20, offset = 0,
  timeRange = TypeMediumTerm): Future[string] {.multisync.} =
  let
    path = buildPath(subex(GetUserTopDataPath) % [getType], @[
      newQuery("limit", $limit),
      newQuery("offset", $offset),
      newQuery("time_range", $timeRange)
    ])
    response = await client.request(path)
  result = await response.body

proc getUserTopArtists*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, offset = 0,
  timeRange = TypeMediumTerm): Future[Paging[Artist]] {.multisync.} =
  let body = await client.internalGet("artists")
  result = to[Paging[Artist]](newJsonUnmarshaller(), body)

proc getUserTopTracks*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, offset = 0,
  timeRange = TypeMediumTerm): Future[Paging[Track]] {.multisync.} =
  let body = await client.internalGet("tracks")
  result = to[Paging[Track]](newJsonUnmarshaller(), body)
