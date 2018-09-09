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
import .. / .. / src / objects / album
import .. / .. / src / objects / copyright
import .. / .. / src / objects / externalid

suite "Album test":
  setup:
    const albumJson = """
    {
      "album_type" : "album",
      "artists" : [ {
        "external_urls" : {
          "spotify" : "https://open.spotify.com/artist/2BTZIqw0ntH9MvilQ3ewNY"
        },
        "href" : "https://api.spotify.com/v1/artists/2BTZIqw0ntH9MvilQ3ewNY",
        "id" : "2BTZIqw0ntH9MvilQ3ewNY",
        "name" : "Cyndi Lauper",
        "type" : "artist",
        "uri" : "spotify:artist:2BTZIqw0ntH9MvilQ3ewNY"
      } ],
      "available_markets" : [ "AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "IE", "IS", "IT", "LI", "LT", "LU", "LV", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PT", "PY", "RO", "SE", "SG", "SI", "SK", "SV", "TW", "UY" ],
      "copyrights" : [ {
        "text" : "(P) 2000 Sony Music Entertainment Inc.",
        "type" : "P"
      } ],
      "external_ids" : {
        "upc" : "5099749994324"
      },
      "external_urls" : {
        "spotify" : "https://open.spotify.com/album/0sNOF9WDwhWunNAHPD3Baj"
      },
      "genres" : [ ],
      "href" : "https://api.spotify.com/v1/albums/0sNOF9WDwhWunNAHPD3Baj",
      "id" : "0sNOF9WDwhWunNAHPD3Baj",
      "images" : [ {
        "height" : 640,
        "url" : "https://i.scdn.co/image/07c323340e03e25a8e5dd5b9a8ec72b69c50089d",
        "width" : 640
      }, {
        "height" : 300,
        "url" : "https://i.scdn.co/image/8b662d81966a0ec40dc10563807696a8479cd48b",
        "width" : 300
      }, {
        "height" : 64,
        "url" : "https://i.scdn.co/image/54b3222c8aaa77890d1ac37b3aaaa1fc9ba630ae",
        "width" : 64
      } ],
      "name" : "She's So Unusual",
      "popularity" : 39,
      "release_date" : "1983",
      "release_date_precision" : "year",
      "tracks" : {
        "href" : "https://api.spotify.com/v1/albums/0sNOF9WDwhWunNAHPD3Baj/tracks?offset=0&limit=50",
        "items" : [ {
          "artists" : [ {
            "external_urls" : {
              "spotify" : "https://open.spotify.com/artist/2BTZIqw0ntH9MvilQ3ewNY"
            },
            "href" : "https://api.spotify.com/v1/artists/2BTZIqw0ntH9MvilQ3ewNY",
            "id" : "2BTZIqw0ntH9MvilQ3ewNY",
            "name" : "Cyndi Lauper",
            "type" : "artist",
            "uri" : "spotify:artist:2BTZIqw0ntH9MvilQ3ewNY"
          } ],
          "available_markets" : [ "AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "IE", "IS", "IT", "LI", "LT", "LU", "LV", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PT", "PY", "RO", "SE", "SG", "SI", "SK", "SV", "TW", "UY" ],
          "disc_number" : 1,
          "duration_ms" : 305560,
          "explicit" : false,
          "external_urls" : {
            "spotify" : "https://open.spotify.com/track/3f9zqUnrnIq0LANhmnaF0V"
          },
          "href" : "https://api.spotify.com/v1/tracks/3f9zqUnrnIq0LANhmnaF0V",
          "id" : "3f9zqUnrnIq0LANhmnaF0V",
          "name" : "Money Changes Everything",
          "preview_url" : "https://p.scdn.co/mp3-preview/01bb2a6c9a89c05a4300aea427241b1719a26b06",
          "track_number" : 1,
          "type" : "track",
          "uri" : "spotify:track:3f9zqUnrnIq0LANhmnaF0V"
        }],
        "limit" : 50,
        "next" : null,
        "offset" : 0,
        "previous" : null,
        "total" : 13
      },
      "type" : "album",
      "uri" : "spotify:album:0sNOF9WDwhWunNAHPD3Baj"
    }
    """
  const albumsJson = """
  {
    "albums" : [ {
      "album_type" : "album",
      "artists" : [ {
        "external_urls" : {
          "spotify" : "https://open.spotify.com/artist/53A0W3U0s8diEn9RhXQhVz"
        },
        "href" : "https://api.spotify.com/v1/artists/53A0W3U0s8diEn9RhXQhVz",
        "id" : "53A0W3U0s8diEn9RhXQhVz",
        "name" : "Keane",
        "type" : "artist",
        "uri" : "spotify:artist:53A0W3U0s8diEn9RhXQhVz"
      } ],
      "available_markets" : [ "AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "IE", "IS", "IT", "LI", "LT", "LU", "LV", "MC", "MT", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PL", "PT", "PY", "RO", "SE", "SG", "SI", "SK", "SV", "TR", "TW", "UY" ],
      "copyrights" : [ {
        "text" : "(C) 2013 Universal Island Records, a division of Universal Music Operations Limited",
        "type" : "C"
      }, {
        "text" : "(P) 2013 Universal Island Records, a division of Universal Music Operations Limited",
        "type" : "P"
      } ],
      "external_ids" : {
        "upc" : "00602537518357"
      },
      "external_urls" : {
        "spotify" : "https://open.spotify.com/album/41MnTivkwTO3UUJ8DrqEJJ"
      },
      "genres" : [ ],
      "href" : "https://api.spotify.com/v1/albums/41MnTivkwTO3UUJ8DrqEJJ",
      "id" : "41MnTivkwTO3UUJ8DrqEJJ",
      "images" : [ {
        "height" : 640,
        "url" : "https://i.scdn.co/image/89b92c6b59131776c0cd8e5df46301ffcf36ed69",
        "width" : 640
      }, {
        "height" : 300,
        "url" : "https://i.scdn.co/image/eb6f0b2594d81f8d9dced193f3e9a3bc4318aedc",
        "width" : 300
      }, {
        "height" : 64,
        "url" : "https://i.scdn.co/image/21e1ebcd7ebd3b679d9d5084bba1e163638b103a",
        "width" : 64
      } ],
      "name" : "The Best Of Keane (Deluxe Edition)",
      "popularity" : 65,
      "release_date" : "2013-11-08",
      "release_date_precision" : "day",
      "tracks" : {
        "href" : "https://api.spotify.com/v1/albums/41MnTivkwTO3UUJ8DrqEJJ/tracks?offset=0&limit=50",
        "items" : [ {
          "artists" : [ {
            "external_urls" : {
              "spotify" : "https://open.spotify.com/artist/53A0W3U0s8diEn9RhXQhVz"
            },
            "href" : "https://api.spotify.com/v1/artists/53A0W3U0s8diEn9RhXQhVz",
            "id" : "53A0W3U0s8diEn9RhXQhVz",
            "name" : "Keane",
            "type" : "artist",
            "uri" : "spotify:artist:53A0W3U0s8diEn9RhXQhVz"
          } ],
          "available_markets" : [ "AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "IE", "IS", "IT", "LI", "LT", "LU", "LV", "MC", "MT", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PL", "PT", "PY", "RO", "SE", "SG", "SI", "SK", "SV", "TR", "TW", "UY" ],
          "disc_number" : 1,
          "duration_ms" : 215986,
          "explicit" : false,
          "external_urls" : {
            "spotify" : "https://open.spotify.com/track/4r9PmSmbAOOWqaGWLf6M9Q"
          },
          "href" : "https://api.spotify.com/v1/tracks/4r9PmSmbAOOWqaGWLf6M9Q",
          "id" : "4r9PmSmbAOOWqaGWLf6M9Q",
          "name" : "Everybody's Changing",
          "preview_url" : "https://p.scdn.co/mp3-preview/641fd877ee0f42f3713d1649e20a9734cc64b8f9",
          "track_number" : 1,
          "type" : "track",
          "uri" : "spotify:track:4r9PmSmbAOOWqaGWLf6M9Q"
        }, {
          "artists" : [ {
            "external_urls" : {
              "spotify" : "https://open.spotify.com/artist/53A0W3U0s8diEn9RhXQhVz"
            },
            "href" : "https://api.spotify.com/v1/artists/53A0W3U0s8diEn9RhXQhVz",
            "id" : "53A0W3U0s8diEn9RhXQhVz",
            "name" : "Keane",
            "type" : "artist",
            "uri" : "spotify:artist:53A0W3U0s8diEn9RhXQhVz"
          } ],
          "available_markets" : [ "AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "IE", "IS", "IT", "LI", "LT", "LU", "LV", "MC", "MT", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PL", "PT", "PY", "RO", "SE", "SG", "SI", "SK", "SV", "TR", "TW", "UY" ],
          "disc_number" : 1,
          "duration_ms" : 235880,
          "explicit" : false,
          "external_urls" : {
            "spotify" : "https://open.spotify.com/track/0HJQD8uqX2Bq5HVdLnd3ep"
          },
          "href" : "https://api.spotify.com/v1/tracks/0HJQD8uqX2Bq5HVdLnd3ep",
          "id" : "0HJQD8uqX2Bq5HVdLnd3ep",
          "name" : "Somewhere Only We Know",
          "preview_url" : "https://p.scdn.co/mp3-preview/e001676375ea2b4807cee2f98b51f2f3fe0d109b",
          "track_number" : 2,
          "type" : "track",
          "uri" : "spotify:track:0HJQD8uqX2Bq5HVdLnd3ep"
        } ],
        "limit" : 50,
        "next" : null,
        "offset" : 0,
        "previous" : null,
        "total" : 9
      },
      "type" : "album",
      "uri" : "spotify:album:6UXCm6bOO4gFlDQZV5yL37"
    } ]
  }
  """

  test "Unmarshal album":
    let album = albumJson.toAlbum()
    check(album.albumtype == "album")
    check(album.artists.len == 1)
    check(album.artists[0].name == "Cyndi Lauper")
    check(album.artists[0].objectType == "artist")
    check(album.availableMarkets.len == 57)

    check(album.copyrights.len == 1)
    check(album.copyrights[0].text == "(P) 2000 Sony Music Entertainment Inc.")
    check(album.copyrights[0].copyrightType == TypeSoundRecordingCopyright)

    check(album.externalIds.len == 1)
    check(album.externalIds[0].id == "5099749994324")
    check(album.externalIds[0].idType == TypeUniversalProductCode)

    check(album.externalUrls.len == 1)
    check(album.genres.len == 0)
    check(album.images.len == 3)
    check(album.images[0].height == 640)
    check(album.images[1].height == 300)
    check(album.name == "She's So Unusual")
    check(album.popularity == 39)
    check(album.releaseDate == "1983")
    check(album.releaseDatePrecision == "year")
    check(album.objectType == "album")

  test "Unmarshal albums":
    let
      albums = albumsJson.toAlbums()
      album = albums[0]
    check(albums.len == 1)
    check(album.albumtype == "album")
    check(album.artists.len == 1)
    check(album.artists[0].name == "Keane")
    check(album.availableMarkets.len == 57)

    check(album.copyrights.len == 2)
    check(album.copyrights[0].copyrightType == TypeCopyright)
    check(album.copyrights[1].copyrightType == TypeSoundRecordingCopyright)

    check(album.externalIds.len == 1)

    check(album.externalUrls.len == 1)
    check(album.genres.len == 0)
    check(album.images.len == 3)
    check(album.name == "The Best Of Keane (Deluxe Edition)")

    check(album.tracks.items.len == 2)
