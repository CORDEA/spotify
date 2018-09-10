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

import unittest
import .. / .. / src / objects / track
import .. / .. / src / objects / externalid

suite "Track test":
  setup:
    const json = """
    {
      "album": {
        "album_type": "single",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/6sFIWsNpZYqfjUpaCgueju"
            },
            "href": "https://api.spotify.com/v1/artists/6sFIWsNpZYqfjUpaCgueju",
            "id": "6sFIWsNpZYqfjUpaCgueju",
            "name": "Carly Rae Jepsen",
            "type": "artist",
            "uri": "spotify:artist:6sFIWsNpZYqfjUpaCgueju"
          }
        ],
        "available_markets": [
          "AD",
          "AR",
          "AT",
          "AU",
          "BE",
          "BG",
          "BO",
          "BR",
          "CA",
          "CH",
          "CL",
          "CO",
          "CR",
          "CY",
          "CZ",
          "DE",
          "DK",
          "DO",
          "EC",
          "EE",
          "ES",
          "FI",
          "FR",
          "GB",
          "GR",
          "GT",
          "HK",
          "HN",
          "HU",
          "ID",
          "IE",
          "IL",
          "IS",
          "IT",
          "JP",
          "LI",
          "LT",
          "LU",
          "LV",
          "MC",
          "MT",
          "MX",
          "MY",
          "NI",
          "NL",
          "NO",
          "NZ",
          "PA",
          "PE",
          "PH",
          "PL",
          "PT",
          "PY",
          "RO",
          "SE",
          "SG",
          "SK",
          "SV",
          "TH",
          "TR",
          "TW",
          "US",
          "UY",
          "VN",
          "ZA"
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/0tGPJ0bkWOUmH7MEOR77qc"
        },
        "href": "https://api.spotify.com/v1/albums/0tGPJ0bkWOUmH7MEOR77qc",
        "id": "0tGPJ0bkWOUmH7MEOR77qc",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/107819f5dc557d5d0a4b216781c6ec1b2f3c5ab2",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/5a73a056d0af707b4119a883d87285feda543fbb",
            "width": 64
          }
        ],
        "name": "Cut To The Feeling",
        "release_date": "2017-05-26",
        "release_date_precision": "day",
        "type": "album",
        "uri": "spotify:album:0tGPJ0bkWOUmH7MEOR77qc"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/6sFIWsNpZYqfjUpaCgueju"
          },
          "href": "https://api.spotify.com/v1/artists/6sFIWsNpZYqfjUpaCgueju",
          "id": "6sFIWsNpZYqfjUpaCgueju",
          "name": "Carly Rae Jepsen",
          "type": "artist",
          "uri": "spotify:artist:6sFIWsNpZYqfjUpaCgueju"
        }
      ],
      "available_markets": [
        "AD",
        "AR",
        "AT",
        "AU",
        "BE",
        "BG",
        "BO",
        "BR",
        "CA",
        "CH",
        "CL",
        "CO",
        "CR",
        "CY",
        "CZ",
        "DE",
        "DK",
        "DO",
        "EC",
        "EE",
        "ES",
        "FI",
        "FR",
        "GB",
        "GR",
        "GT",
        "HK",
        "HN",
        "HU",
        "ID",
        "IE",
        "IL",
        "IS",
        "IT",
        "JP",
        "LI",
        "LT",
        "LU",
        "LV",
        "MC",
        "MT",
        "MX",
        "MY",
        "NI",
        "NL",
        "NO",
        "NZ",
        "PA",
        "PE",
        "PH",
        "PL",
        "PT",
        "PY",
        "RO",
        "SE",
        "SG",
        "SK",
        "SV",
        "TH",
        "TR",
        "TW",
        "US",
        "UY",
        "VN",
        "ZA"
      ],
      "disc_number": 1,
      "duration_ms": 207959,
      "explicit": false,
      "external_ids": {
        "isrc": "USUM71703861"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/11dFghVXANMlKmJXsNCbNl"
      },
      "href": "https://api.spotify.com/v1/tracks/11dFghVXANMlKmJXsNCbNl",
      "id": "11dFghVXANMlKmJXsNCbNl",
      "is_local": false,
      "name": "Cut To The Feeling",
      "popularity": 63,
      "preview_url": "https://p.scdn.co/mp3-preview/3eb16018c2a700240e9dfb8817b6f2d041f15eb1?cid=774b29d4f13844c495f206cafdad9c86",
      "track_number": 1,
      "type": "track",
      "uri": "spotify:track:11dFghVXANMlKmJXsNCbNl"
    }
    """

  test "Unmarshal":
    let
      track = json.toTrack()
      album = track.album
      artists = track.artists
      ids = track.externalIds
      urls = track.externalUrls
    check(album.albumtype == "single")
    check(album.artists.len == 1)
    check(album.artists[0].name == "Carly Rae Jepsen")
    check(album.artists[0].objectType == "artist")
    check(album.availableMarkets.len == 65)
    check(album.images.len == 3)
    check(album.images[0].height == 640)
    check(album.images[1].height == 300)
    check(album.name == "Cut To The Feeling")
    check(album.releaseDate == "2017-05-26")
    check(album.releaseDatePrecision == "day")
    check(album.objectType == "album")

    check(artists.len == 1)
    check(artists[0].name == "Carly Rae Jepsen")

    check(track.availableMarkets.len == 65)
    check(track.discNumber == 1)
    check(track.durationMs == 207959)
    check(track.explicit == false)

    check(ids.len == 1)
    check(ids[0].idType == TypeInternationalStandardRecordingCode)
    check(ids[0].id == "USUM71703861")

    check(urls.len == 1)
    check(urls[0].urlType == "spotify")

    check(track.href == "https://api.spotify.com/v1/tracks/11dFghVXANMlKmJXsNCbNl")
    check(track.id == "11dFghVXANMlKmJXsNCbNl")
    check(track.isLocal == false)
    check(track.name == "Cut To The Feeling")
    check(track.popularity == 63)
    check(track.previewUrl == "https://p.scdn.co/mp3-preview/3eb16018c2a700240e9dfb8817b6f2d041f15eb1?cid=774b29d4f13844c495f206cafdad9c86")
    check(track.trackNumber == 1)
    check(track.objectType == "track")
    check(track.uri == "spotify:track:11dFghVXANMlKmJXsNCbNl")
