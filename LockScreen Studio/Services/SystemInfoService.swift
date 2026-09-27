//
//  SystemInfoService.swift
//  LockScreen Studio
//

import Foundation
import AppKit

final class SystemInfoService {
    static let shared = SystemInfoService()

    private init() {}

    var hostName: String {
        Host.current().localizedName ?? "MacBook Pro"
    }

    var macOSVersion: String {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        return "macOS \(osVersion.majorVersion).\(osVersion.minorVersion)"
    }

    var cpuInfo: String {
        #if arch(arm64)
        return "Apple Silicon (M-Series)"
        #else
        return "Intel Core Processor"
        #endif
    }

    var memoryInfo: String {
        let bytes = ProcessInfo.processInfo.physicalMemory
        let gigaBytes = Double(bytes) / (1024 * 1024 * 1024)
        return String(format: "%.0f GB RAM", gigaBytes)
    }

    var uptimeFormatted: String {
        let uptime = ProcessInfo.processInfo.systemUptime
        let hours = Int(uptime) / 3600
        let minutes = (Int(uptime) % 3600) / 60
        return "\(hours)h \(minutes)m uptime"
    }
}
