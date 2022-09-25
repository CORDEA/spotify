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
# date  : 2018-09-19

import os
import httpclient
import .. / src / spotify / tracks
import .. / src / spotify / spotifyclient

let
  token = newHttpClient().authorizationCodeGrant(
    getEnv("SPOTIFY_ID"),
    getEnv("SPOTIFY_SECRET"),
    @[]
  )
  client = newSpotifyClient(token)
  audioAnalysis = client.getAudioAnalysis("3JIxjvbbDrA9ztYlNcp3yL").data
  audioFeature = client.getAudioFeature("06AKEBrKUckW0KREUWRnvT").data
  audioFeatures = client.getAudioFeatures(@[
    "4JpKVNYnVcJ8tuMKjAj50A",
    "2NRANZE9UCmPAS5XVbXL40",
    "24JygzOLM0EmRQeGtFcIcG"
  ]).data
  track = client.getTrack("11dFghVXANMlKmJXsNCbNl").data
  tTracks = client.getTracks(@[
    "11dFghVXANMlKmJXsNCbNl",
    "20I6sIOMTCkB6w7ryavxtO",
    "7xGfFoTpQ2E7fRF5lN10tr"
  ]).data

echo audioAnalysis.meta.platform
echo $audioAnalysis.bars.len

echo audioFeature.analysisUrl

for f in audioFeatures:
  echo f.analysisUrl

echo track.name

for t in tTracks:
  echo t.name
