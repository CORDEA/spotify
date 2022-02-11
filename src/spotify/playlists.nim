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

import json
import base64
import subexes
import sequtils
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / error
import objects / image
import objects / paging
import objects / snapshot
import objects / playlist
import objects / playlisttrack
import objects / simpleplaylist
import objects / spotifyresponse
import objects / internalunmarshallers

const
  PostTracksToPlaylistPath = "/playlists/$#/tracks"
  ChangePlaylistDetailsPath = "/playlists/$#"
  PostPlaylistPath = "/users/$#/playlists"
  GetUserPlaylistsPath = "/me/playlists"
  GetPlaylistsPath = "/users/$#/playlists"
  GetPlaylistCoverImagePath = "/playlists/$#/images"
  GetPlaylistPath = "/playlists/$#"
  GetPlaylistTracksPath = "/playlists/$#/tracks"
  DeleteTracksFromPlaylistPath = "/playlists/$#/tracks"
  ReorderPlaylistTracksPath = "/playlists/$#/tracks"
  ReplacePlaylistTracksPath = "/playlists/$#/tracks"
  UploadCustomPlaylistCoverImagePath = "/playlists/$#/images"

proc postTracksToPlaylist*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, uris: seq[string],
  position = -1): Future[SpotifyResponse[Snapshot]] {.multisync.} =
  var body = %* {"uris": uris}
  if position != -1:
    body["position"] = %* position
  let
    path = buildPath(subex(PostTracksToPlaylistPath) % [playlistId], @[])
    response = await client.request(path, body = $body, httpMethod = HttpPost)
  result = await toResponse[Snapshot](response)

proc buildBody(name, description: string): JsonNode =
  result = newJObject()
  if name != "":
    result["name"] = %* name
  if description != "":
    result["description"] = %* description

proc changePlaylistDetails*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, name, description = ""): Future[SpotifyResponse[void]] {.multisync.} =
  let
    body = buildBody(name, description)
    path = buildPath(subex(ChangePlaylistDetailsPath) % [playlistId], @[])
    response = await client.request(path, body = $body, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc changePlaylistDetails*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, public: bool,
  name, description = ""): Future[SpotifyResponse[void]] {.multisync.} =
  var body = buildBody(name, description)
  body["public"] = %* public
  let
    path = buildPath(subex(ChangePlaylistDetailsPath) % [playlistId], @[])
    response = await client.request(path, body = $body, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc changePlaylistDetails*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, collaborative: bool,
  name, description = ""): Future[SpotifyResponse[void]] {.multisync.} =
  var body = buildBody(name, description)
  body["collaborative"] = %* collaborative
  let
    path = buildPath(subex(ChangePlaylistDetailsPath) % [playlistId], @[])
    response = await client.request(path, body = $body, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc changePlaylistDetails*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, public, collaborative: bool,
  name, description = ""): Future[SpotifyResponse[void]] {.multisync.} =
  var body = buildBody(name, description)
  body["public"] = %* public
  body["collaborative"] = %* collaborative
  let
    path = buildPath(subex(ChangePlaylistDetailsPath) % [playlistId], @[])
    response = await client.request(path, body = $body, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc postPlaylist*(client: SpotifyClient | AsyncSpotifyClient,
  userId: string, name: string, public = true,
  collaborative = false, description = ""): Future[SpotifyResponse[Playlist]] {.multisync.} =
  var body = %* {"name": name, "public": public, "collaborative": collaborative}
  if description != "":
    body["description"] = %* description
  let
    path = buildPath(subex(PostPlaylistPath) % [userId], @[])
    response = await client.request(path, body = $body, httpMethod = HttpPost)
  result = await toResponse[Playlist](response)

proc getUserPlaylists*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, offset = 0): Future[SpotifyResponse[Paging[SimplePlaylist]]] {.multisync.} =
  let
    path = buildPath(GetUserPlaylistsPath, @[
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
  result = await toResponse[Paging[SimplePlaylist]](response)

proc getPlaylists*(client: SpotifyClient | AsyncSpotifyClient,
  userId: string, limit = 20,
  offset = 0): Future[SpotifyResponse[Paging[SimplePlaylist]]] {.multisync.} =
  let
    path = buildPath(subex(GetPlaylistsPath) % [userId], @[
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
  result = await toResponse[Paging[SimplePlaylist]](response)

proc getPlaylistCoverImage*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string): Future[SpotifyResponse[seq[Image]]] {.multisync.} =
  let
    path = buildPath(subex(GetPlaylistCoverImagePath) % [playlistId], @[])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code, toSeq[Image](body))
  else:
    result = failure[seq[Image]](code, body)

proc getPlaylist*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, fields, market = ""): Future[SpotifyResponse[Playlist]] {.multisync.} =
  let
    path = buildPath(subex(GetPlaylistPath) % [playlistId], @[
      newQuery("fields", fields),
      newQuery("market", market)
    ])
    response = await client.request(path)
  result = await toResponse[Playlist](response)

proc getPlaylistTracks*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, fields = "", limit = 100,
  offset = 0, market = ""): Future[SpotifyResponse[Paging[PlaylistTrack]]] {.multisync.} =
  let
    path = buildPath(subex(GetPlaylistTracksPath) % [playlistId], @[
      newQuery("fields", fields),
      newQuery("limit", $limit),
      newQuery("offset", $offset),
      newQuery("market", market)
    ])
    response = await client.request(path)
  result = await toResponse[Paging[PlaylistTrack]](response)

proc deleteTracksFromPlaylist*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, tracks: seq[string]): Future[SpotifyResponse[Snapshot]] {.multisync.} =
  var body = newJObject()
  var arr = newJArray()
  for track in tracks:
    arr.add(%* {"uri": track})
  body["tracks"] = arr
  let
    path = buildPath(subex(DeleteTracksFromPlaylistPath) % [playlistId], @[])
    response = await client.request(path, body = $body, httpMethod = HttpDelete)
  result = await toResponse[Snapshot](response)

proc reorderPlaylistTracks*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, rangeStart, insertBefore: int,
  rangeLength = 1, snapshotId = ""): Future[SpotifyResponse[Snapshot]] {.multisync.} =
  var body = %* {
    "range_start": rangeStart,
    "range_length": rangeLength,
    "insert_before": insertBefore
  }
  if snapshotId != "":
    body["snapshot_id"] = %* snapshotId
  let
    path = buildPath(subex(ReorderPlaylistTracksPath) % [playlistId], @[])
    response = await client.request(path, body = $body, httpMethod = HttpPut)
  result = await toResponse[Snapshot](response)

proc replacePlaylistTracks*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, uris: seq[string]): Future[SpotifyResponse[void]] {.multisync} =
  let
    body = %* {"uris": uris}
    path = buildPath(subex(ReplacePlaylistTracksPath) % [playlistId], @[])
    response = await client.request(path, body = $body, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc uploadCustomPlaylistCoverImage*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId, encodedData: string): Future[SpotifyResponse[void]] {.multisync} =
  let
    path = buildPath(subex(UploadCustomPlaylistCoverImagePath) % [playlistId], @[])
    response = await client.request(path, body = encodedData, httpMethod = HttpPut,
      extraHeaders = newHttpHeaders({"Content-Type": "image/jpeg"}))
  result = await toEmptyResponse(response)

proc uploadCustomPlaylistCoverImageWithPath*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId, jpegPath: string): Future[SpotifyResponse[void]] {.multisync} =
  result = await client.uploadCustomPlaylistCoverImage(playlistId,
    encode(readFile(jpegPath)))
