//
//  ErrorModel.swift
//  BoredApp
//
//  Created by user on 20.09.2021.
//

import Foundation

// MARK: - ErrorModel
class ErrorModel: Codable {
    let error: String

    init(error: String) {
        self.error = error
    }
}
