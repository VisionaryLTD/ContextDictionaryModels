//
//  CDEnums.swift
//
//
//  Created by Kai Shao on 2022/11/8.
//

import Foundation

public struct CDPartOfSpeech: Codable, Hashable {
    public let rawValue: String
    
    static var possiblePhrasalVerbValues: [String] {
        ["phrasalVerb", "phrasal verb", "phrasal_verb"]
    }
    
    public init(_ rawValue: String) {
        if Self.possiblePhrasalVerbValues.contains(rawValue) {
            self = .phrasalVerb
        } else if let pos = Self.allCases.first(where: { $0.rawValue == rawValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }) {
            self = pos
        } else {
            self.rawValue = rawValue
        }
    }
}

public extension CDPartOfSpeech {
    static let verb: Self = .init("verb")
    static let noun: Self = .init("noun")
    static let adverb: Self = .init("adverb")
    static let adjective: Self = .init("adjective")
    static let idiom: Self = .init("idiom")
    static let phrasalVerb: Self = .init("phrasalVerb")
}

public extension CDPartOfSpeech {
    static var allCases: [CDPartOfSpeech] {
        [.verb, .noun, .adverb, .adjective, .adjective]
    }
}
