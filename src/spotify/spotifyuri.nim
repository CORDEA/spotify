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
# date  : 2018-09-10

import uri

type
  Query* = ref object
    key*, value*: string

proc newQuery*(key, value: string): Query =
  result = Query(key: key, value: value)

proc buildPath*(path: string, queries: openarray[Query]): string =
  result = path
  var first = true
  for query in queries:
    if query.value == "":
      continue
    let value = query.value.encodeUrl()
    if first:
      result &= "?" & query.key & "=" & value
      first = false
    else:
      result &= "&" & query.key & "=" & value
