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
# date  : 2018-09-05

import json
import tracklink
import externalid
import jsonparser
import externalurl
import simplealbum
import simpleartist
import restrictions

type
  Track* = ref object
    album*: SimpleAlbum
    artists*: seq[SimpleArtist]
    availableMarkets*: seq[string]
    discNumber*, durationMs*: int
    popularity*, trackNumber*: int
    explicit*, isPlayable*, isLocal*: bool
    href*, id*, name*, previewUrl*: string
    objectType*, uri*: string
    externalIds*: seq[ExternalId]
    externalUrls*: seq[ExternalUrl]
    linkedFrom*: TrackLink
    restrictions*: Restrictions

proc toTrack*(json: string): Track =
  let node = parseJson json
  unmarshal(node, result)

proc toTracks*(json: string): seq[Track] =
  let node = parseJson json
  unmarshal(node["tracks"], result)
