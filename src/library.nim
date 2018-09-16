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
import objects / paging
import objects / savedalbum
import objects / savedtrack

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
  path: string, ids: seq[string]): Future[seq[bool]] {.multisync.} =
  let
    path = buildPath(path, @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path)
    body = await response.body
    json = parseJson body
  for elem in json.elems:
    result.add elem.getBool

proc isSavedAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[seq[bool]] {.multisync.} =
  result = await client.internalIsSaved(IsSavedAlbumsPath, ids)

proc isSavedTracks*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[seq[bool]] {.multisync.} =
  result = await client.internalIsSaved(IsSavedTracksPath, ids)

proc getSavedAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, offset = 0, market = ""): Future[Paging[SavedAlbum]] {.multisync.} =
  let
    path = buildPath(GetSavedAlbumsPath, @[
      newQuery("market", market),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
    body = await response.body
  result = body.toSavedAlbums()

proc getSavedTracks*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, offset = 0, market = ""): Future[Paging[SavedTrack]] {.multisync.} =
  let
    path = buildPath(GetSavedTracksPath, @[
      newQuery("market", market),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
    body = await response.body
  result = body.toSavedTracks()

proc deleteSavedAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string] = @[]): Future[void] {.multisync.} =
  let
    path = buildPath(DeleteSavedAlbumsPath, @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
  discard await client.request(path, httpMethod = HttpDelete)

proc deleteSavedTracks*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string] = @[]): Future[void] {.multisync.} =
  let
    path = buildPath(DeleteSavedTracksPath, @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
  discard await client.request(path, httpMethod = HttpDelete)

proc saveAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string] = @[]): Future[void] {.multisync.} =
  let
    path = buildPath(SaveAlbumsPath, @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path, httpMethod = HttpPut)
  discard await client.request(path, httpMethod = HttpPut)

proc saveTracks*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string] = @[]): Future[void] {.multisync.} =
  let
    path = buildPath(SaveTracksPath, @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
  discard await client.request(path, httpMethod = HttpPut)
