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
import copyright
import externalid
import externalurl
import simpletrack
import restrictions
import simpleartist
import jsonunmarshaller
import internalunmarshallers

type
  Album* = ref object
    albumType*, href*, id*, label*, name*, objectType*, uri*: string
    releaseDate*, releaseDatePrecision*: string
    artists*: seq[SimpleArtist]
    availableMarkets*: seq[string]
    copyrights*: seq[Copyright]
    externalIds*: seq[ExternalId]
    externalUrls*: seq[ExternalUrl]
    genres*: seq[string]
    images*: seq[Image]
    popularity*: int
    restrictions*: Restrictions
    tracks*: Paging[SimpleTrack]

proc toAlbum*(json: string): Album =
  let node = parseJson json
  newJsonUnmarshaller(copyrightReplaceTargets).unmarshal(node, result)

proc toAlbums*(json: string): seq[Album] =
  let node = parseJson json
  newJsonUnmarshaller(copyrightReplaceTargets).unmarshal(node["albums"], result)
