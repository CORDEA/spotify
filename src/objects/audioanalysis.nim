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

type
  AudioAnalysisBar* = ref object
    start*, duration*, confidence*: float

  AudioAnalysisBeat* = ref object
    start*, duration*, confidence*: float

  AudioAnalysisMeta* = ref object
    analyzerVersion*, platform*: string
    detailedStatus*, inputProcess*: string
    statusCode*, timestamp*: int
    analysisTime*: float

  AudioAnalysisSection* = ref object
    start*, duration*: float
    loudness*, tempo*: float
    tempoConfidence*, keyConfidence*: float
    modeConfidence*: float
    confidence*, key*, mode*: int
    timeSignature*, timeSignatureConfidence*: int

  AudioAnalysisSegment* = ref object
    start*, duration*, confidence*: float
    loudnessStart*, loudnessMaxTime*: float
    loudnessMax*, loudnessEnd*: float
    pitches*, timbre*: seq[float]

  AudioAnalysisTatum* = ref object
    start*, duration*, confidence*: float

  AudioAnalysisTrack* = ref object
    numSamples*, offsetSeconds*, windowSeconds*: int
    analysisSampleRate*, analysisChannels*: int
    endOfFadeIn*, timeSignature*: int
    timeSignatureConfidence*, key*, mode*: int
    synchVersion*, rhythmVersion*: int
    duration*, startOfFadeOut*, loudness*: float
    tempo*, tempoConfidence*: float
    keyConfidence*, modeConfidence*: float
    codeVersion*, echoprintVersion*: float
    sampleMd5*, codestring*, echoprintstring*: string
    synchstring*, rhythmstring*: string

  AudioAnalysis* = ref object
    bars*: seq[AudioAnalysisBar]
    beats*: seq[AudioAnalysisBeat]
    meta*: AudioAnalysisMeta
    sections*: seq[AudioAnalysisSection]
    segments*: seq[AudioAnalysisSegment]
    tatums*: seq[AudioAnalysisTatum]
    track*: AudioAnalysisTrack
