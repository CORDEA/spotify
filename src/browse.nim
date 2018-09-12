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

import subexes
import sequtils
import spotifyuri
import httpclient
import spotifyclient
import asyncdispatch
import objects / paging
import objects / category
import objects / simplealbum
import objects / simpleplaylist
import objects / recommendations

const
  GetCategoryPath = "/browse/categories/$#"
  GetCategoryPlaylistsPath = "/browse/categories/$#/playlists"
  GetCategoriesPath = "/browse/categories"
  GetFeaturedPlaylistsPath = "/browse/featured-playlists"
  GetNewReleasesPath = "/browse/new-releases"
  GetRecommendationsPath = "/recommendations"

proc getCategory*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[Category] {.multisync.} =
  let
    path = buildPath(subex(GetCategoryPath) % [id], @[])
    response = await client.request(path)
    body = await response.body
  result = body.toCategory()

proc getCategoryPlaylists*(client: SpotifyClient | AsyncSpotifyClient,
  id: string): Future[Paging[SimplePlaylist]] {.multisync.} =
  let
    path = buildPath(subex(GetCategoryPlaylistsPath) % [id], @[])
    response = await client.request(path)
    body = await response.body
  result = body.toSimplePlaylists()

proc getCategories*(client: SpotifyClient | AsyncSpotifyClient,
  country, locale = "", limit = 20, offset = 0): Future[Paging[Category]] {.multisync.} =
  let
    path = buildPath(GetCategoriesPath, @[
      newQuery("country", country),
      newQuery("locale", locale),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
    body = await response.body
  result = body.toCategories()

proc getFeaturedPlaylists*(client: SpotifyClient | AsyncSpotifyClient,
  country, locale, timestamp = "", limit = 20, offset = 0): Future[Paging[SimplePlaylist]] {.multisync.} =
  let
    path = buildPath(GetCategoriesPath, @[
      newQuery("locale", locale),
      newQuery("country", country),
      newQuery("timestamp", timestamp),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
    body = await response.body
  result = body.toSimplePlaylists()

proc getNewReleases*(client: SpotifyClient | AsyncSpotifyClient,
  country = "", limit = 20, offset = 0): Future[Paging[SimpleAlbum]] {.multisync.} =
  let
    path = buildPath(GetCategoriesPath, @[
      newQuery("country", country),
      newQuery("limit", $limit),
      newQuery("offset", $offset)
    ])
    response = await client.request(path)
    body = await response.body
  result = body.toSimpleAlbums()

# proc getRecommendations*(client: SpotifyClient | AsyncSpotifyClient): Future[Recommendations] {.multisync.} =
