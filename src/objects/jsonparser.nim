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

import json
import strutils
import sequtils

proc toSnakeCase(before: string): string =
  result = ""
  for r in before:
    if r.isUpperAscii():
      result &= "_" & r.toLowerAscii()
    else:
      result &= r

proc replaceCommonFields(before: string): string =
  if before == "objectType":
    result = "type"
  else:
    result = before.toSnakeCase()

proc unmarshalBasicTypes[K, V](node: JsonNode, k: K, v: var V): V =
  when v is string:
    if node.hasKey(k) and not node[k].isNil:
      v = node[k].getStr
    else:
      v = ""
  elif v is int:
    v = node[k].getInt
  elif v is seq[string]:
    if node[k].isNil:
      v = @[]
    else:
      v = node[k].elems.map(proc(x: JsonNode): string = x.str)
  elif v is seq[ref object]:
    if node[k].isNil:
      v = @[]
    else:
      return v
  else:
    return v
