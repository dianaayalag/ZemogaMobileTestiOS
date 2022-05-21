//
//  Errors.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import Foundation

enum ZMTErrors: LocalizedError {
    case idNotFound
    case unknownError
    case urlNotFound
    case generic(String)
    
    var errorDescription: String? {
        switch self {
        case .idNotFound:
            return "ID not found"
        case .unknownError:
            return "Unknown error"
        case .urlNotFound:
            return "URL not found"
        case .generic(let message):
            return message
        }
    }
}
