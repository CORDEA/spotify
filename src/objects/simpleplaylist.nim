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

import json
import image
import paging
import tracklink
import publicuser
import externalurl
import jsonunmarshaller
import internalunmarshallers

type
  PlaylistVisibility* = enum
    TypePublic, TypePrivate, TypeNotRelevant
  SimplePlaylist* = ref object
    collaborative*: bool
    href*, id*, name*, snapshotId*: string
    objectType*, uri*: string
    externalUrls*: seq[ExternalUrl]
    images*: seq[Image]
    owner*: PublicUser
    public*: PlaylistVisibility
    tracks*: TrackLink

proc unmarshal*(unmarshaller: JsonUnmarshaller,
  node: JsonNode, v: var PlaylistVisibility) =
  if node.kind == JNull:
    v = TypeNotRelevant
    return
  if node.getBool:
    v = TypePublic
  else:
    v = TypePrivate

proc toSimplePlaylists*(json: string): Paging[SimplePlaylist] =
  let node = parseJson json
  newJsonUnmarshaller().unmarshal(node["playlists"], result)
