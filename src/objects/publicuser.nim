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
import followers
import jsonparser
import externalurl

type
  PublicUser* = ref object
    displayName*, href*, id*, objectType*, uri*: string
    externalUrls*: seq[ExternalUrl]
    followers*: Followers
    images*: seq[Image]

proc toPublicUser*(json: string): PublicUser =
  let node = parseJson json
  unmarshal(node, result)
