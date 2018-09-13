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
# date  : 2018-09-04

import json
import image
import paging
import externalurl
import simpleartist
import restrictions
import jsonunmarshaller
import internalunmarshallers

type
  SimpleAlbum* = ref object
    albumGroup*, albumType*, href*, id*, name*: string
    releaseDate*, releaseDatePrecision*, objectType*, uri*: string
    artists*: seq[SimpleArtist]
    availableMarkets*: seq[string]
    externalUrls*: seq[ExternalUrl]
    images*: seq[Image]
    restrictions*: Restrictions

proc toSimpleAlbums*(json: string): Paging[SimpleAlbum] =
  let
    node = parseJson json
    unmarshaller = newJsonUnmarshaller()
  if node.hasKey("albums"):
    unmarshaller.unmarshal(node["albums"], result)
  else:
    unmarshaller.unmarshal(node, result)
