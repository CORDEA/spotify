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
# date  : 2018-09-13

import json
import sequtils
import strformat
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / error
import objects / artist
import objects / spotifyresponse
import objects / cursorbasedpaging
import objects / internalunmarshallers

const
  IsFollowingPath = "/me/following/contains"
  IsFollowingPlaylistPath = "/users/{ownerId}/playlists/{playlistId}/followers/contains"
  FollowPath = "/me/following"
  FollowPlaylistPath = "/playlists/{playlistId}/followers"
  GetFollowedPath = "/me/following"
  UnfollowPath = "/me/following"
  UnfollowPlaylistPath = "/playlists/{playlistId}/followers"

proc internalIsFollow(client: SpotifyClient | AsyncSpotifyClient,
  followType: string, ids: seq[string]): Future[SpotifyResponse[seq[bool]]] {.multisync.} =
  let
    path = buildPath(IsFollowingPath, @[
      newQuery("type", followType),
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

proc isFollowArtist*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[SpotifyResponse[seq[bool]]] {.multisync.} =
  result = await client.internalIsFollow("artist", ids)

proc isFollowUser*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[SpotifyResponse[seq[bool]]] {.multisync.} =
  result = await client.internalIsFollow("user", ids)

proc isFollowPlaylist*(client: SpotifyClient | AsyncSpotifyClient,
  ownerId, playlistId: string,
  ids: seq[string]): Future[SpotifyResponse[seq[bool]]] {.multisync.} =
  let
    path = buildPath(IsFollowingPlaylistPath.fmt, @[
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

proc internalFollow(client: SpotifyClient | AsyncSpotifyClient,
  followType: string, ids: seq[string]): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(FollowPath, @[
      newQuery("type", followType),
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc followArtist*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[SpotifyResponse[void]] {.multisync.} =
  result = await client.internalFollow("artist", ids)

proc followUser*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[SpotifyResponse[void]] {.multisync.} =
  result = await client.internalFollow("user", ids)

proc followPlaylist*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, public = true): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(FollowPlaylistPath.fmt, @[])
    body = %* {"public": public}
    response = await client.request(path, body = $body, httpMethod = HttpPut)
  result = await toEmptyResponse(response)

proc getFollowedArtists*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, after = ""): Future[SpotifyResponse[CursorBasedPaging[Artist]]] {.multisync.} =
  let
    path = buildPath(GetFollowedPath, @[
      newQuery("type", "artist"),
      newQuery("limit", $limit),
      newQuery("after", after)
    ])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code, to[CursorBasedPaging[Artist]](body, "artists"))
  else:
    result = failure[CursorBasedPaging[Artist]](code, body)

proc internalUnfollow(client: SpotifyClient | AsyncSpotifyClient,
  followType: string, ids: seq[string]): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(UnfollowPath, @[
      newQuery("type", followType),
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path, httpMethod = HttpDelete)
  result = await toEmptyResponse(response)

proc unfollowArtist*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[SpotifyResponse[void]] {.multisync.} =
  result = await client.internalUnfollow("artist", ids)

proc unfollowUser*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[SpotifyResponse[void]] {.multisync.} =
  result = await client.internalUnfollow("user", ids)

proc unfollowPlaylist*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string): Future[SpotifyResponse[void]] {.multisync.} =
  let
    path = buildPath(UnfollowPlaylistPath.fmt, @[])
    response = await client.request(path, httpMethod = HttpDelete)
  result = await toEmptyResponse(response)
