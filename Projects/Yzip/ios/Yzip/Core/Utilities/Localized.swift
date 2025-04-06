//
// Localized.swift
// Yzip
//
// Created 4/5/25
// Copyright © 2025 Yzip. All rights reserved.
//

import Foundation

extension String {
    func localized(_ args: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: args)
    }
}
