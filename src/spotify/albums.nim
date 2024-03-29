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

import sequtils
import httpcore
import strformat
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / album
import objects / error
import objects / paging
import objects / copyright
import objects / simpletrack
import objects / spotifyresponse
import objects / jsonunmarshaller
import objects / internalunmarshallers

const
  GetAlbumPath = "/albums/{id}"
  GetTracksPath = "/albums/{id}/tracks"
  GetAlbumsPath = "/albums"

proc getAlbum*(client: SpotifyClient | AsyncSpotifyClient,
  id: string, market = ""): Future[SpotifyResponse[Album]] {.multisync.} =
  let
    path = buildPath(GetAlbumPath.fmt, @[newQuery("market", market)])
    response = await client.request(path)
    unmarshaller = newJsonUnmarshaller(copyrightReplaceTargets)
  result = await toResponse[Album](unmarshaller, response)

proc getAlbumTracks*(client: SpotifyClient | AsyncSpotifyClient,
  id: string, limit = 20, offset = 0,
  market = ""): Future[SpotifyResponse[Paging[SimpleTrack]]] {.multisync.} =
  let
    path = buildPath(GetTracksPath.fmt, @[
      newQuery("market", market),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
  result = await toResponse[Paging[SimpleTrack]](response)

proc getAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string] = @[], market = ""): Future[SpotifyResponse[seq[Album]]] {.multisync.} =
  let
    path = buildpath(GetAlbumsPath, @[
      newQuery("ids", ids.foldr(a & "," & b)),
      newQuery("market", market)
    ])
    response = await client.request(path)
    body = await response.body
    unmarshaller = newJsonUnmarshaller(copyrightReplaceTargets)
    code = response.code
  if code.is2xx:
    result = success(code, toSeq[Album](unmarshaller, body, "albums"))
  else:
    result = failure[seq[Album]](code, body)
