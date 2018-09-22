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

import unittest
import .. / .. / .. / src / spotify / objects / recommendations
import .. / .. / .. / src / spotify / objects / recommendationseed
import .. / .. / .. / src / spotify / objects / jsonunmarshaller
import .. / .. / .. / src / spotify / objects / internalunmarshallers

suite "Recommendations test":
  setup:
    const json = """
    {
      "tracks": [
        {
          "artists" : [ {
            "external_urls" : {
              "spotify" : "https://open.spotify.com/artist/134GdR5tUtxJrf8cpsfpyY"
            },
              "href" : "https://api.spotify.com/v1/artists/134GdR5tUtxJrf8cpsfpyY",
              "id" : "134GdR5tUtxJrf8cpsfpyY",
              "name" : "Elliphant",
              "type" : "artist",
              "uri" : "spotify:artist:134GdR5tUtxJrf8cpsfpyY"
          }, {
            "external_urls" : {
              "spotify" : "https://open.spotify.com/artist/1D2oK3cJRq97OXDzu77BFR"
            },
              "href" : "https://api.spotify.com/v1/artists/1D2oK3cJRq97OXDzu77BFR",
              "id" : "1D2oK3cJRq97OXDzu77BFR",
              "name" : "Ras Fraser Jr.",
              "type" : "artist",
              "uri" : "spotify:artist:1D2oK3cJRq97OXDzu77BFR"
          } ],
          "disc_number" : 1,
          "duration_ms" : 199133,
          "explicit" : false,
          "external_urls" : {
            "spotify" : "https://open.spotify.com/track/1TKYPzH66GwsqyJFKFkBHQ"
          },
          "href" : "https://api.spotify.com/v1/tracks/1TKYPzH66GwsqyJFKFkBHQ",
          "id" : "1TKYPzH66GwsqyJFKFkBHQ",
          "is_playable" : true,
          "name" : "Music Is Life",
          "preview_url" : "https://p.scdn.co/mp3-preview/546099103387186dfe16743a33edd77e52cec738",
          "track_number" : 1,
          "type" : "track",
          "uri" : "spotify:track:1TKYPzH66GwsqyJFKFkBHQ"
        }, {
          "artists" : [ {
            "external_urls" : {
              "spotify" : "https://open.spotify.com/artist/1VBflYyxBhnDc9uVib98rw"
            },
              "href" : "https://api.spotify.com/v1/artists/1VBflYyxBhnDc9uVib98rw",
              "id" : "1VBflYyxBhnDc9uVib98rw",
              "name" : "Icona Pop",
              "type" : "artist",
              "uri" : "spotify:artist:1VBflYyxBhnDc9uVib98rw"
          } ],
            "disc_number" : 1,
            "duration_ms" : 187026,
            "explicit" : false,
            "external_urls" : {
              "spotify" : "https://open.spotify.com/track/15iosIuxC3C53BgsM5Uggs"
            },
            "href" : "https://api.spotify.com/v1/tracks/15iosIuxC3C53BgsM5Uggs",
            "id" : "15iosIuxC3C53BgsM5Uggs",
            "is_playable" : true,
            "name" : "All Night",
            "preview_url" : "https://p.scdn.co/mp3-preview/9ee589fa7fe4e96bad3483c20b3405fb59776424",
            "track_number" : 2,
            "type" : "track",
            "uri" : "spotify:track:15iosIuxC3C53BgsM5Uggs"
        }
      ],
      "seeds": [
        {
          "initialPoolSize": 500,
          "afterFilteringSize": 380,
          "afterRelinkingSize": 365,
          "href": "https://api.spotify.com/v1/artists/4NHQUGzhtTLFvgF5SZesLK",
          "id": "4NHQUGzhtTLFvgF5SZesLK",
          "type": "artist"
        }, {
          "initialPoolSize": 250,
          "afterFilteringSize": 172,
          "afterRelinkingSize": 144,
          "href": "https://api.spotify.com/v1/tracks/0c6xIDDpzE81m2q797ordA",
          "id": "0c6xIDDpzE81m2q797ordA",
          "type": "track"
        }
      ]
    }
    """

  test "Unmarshal recommendations":
    let
      recommendations = to[Recommendations](newJsonUnmarshaller(recommendationSeedReplaceTargets), json)
      seeds = recommendations.seeds
      tracks = recommendations.tracks
      seed = seeds[0]
      track = tracks[0]
    check(seeds.len == 2)
    check(tracks.len == 2)

    check(track.artists.len == 2)
    check(track.discNumber == 1)
    check(track.durationMs == 199133)
    check(track.explicit == false)
    check(track.externalUrls.len == 1)
    check(track.id == "1TKYPzH66GwsqyJFKFkBHQ")
    check(track.name == "Music Is Life")
    check(track.trackNumber == 1)

    check(seed.initialPoolSize == 500)
    check(seed.afterFilteringSize == 380)
    check(seed.afterRelinkingSize == 365)
    check(seed.href == "https://api.spotify.com/v1/artists/4NHQUGzhtTLFvgF5SZesLK")
    check(seed.id == "4NHQUGzhtTLFvgF5SZesLK")
    check(seed.objectType == "artist")
