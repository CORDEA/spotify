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
# date  : 2018-09-10

import json
import subexes
import sequtils
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / album
import objects / paging
import objects / simpletrack
import objects / spotifyresponse

const
  GetAlbumPath = "/albums/$#"
  GetTracksPath = "/albums/$#/tracks"
  GetAlbumsPath = "/albums"

proc getAlbum*(client: SpotifyClient | AsyncSpotifyClient,
  id: string, market = ""): Future[SpotifyResponse[Album]] {.multisync.} =
  let
    path = buildPath(subex(GetAlbumPath) % [id], @[newQuery("market", market)])
    response = await client.request(path)
    code = response.code
    body = parseJson(await response.body)
  if code.is2xx:
    result = success(code, to(body, Album))
  else:
    result = failure[Album](code, body)

proc getAlbumTracks*(client: SpotifyClient | AsyncSpotifyClient,
  id: string, limit = 20, offset = 0,
  market = ""): Future[SpotifyResponse[Paging[SimpleTrack]]] {.multisync.} =
  let
    path = buildPath(subex(GetTracksPath) % [id], @[
      newQuery("market", market),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
    code = response.code
    body = parseJson(await response.body)
  if code.is2xx:
    result = success(code, to(body, Paging[SimpleTrack]))
  else:
    result = failure[Paging[SimpleTrack]](code, body)

proc getAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string] = @[], market = ""): Future[SpotifyResponse[seq[Album]]] {.multisync.} =
  let
    path = buildpath(GetAlbumsPath, @[
      newQuery("ids", ids.foldr(a & "," & b)),
      newQuery("market", market)
    ])
    response = await client.request(path)
    code = response.code
    body = parseJson(await response.body)
  if code.is2xx:
    result = success(code, to(body["albums"], seq[Album]))
  else:
    result = failure[seq[Album]](code, body)
