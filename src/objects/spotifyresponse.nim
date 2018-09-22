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
# date  : 2018-09-20

import json
import error
import httpcore
import httpclient
import asyncdispatch
import jsonunmarshaller
import internalunmarshallers

type
  SpotifyResponse*[T] = ref object
    isSuccess*: bool
    code*: HttpCode
    data*: T
    error*: Error

proc success*[T](code: HttpCode, data: T): SpotifyResponse[T] =
  result = SpotifyResponse[T](
    isSuccess: true,
    code: code,
    data: data
  )

proc success*(code: HttpCode): SpotifyResponse[void] =
  result = SpotifyResponse[void](
    isSuccess: true,
    code: code
  )

proc failure[T](code: HttpCode, error: Error): SpotifyResponse[T] =
  result = SpotifyResponse[T](
    isSuccess: false,
    code: code,
    error: error
  )

proc failure*[T](code: HttpCode, body: string): SpotifyResponse[T] =
  result = SpotifyResponse[T](
    isSuccess: false,
    code: code,
    error: to[Error](emptyJsonUnmarshaller, body, "error")
  )

proc toResponse*[T : ref object](unmarshaller: JsonUnmarshaller,
  response: Response | AsyncResponse): Future[SpotifyResponse[T]] {.multisync.} =
  let
    body = await response.body
    code = response.code
  if code.is2xx:
    if body == "":
      result = success[T](code, nil)
    else:
      result = success(code, to[T](unmarshaller, body))
  else:
    result = failure[T](code, to[Error](unmarshaller, body, "error"))

proc toResponse*[T : ref object](response: Response | AsyncResponse
  ): Future[SpotifyResponse[T]] {.multisync.} =
  result = await toResponse[T](emptyJsonUnmarshaller, response)

proc toEmptyResponse*(response: Response | AsyncResponse
  ): Future[SpotifyResponse[void]] {.multisync.} =
  let
    body = await response.body
    code = response.code
  if code.is2xx:
    result = success(code)
  else:
    result = failure[void](code, body)
