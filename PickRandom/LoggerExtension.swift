//
//  LoggerExtension.swift
//  PickRandom
//
//  Created by Андрей on 22.11.2025.
//
import OSLog

extension Logger {
    private static var subsystem = "PickRandom"

    static let main = Logger(subsystem: subsystem, category: "main")
}
