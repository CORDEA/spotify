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

import json
import subexes
import sequtils
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / error
import objects / paging
import objects / copyright
import objects / savedalbum
import objects / savedtrack
import objects / spotifyresponse
import objects / jsonunmarshaller
import objects / internalunmarshallers

const
  IsSavedAlbumsPath = "/me/albums/contains"
  IsSavedTracksPath = "/me/tracks/contains"
  GetSavedAlbumsPath = "/me/albums"
  GetSavedTracksPath = "/me/tracks"
  DeleteSavedAlbumsPath = "/me/albums"
  DeleteSavedTracksPath = "/me/tracks"
  SaveAlbumsPath = "/me/albums"
  SaveTracksPath = "/me/tracks"

proc internalIsSaved(client: SpotifyClient | AsyncSpotifyClient,
  path: string, ids: seq[string]): Future[SpotifyResponse[seq[bool]]] {.multisync.} =
  let
    path = buildPath(path, @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    let json = parseJson body
    var results: seq[bool] = @[]
    for elem in json.elems:
      results.add elem.getBool
    result = success(code, results)
  else:
    result = failure[seq[bool]](code, body)

proc isSavedAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[SpotifyResponse[seq[bool]]] {.multisync.} =
  result = await client.internalIsSaved(IsSavedAlbumsPath, ids)

proc isSavedTracks*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[SpotifyResponse[seq[bool]]] {.multisync.} =
  result = await client.internalIsSaved(IsSavedTracksPath, ids)

proc getSavedAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, offset = 0,
  market = ""): Future[SpotifyResponse[Paging[SavedAlbum]]] {.multisync.} =
  let
    path = buildPath(GetSavedAlbumsPath, @[
      newQuery("market", market),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    unmarshaller = newJsonUnmarshaller(copyrightReplaceTargets)
    response = await client.request(path)
  result = await toResponse[Paging[SavedAlbum]](unmarshaller, response)

proc getSavedTracks*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, offset = 0,
  market = ""): Future[SpotifyResponse[Paging[SavedTrack]]] {.multisync.} =
  let
    path = buildPath(GetSavedTracksPath, @[
      newQuery("market", market),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
  result = await toResponse[Paging[SavedTrack]](response)

proc deleteSavedAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string] = @[]): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(DeleteSavedAlbumsPath, @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path, httpMethod = HttpDelete)
  result = await toEmptyResponse(response)

proc deleteSavedTracks*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string] = @[]): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(DeleteSavedTracksPath, @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path, httpMethod = HttpDelete)
  result = await toEmptyResponse(response)

proc saveAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string] = @[]): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(SaveAlbumsPath, @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc saveTracks*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string] = @[]): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(SaveTracksPath, @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path, httpMethod = HttpPut)
  result = await toEmptyResponse(response)
