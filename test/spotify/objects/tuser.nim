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

import unittest
import .. / .. / .. / src / spotify / objects / user
import .. / .. / .. / src / spotify / objects / jsonunmarshaller
import .. / .. / .. / src / spotify / objects / internalunmarshallers

suite "User test":
  setup:
    const json = """
    {
      "birthdate": "1937-06-01",
      "country": "SE",
      "display_name": "JM Wizzler",
      "email": "email@example.com",
      "external_urls": {
        "spotify": "https://open.spotify.com/user/wizzler"
      },
      "followers" : {
        "href" : null,
        "total" : 3829
      },
      "href": "https://api.spotify.com/v1/users/wizzler",
      "id": "wizzler",
      "images": [
        {
          "height": null,
          "url": "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-frc3/t1.0-1/1970403_10152215092574354_1798272330_n.jpg",
          "width": null
        }
      ],
      "product": "premium",
      "type": "user",
      "uri": "spotify:user:wizzler"
    }
    """

  test "Unmarshal":
    let user = to[User](newJsonUnmarshaller(), json)
    check(user.birthdate == "1937-06-01")
    check(user.country == "SE")
    check(user.displayName == "JM Wizzler")
    check(user.email == "email@example.com")
    check(user.externalUrls.len == 1)
    check(user.externalUrls[0].urlType == "spotify")
    check(user.externalUrls[0].url == "https://open.spotify.com/user/wizzler")
    check(user.followers.href == "")
    check(user.followers.total == 3829)
    check(user.href == "https://api.spotify.com/v1/users/wizzler")
    check(user.id == "wizzler")
    check(user.images.len == 1)
    check(user.images[0].height == 0)
    check(user.images[0].url == "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-frc3/t1.0-1/1970403_10152215092574354_1798272330_n.jpg")
    check(user.images[0].width == 0)
    check(user.product == "premium")
    check(user.objectType == "user")
    check(user.uri == "spotify:user:wizzler")
