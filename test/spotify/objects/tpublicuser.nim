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
# date  : 2018-09-09

import unittest
import .. / .. / .. / src / spotify / objects / publicuser
import .. / .. / .. / src / spotify / objects / jsonunmarshaller
import .. / .. / .. / src / spotify / objects / internalunmarshallers

suite "PublicUser test":
  setup:
    const json = """
    {
      "display_name" : "Lilla Namo",
      "external_urls" : {
        "spotify" : "https://open.spotify.com/user/tuggareutangranser"
      },
      "followers" : {
        "href" : null,
        "total" : 4561
      },
      "href" : "https://api.spotify.com/v1/users/tuggareutangranser",
      "id" : "tuggareutangranser",
      "images" : [ {
        "height" : null,
        "url" : "http://profile-images.scdn.co/artists/default/d4f208d4d49c6f3e1363765597d10c4277f5b74f",
        "width" : null
      } ],
      "type" : "user",
      "uri" : "spotify:user:tuggareutangranser"
    }
    """

  test "Unmarshal":
    let user = to[PublicUser](newJsonUnmarshaller(), json)
    check(user.displayName == "Lilla Namo")
    check(user.externalUrls.len == 1)
    check(user.externalUrls[0].urlType == "spotify")
    check(user.externalUrls[0].url == "https://open.spotify.com/user/tuggareutangranser")
    check(user.followers.href == "")
    check(user.followers.total == 4561)
    check(user.href == "https://api.spotify.com/v1/users/tuggareutangranser")
    check(user.id == "tuggareutangranser")
    check(user.images.len == 1)
    check(user.images[0].height == 0)
    check(user.images[0].url == "http://profile-images.scdn.co/artists/default/d4f208d4d49c6f3e1363765597d10c4277f5b74f")
    check(user.images[0].width == 0)
    check(user.objectType == "user")
    check(user.uri == "spotify:user:tuggareutangranser")
