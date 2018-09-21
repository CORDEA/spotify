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
import objects / error
import objects / artist
import objects / paging
import objects / simplealbum
import objects / spotifyresponse
import objects / jsonunmarshaller
import objects / internalunmarshallers

const
  GetAristPath = "/artists/$#"
  GetArtistAlbumsPath = "/artists/$#/albums"
  GetArtistTopTracksPath = "/artists/$#/top-tracks"
  GetArtistRelatedArtistsPath = "/artists/$#/related-artists"
  GetArtistsPath = "/artists"

proc getArtist*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[SpotifyResponse[Artist]] {.multisync.} =
  let
    path = buildPath(subex(GetAristPath) % [id], @[])
    response = await client.request(path)
  result = await toResponse[Artist](response)

proc getArtistAlbums*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[SpotifyResponse[Paging[SimpleAlbum]]] {.multisync.} =
  let
    path = buildPath(subex(GetArtistAlbumsPath) % [id], @[])
    response = await client.request(path)
  result = await toResponse[Paging[SimpleAlbum]](response)

proc getArtistTopTracks*(client: SpotifyClient | AsyncSpotifyClient,
  id, market: string): Future[SpotifyResponse[seq[Track]]] {.multisync.} =
  let
    path = buildPath(subex(GetArtistTopTracksPath) % [id], @[newQuery("market", market)])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code, toSeq[Track](body, "tracks"))
  else:
    result = failure[seq[Track]](code, body)

proc getArtistRelatedArtists*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[SpotifyResponse[seq[Artist]]] {.multisync.} =
  let
    path = buildPath(subex(GetArtistRelatedArtistsPath) % [id], @[])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code, toSeq[Artist](body, "artists"))
  else:
    result = failure[seq[Artist]](code, body)

proc getArtists*(client: SpotifyClient | AsyncSpotifyClient,
  ids: seq[string]): Future[SpotifyResponse[seq[Artist]]] {.multisync.} =
  let
    path = buildPath(GetArtistsPath, @[newQuery("ids", ids.foldr(a & "," & b))])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code, toSeq[Artist](body, "artists"))
  else:
    result = failure[seq[Artist]](code, body)
