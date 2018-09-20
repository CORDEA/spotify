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
import externalid
import externalurl
import jsonunmarshaller

proc toSnakeCase(before: string): string =
  result = ""
  for r in before:
    if r.isUpperAscii():
      result &= "_" & r.toLowerAscii()
    else:
      result &= r

proc replaceCommonFields(unmarshaller: JsonUnmarshaller,
  before: string): string =
  for target in unmarshaller.replaceTargets:
    if target.fieldName == before:
      return target.jsonKeyName
  case before
  of "objectType":
    "type"
  else:
    before.toSnakeCase()

proc unmarshal*[T: enum](unmarshaller: JsonUnmarshaller,
  node: JsonNode, v: var T) =
  v = parseEnum[T](node.getStr)

proc unmarshalBasicTypes[K, V](unmarshaller: JsonUnmarshaller,
  node: JsonNode, k: K, v: var V): V =
  when v is string:
    if node.hasKey(k) and not node[k].isNil:
      v = node[k].getStr
    else:
      v = ""
  elif v is int:
    v = node[k].getInt
  elif v is bool:
    if node.hasKey(k):
      v = node[k].getBool
  elif v is seq[string]:
    if node.hasKey(k) and not node[k].isNil:
      v = node[k].elems.map(proc(x: JsonNode): string = x.str)
    else:
      v = @[]
  elif v is enum:
    unmarshaller.unmarshal(node[k], v)
  else:
    return v

proc unmarshal*[T: ref object](unmarshaller: JsonUnmarshaller,
  node: JsonNode, data: var seq[T]) =
  when T is ExternalUrl:
    var t = new(T)
    unmarshaller.unmarshal(t, node)
    data.add t
  elif T is ExternalId:
    var t = new(T)
    unmarshaller.unmarshal(t, node)
    data.add t
  else:
    for elem in node.elems:
      if elem.kind != JObject:
        continue
      var t = new(T)
      unmarshaller.unmarshal(elem, t)
      data.add t

proc unmarshal*[T: ref object](unmarshaller: JsonUnmarshaller,
  node: JsonNode, data: var T) =
  new(data)
  for rawKey, v in data[].fieldPairs:
    let k = unmarshaller.replaceCommonFields(rawKey)
    var unhandled = unmarshaller.unmarshalBasicTypes(node, k, v)
    if node.hasKey(k):
      when unhandled is seq[ref object]:
        unmarshaller.unmarshal(node[k], unhandled)
        v = unhandled
      elif unhandled is ref object:
        unmarshaller.unmarshal(node[k], unhandled)
        v = unhandled

proc to*[T : ref object](unmarshaller: JsonUnmarshaller,
  json: string): T =
  let node = json.parseJson()
  unmarshaller.unmarshal(node, result)

proc to*[T : ref object](unmarshaller: JsonUnmarshaller,
  json, key: string): T =
  let node = json.parseJson()
  unmarshaller.unmarshal(node[key], result)

proc toSeq*[T: ref object](unmarshaller: JsonUnmarshaller,
  json: string): seq[T] =
  let node = json.parseJson()
  unmarshaller.unmarshal(node, result)

proc toSeq*[T: ref object](unmarshaller: JsonUnmarshaller,
  json, key: string): seq[T] =
  let node = json.parseJson()
  unmarshaller.unmarshal(node[key], result)
