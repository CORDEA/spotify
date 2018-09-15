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
import subexes
import sequtils
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / artist
import objects / cursorbasedpaging

const
  IsFollowingPath = "/me/following/contains"
  IsFollowingPlaylistPath = "/users/$#/playlists/$#/followers/contains"
  FollowPath = "/me/following"
  FollowPlaylistPath = "/playlists/$#/followers"
  GetFollowedPath = "/me/following"
  UnfollowPath = "/me/following"
  UnfollowPlaylistPath = "/playlists/$#/followers"

proc internalIsFollow(client: SpotifyClient | AsyncSpotifyClient,
  followType: string, ids: seq[string]): Future[seq[bool]] {.multisync.} =
  let
    path = buildPath(IsFollowingPath, @[
      newQuery("type", followType),
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path)
    body = await response.body
    json = parseJson body
  for elem in json.elems:
    result.add elem.getBool

proc isFollowArtist*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[seq[bool]] {.multisync.} =
  result = await client.internalIsFollow("artist", ids)

proc isFollowUser*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[seq[bool]] {.multisync.} =
  result = await client.internalIsFollow("user", ids)

proc isFollowPlaylist*(client: SpotifyClient | AsyncSpotifyClient,
  ownerId, playlistId: string, ids: seq[string]): Future[seq[bool]] {.multisync.} =
  let
    path = buildPath(subex(IsFollowingPlaylistPath) % [ownerId, playlistId], @[
      newQuery("ids", ids.foldr(a & "," & b))
    ])
    response = await client.request(path)
    body = await response.body
    json = parseJson body
  for elem in json.elems:
    result.add elem.getBool

proc internalFollow(client: SpotifyClient | AsyncSpotifyClient,
  followType: string, ids: seq[string]): Future[void] {.multisync.} =
  let
    path = buildPath(FollowPath, @[
      newQuery("type", followType),
      newQuery("ids", ids.foldr(a & "," & b))
    ])
  discard await client.request(path, httpMethod = HttpPut)

proc followArtist*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[void] {.multisync.} =
  await client.internalFollow("artist", ids)

proc followUser*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[void] {.multisync.} =
  await client.internalFollow("user", ids)

proc followPlaylist*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string, public = true): Future[void] {.multisync.} =
  let
    path = buildPath(subex(FollowPlaylistPath) % [playlistId], @[])
    body = %* {"public": public}
  discard await client.request(path, body = $body, httpMethod = HttpPut)

proc getFollowedArtists*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, after = ""): Future[CursorBasedPaging[Artist]] {.multisync.} =
  let
    path = buildPath(GetFollowedPath, @[
      newQuery("type", "artist"),
      newQuery("limit", $limit),
      newQuery("after", after)
    ])
    response = await client.request(path)
    body = await response.body
  result = body.toCursorBasedPagingArtist()

proc internalUnfollow(client: SpotifyClient | AsyncSpotifyClient,
  followType: string, ids: seq[string]): Future[void] {.multisync.} =
  let
    path = buildPath(UnfollowPath, @[
      newQuery("type", followType),
      newQuery("ids", ids.foldr(a & "," & b))
    ])
  discard await client.request(path, httpMethod = HttpDelete)

proc unfollowArtist*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[void] {.multisync.} =
  await client.internalUnfollow("artist", ids)

proc unfollowUser*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[void] {.multisync.} =
  await client.internalUnfollow("user", ids)

proc unfollowPlaylist*(client: SpotifyClient | AsyncSpotifyClient,
  playlistId: string): Future[void] {.multisync.} =
  let path = buildPath(subex(UnfollowPlaylistPath) % [playlistId], @[])
  discard await client.request(path, httpMethod = HttpDelete)
