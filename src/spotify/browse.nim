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
# date  : 2018-09-12

import sequtils
import strformat
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / error
import objects / paging
import objects / category
import objects / simplealbum
import objects / simpleplaylist
import objects / spotifyresponse
import objects / recommendations
import objects / jsonunmarshaller
import objects / featuredplaylists
import objects / recommendationseed
import objects / internalunmarshallers

const
  GetCategoryPath = "/browse/categories/{id}"
  GetCategoryPlaylistsPath = "/browse/categories/{id}/playlists"
  GetCategoriesPath = "/browse/categories"
  GetFeaturedPlaylistsPath = "/browse/featured-playlists"
  GetNewReleasesPath = "/browse/new-releases"
  GetRecommendationsPath = "/recommendations"

proc getCategory*(client: SpotifyClient | AsyncSpotifyClient,
  id: string, country, locale = ""): Future[SpotifyResponse[Category]] {.multisync.} =
  let
    path = buildPath(GetCategoryPath.fmt, @[
      newQuery("country", country),
      newQuery("locale", locale),
    ])
    response = await client.request(path)
  result = await toResponse[Category](response)

proc getCategoryPlaylists*(client: SpotifyClient | AsyncSpotifyClient,
  id: string, country = "",
  limit = 20, offset = 0): Future[SpotifyResponse[Paging[SimplePlaylist]]] {.multisync.} =
  let
    path = buildPath(GetCategoryPlaylistsPath.fmt, @[
      newQuery("country", country),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code, to[Paging[SimplePlaylist]](body, "playlists"))
  else:
    result = failure[Paging[SimplePlaylist]](code, body)

proc getCategories*(client: SpotifyClient | AsyncSpotifyClient,
  country, locale = "", limit = 20,
  offset = 0): Future[SpotifyResponse[Paging[Category]]] {.multisync.} =
  let
    path = buildPath(GetCategoriesPath, @[
      newQuery("country", country),
      newQuery("locale", locale),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code, to[Paging[Category]](body, "categories"))
  else:
    result = failure[Paging[Category]](code, body)

proc getFeaturedPlaylists*(client: SpotifyClient | AsyncSpotifyClient,
  country, locale, timestamp = "", limit = 20,
  offset = 0): Future[SpotifyResponse[FeaturedPlaylists]] {.multisync.} =
  let
    path = buildPath(GetFeaturedPlaylistsPath, @[
      newQuery("locale", locale),
      newQuery("country", country),
      newQuery("timestamp", timestamp),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
  result = await toResponse[FeaturedPlaylists](response)

proc getNewReleases*(client: SpotifyClient | AsyncSpotifyClient,
  country = "", limit = 20,
  offset = 0): Future[SpotifyResponse[Paging[SimpleAlbum]]] {.multisync.} =
  let
    path = buildPath(GetNewReleasesPath, @[
      newQuery("country", country),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code, to[Paging[SimpleAlbum]](body, "albums"))
  else:
    result = failure[Paging[SimpleAlbum]](code, body)

proc getRecommendations*(client: SpotifyClient | AsyncSpotifyClient,
  limit = 20, market = "",
  seedArtists, seedGenres, seedTracks: seq[string] = @[],
  additionalQueries: seq[Query] = @[]): Future[SpotifyResponse[Recommendations]] {.multisync.} =
  var queries = concat(@[
    newQuery("limit", $limit),
    newQuery("market", market)
  ], additionalQueries)
  if seedArtists.len > 0:
    queries.add(newQuery("seed_artists",
      seedArtists.foldr(a & "," & b)))
  if seedGenres.len > 0:
    queries.add(newQuery("seed_genres",
      seedGenres.foldr(a & "," & b)))
  if seedTracks.len > 0:
    queries.add(newQuery("seed_tracks",
      seedTracks.foldr(a & "," & b)))
  let
    path = buildPath(GetRecommendationsPath, queries)
    response = await client.request(path)
    unmarshaller = newJsonUnmarshaller(recommendationSeedReplaceTargets)
  result = await toResponse[Recommendations](unmarshaller, response)
