![Build Status](https://github.com/CORDEA/spotify/actions/workflows/build.yml/badge.svg?branch=master)

# spotify

A Nim wrapper for the Spotify Web API.

## Usage

This package supports authorization code grant and client credentials grant.

```nim
let
  token = newHttpClient().authorizationCodeGrant(
    "SPOTIFY_ID",
    "SPOTIFY_SECRET",
    @[SCOPES]
  )
  client = newSpotifyClient(token)
```

Or in your own way...

```nim
let client = newSpotifyClient(
  newSpotifyToken("ACCESS_TOKEN", "REFRESH_TOKEN (optional)", "EXPIRES_IN (optional)"))
```

And

```nim
let user = client.getCurrentUser()

if user.isSuccess:
  echo user.data.id
else:
  echo user.error.message
```

## License

```
Copyright 2018 Yoshihiro Tanaka

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
