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
import .. / .. / src / objects / paging
import .. / .. / src / objects / simpleplaylist
import .. / .. / src / objects / jsonunmarshaller
import .. / .. / src / objects / internalunmarshallers

suite "SimplePlaylist test":
  setup:
    const json = """
    {
      "playlists" : {
        "href" : "https://api.spotify.com/v1/browse/categories/party/playlists?country=BR&offset=0&limit=2",
        "items" : [ {
          "collaborative" : false,
          "external_urls" : {
            "spotify" : "http://open.spotify.com/user/spotifybrazilian/playlist/4k7EZPI3uKMz4aRRrLVfen"
          },
          "href" : "https://api.spotify.com/v1/users/spotifybrazilian/playlists/4k7EZPI3uKMz4aRRrLVfen",
          "id" : "4k7EZPI3uKMz4aRRrLVfen",
          "images" : [ {
            "height" : 300,
            "url" : "https://i.scdn.co/image/bf6544c213532e9650088dfef76c8521093d970e",
            "width" : 300
          } ],
          "name" : "Noite Eletrônica",
          "owner" : {
            "external_urls" : {
              "spotify" : "http://open.spotify.com/user/spotifybrazilian"
            },
            "href" : "https://api.spotify.com/v1/users/spotifybrazilian",
            "id" : "spotifybrazilian",
            "type" : "user",
            "uri" : "spotify:user:spotifybrazilian"
          },
          "public" : null,
          "snapshot_id" : "PULvu1V2Ps8lzCxNXfNZTw4QbhBpaV0ZORc03Mw6oj6kQw9Ks2REwhL5Xcw/74wL",
          "tracks" : {
            "href" : "https://api.spotify.com/v1/users/spotifybrazilian/playlists/4k7EZPI3uKMz4aRRrLVfen/tracks",
            "total" : 100
          },
          "type" : "playlist",
          "uri" : "spotify:user:spotifybrazilian:playlist:4k7EZPI3uKMz4aRRrLVfen"
        }, {
          "collaborative" : false,
          "external_urls" : {
            "spotify" : "http://open.spotify.com/user/spotifybrazilian/playlist/4HZh0C9y80GzHDbHZyX770"
          },
          "href" : "https://api.spotify.com/v1/users/spotifybrazilian/playlists/4HZh0C9y80GzHDbHZyX770",
          "id" : "4HZh0C9y80GzHDbHZyX770",
          "images" : [ {
            "height" : 300,
            "url" : "https://i.scdn.co/image/be6c333146674440123073cb32c1c8b851e69023",
            "width" : 300
          } ],
          "name" : "Festa Indie",
          "owner" : {
            "external_urls" : {
              "spotify" : "http://open.spotify.com/user/spotifybrazilian"
            },
            "href" : "https://api.spotify.com/v1/users/spotifybrazilian",
            "id" : "spotifybrazilian",
            "type" : "user",
            "uri" : "spotify:user:spotifybrazilian"
          },
          "public" : null,
          "snapshot_id" : "V66hh9k2HnLCdzHvtoXPv+tm0jp3ODM63SZ0oISfGnlHQxwG/scupDbKgIo99Zfz",
          "tracks" : {
            "href" : "https://api.spotify.com/v1/users/spotifybrazilian/playlists/4HZh0C9y80GzHDbHZyX770/tracks",
            "total" : 74
          },
          "type" : "playlist",
          "uri" : "spotify:user:spotifybrazilian:playlist:4HZh0C9y80GzHDbHZyX770"
        } ],
        "limit" : 2,
        "next" : "https://api.spotify.com/v1/browse/categories/party/playlists?country=BR&offset=2&limit=2",
        "offset" : 0,
        "previous" : null,
        "total" : 86
      }
    }
    """

  test "Unmarshal playlist":
    let
      paging = to[Paging[SimplePlaylist]](newJsonUnmarshaller(), json, "playlists")
      playlists = paging.items
      playlist = playlists[0]

    check(playlists.len == 2)
    check(playlist.collaborative == false)
    check(playlist.externalUrls.len == 1)
    check(playlist.href == "https://api.spotify.com/v1/users/spotifybrazilian/playlists/4k7EZPI3uKMz4aRRrLVfen")
    check(playlist.id == "4k7EZPI3uKMz4aRRrLVfen")
    check(playlist.images.len == 1)
    check(playlist.name == "Noite Eletrônica")
    check(playlist.owner.href == "https://api.spotify.com/v1/users/spotifybrazilian")
    check(playlist.owner.id == "spotifybrazilian")
    check(playlist.public == TypeNotRelevant)
    check(playlist.snapshotId == "PULvu1V2Ps8lzCxNXfNZTw4QbhBpaV0ZORc03Mw6oj6kQw9Ks2REwhL5Xcw/74wL")
    check(playlist.tracks.total == 100)
