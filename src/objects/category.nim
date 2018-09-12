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
import jsonunmarshaller
import internalunmarshallers

type
  Category* = ref object
    href, id, name: string
    icons: seq[Image]

proc toCategory*(json: string): Category =
  let node = parseJson json
  newJsonUnmarshaller().unmarshal(node, result)

proc toCategories*(json: string): Paging[Category] =
  let node = parseJson json
  newJsonUnmarshaller().unmarshal(node["categories"], result)
