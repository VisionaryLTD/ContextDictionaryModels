//
//  CDEnums.swift
//
//
//  Created by Kai Shao on 2022/11/8.
//

import Foundation

public struct CDPartOfSpeech: Codable, Hashable {
    public let value: String
    
    static var possiblePhrasalVerbValues: [String] {
        ["phrasalVerb", "phrasal verb", "phrasal_verb"]
    }
    
    public init(value: String) {
        if Self.possiblePhrasalVerbValues.contains(value) {
            self = .phrasalVerb
        } else if let pos = Self.allCases.first(where: { $0.value == value.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }) {
            self = pos
        } else {
            self.value = value
        }
    }
}

public extension CDPartOfSpeech {
    static let verb: Self = .init(value: "verb")
    static let noun: Self = .init(value: "noun")
    static let adverb: Self = .init(value: "adverb")
    static let adjective: Self = .init(value: "adjective")
    static let idiom: Self = .init(value: "idiom")
    static let phrasalVerb: Self = .init(value: "phrasalVerb")
}

public extension CDPartOfSpeech {
    static var allCases: [CDPartOfSpeech] {
        [.verb, .noun, .adverb, .adjective, .adjective]
    }
}
