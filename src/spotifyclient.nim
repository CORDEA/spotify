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
# date  : 2018-09-02

import uri
import json
import oauth2
import httpclient
import asyncdispatch

const
  AuthorizeUrl = "https://accounts.spotify.com/authorize"
  TokenUrl = "https://accounts.spotify.com/api/token"
  BaseUrl = "https://api.spotify.com/v1"

type
  SpotifyToken* = ref object
    accessToken*, refreshToken*, expiresIn*: string
  BaseClient = object of RootObj
    accessToken, refreshToken, expiresIn: string
  SpotifyClient* = ref object of BaseClient
    client: HttpClient
  AsyncSpotifyClient* = ref object of BaseClient
    client: AsyncHttpClient

proc newSpotifyToken*(accessToken, refreshToken, expiresIn: string): SpotifyToken =
  return SpotifyToken(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresIn: expiresIn
  )

proc newSpotifyClient*(accessToken, refreshToken, expiresIn: string): SpotifyClient =
  let client = newHttpClient()
  return SpotifyClient(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresIn: expiresIn,
    client: client
  )

proc newAsyncSpotifyClient*(accessToken, refreshToken, expiresIn: string): AsyncSpotifyClient =
  let client = newAsyncHttpClient()
  return AsyncSpotifyClient(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresIn: expiresIn,
    client: client
  )

proc authorizationCodeGrant*(client: HttpClient | AsyncHttpClient,
  clientId, clientSecret: string, scope: seq[string]): Future[SpotifyToken] {.multisync.}=
  let
    response = await client.authorizationCodeGrant(
      AuthorizeUrl, TokenUrl, clientId, clientSecret, scope = scope)
    json = parseJson(await response.body)
    accessToken = json["access_token"].getStr
    expiresIn = json["expires_in"].getStr
    refreshToken = json["refresh_token"].getStr
  result = newSpotifyToken(accessToken, refreshToken, expiresIn)

proc request*(client: SpotifyClient | AsyncSpotifyClient, path: string,
  httpMethod = HttpGet, body = ""): Future[Response | AsyncResponse] {.multisync.} =
  let headers = getBearerRequestHeader(client.accessToken)
  result = await client.client.request($(BaseUrl.parseUri() / path),
    httpMethod = httpMethod, headers = headers, body = body)
