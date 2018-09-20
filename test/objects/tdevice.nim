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
# date  : 2018-09-16

import unittest
import .. / .. / src / objects / device
import .. / .. / src / objects / jsonunmarshaller
import .. / .. / src / objects / internalunmarshallers

suite "Device test":
  setup:
    const json = """
    {
      "devices" : [ {
        "id" : "5fbb3ba6aa454b5534c4ba43a8c7e8e45a63ad0e",
        "is_active" : false,
        "is_private_session": true,
        "is_restricted" : false,
        "name" : "My fridge",
        "type" : "Computer",
        "volume_percent" : 100
      } ]
    }
    """

  test "Unmarshal devices":
    let
      devices = toSeq[Device](newJsonUnmarshaller(deviceReplaceTargets), json, "devices")
      device = devices[0]
    check(devices.len == 1)
    check(device.id == "5fbb3ba6aa454b5534c4ba43a8c7e8e45a63ad0e")
    check(device.isActive == false)
    check(device.isPrivateSession == true)
    check(device.isRestricted == false)
    check(device.name == "My fridge")
    check(device.deviceType == TypeComputer)
    check(device.volumePercent == 100)
