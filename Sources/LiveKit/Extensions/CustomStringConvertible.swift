/*
 * Copyright 2023 LiveKit
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

@_implementationOnly import WebRTC

extension TrackSettings: CustomStringConvertible {
    public var description: String {
        "TrackSettings(enabled: \(enabled), dimensions: \(dimensions), videoQuality: \(videoQuality))"
    }
}

extension Livekit_VideoLayer: CustomStringConvertible {
    public var description: String {
        "VideoLayer(quality: \(quality), dimensions: \(width)x\(height), bitrate: \(bitrate))"
    }
}

public extension TrackPublication {
    override var description: String {
        "\(String(describing: type(of: self)))(sid: \(sid), kind: \(kind), source: \(source))"
    }
}

extension Livekit_AddTrackRequest: CustomStringConvertible {
    public var description: String {
        "AddTrackRequest(cid: \(cid), name: \(name), type: \(type), source: \(source), width: \(width), height: \(height), muted: \(muted))"
    }
}

extension Livekit_TrackInfo: CustomStringConvertible {
    public var description: String {
        "TrackInfo(sid: \(sid), " +
            "name: \(name), " +
            "type: \(type), " +
            "source: \(source), " +
            "width: \(width), " +
            "height: \(height), " +
            "muted: \(muted), " +
            "simulcast: \(simulcast), " +
            "codecs: \(codecs.map { String(describing: $0) }), " +
            "layers: \(layers.map { String(describing: $0) }))"
    }
}

extension Livekit_SubscribedQuality: CustomStringConvertible {
    public var description: String {
        "SubscribedQuality(quality: \(quality), enabled: \(enabled))"
    }
}

extension Livekit_SubscribedCodec: CustomStringConvertible {
    public var description: String {
        "SubscribedCodec(codec: \(codec), qualities: \(qualities.map { String(describing: $0) }.joined(separator: ", "))"
    }
}

extension Livekit_ServerInfo: CustomStringConvertible {
    public var description: String {
        "ServerInfo(edition: \(edition), " +
            "version: \(version), " +
            "protocol: \(`protocol`), " +
            "region: \(region), " +
            "nodeID: \(nodeID), " +
            "debugInfo: \(debugInfo))"
    }
}

// MARK: - NSObject

public extension Room {
    override var description: String {
        "Room(sid: \(sid ?? "nil"), name: \(name ?? "nil"), serverVersion: \(serverVersion ?? "nil"), serverRegion: \(serverRegion ?? "nil"))"
    }
}

public extension Participant {
    override var description: String {
        "\(String(describing: type(of: self)))(sid: \(sid))"
    }
}

public extension Track {
    override var description: String {
        "\(String(describing: type(of: self)))(sid: \(sid ?? "nil"), name: \(name), source: \(source))"
    }
}
