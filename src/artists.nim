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

import subexes
import sequtils
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / track
import objects / artist
import objects / paging
import objects / simplealbum
import objects / jsonunmarshaller
import objects / internalunmarshallers

const
  GetAristPath = "/artists/$#"
  GetArtistAlbumsPath = "/artists/$#/albums"
  GetArtistTopTracksPath = "/artists/$#/top-tracks"
  GetArtistRelatedArtistsPath = "/artists/$#/related-artists"
  GetArtistsPath = "/artists"

proc getArtist*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[Artist] {.multisync.} =
  let
    path = buildPath(subex(GetAristPath) % [id], @[])
    response = await client.request(path)
    body = await response.body
  result = to[Artist](newJsonUnmarshaller(), body)

proc getArtistAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[Paging[SimpleAlbum]] {.multisync.} =
  let
    path = buildPath(subex(GetArtistAlbumsPath) % [id], @[])
    response = await client.request(path)
    body = await response.body
  result = to[Paging[SimpleAlbum]](newJsonUnmarshaller(), body)

proc getArtistTopTracks*(client: SpotifyClient | AsyncSpotifyClient,
  id, market: string): Future[seq[Track]] {.multisync.} =
  let
    path = buildPath(subex(GetArtistTopTracksPath) % [id], @[newQuery("market", market)])
    response = await client.request(path)
    body = await response.body
  result = toSeq[Track](newJsonUnmarshaller(), body, "tracks")

proc getArtistRelatedArtists*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[seq[Artist]] {.multisync.} =
  let
    path = buildPath(subex(GetArtistRelatedArtistsPath) % [id], @[])
    response = await client.request(path)
    body = await response.body
  result = toSeq[Artist](newJsonUnmarshaller(), body, "artists")

proc getArtists*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[seq[Artist]] {.multisync.} =
  let
    path = buildPath(GetArtistsPath, @[newQuery("ids", ids.foldr(a & "," & b))])
    response = await client.request(path)
    body = await response.body
  result = toSeq[Artist](newJsonUnmarshaller(), body, "artists")
