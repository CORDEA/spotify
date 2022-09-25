# Package

version     = "0.1.1"
author      = "Yoshihiro Tanaka"
description = "A Nim wrapper for the Spotify Web API"
license     = "Apache License 2.0"
srcDir      = "src"

# Deps

requires "nim >= 0.18.0"
requires "oauth"

task test, "Test spotify":
  exec "find src/ -name \"*.nim\" | xargs -I {} nim c -r -d:testing -d:ssl -o:test {}"
  exec "find test/ -name \"*.nim\" | xargs -I {} nim c -r {}"
  exec "find examples/ -name \"*.nim\" | xargs -I {} nim c -d:ssl {}"
