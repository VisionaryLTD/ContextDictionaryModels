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
    
    private init(builtInValue value: String) {
        self.rawValue = value
    }
}

public extension CDPartOfSpeech {
    static var verb: Self { .init(builtInValue: "verb") }
    static var noun: Self { .init(builtInValue: "noun") }
    static var adverb: Self { .init(builtInValue: "adverb") }
    static var adjective: Self { .init(builtInValue: "adjective") }
    static var idiom: Self { .init(builtInValue: "idiom") }
    static var phrasalVerb: Self { .init(builtInValue: "phrasalVerb") }
}

public extension CDPartOfSpeech {
    static var allCases: [CDPartOfSpeech] {
        [.verb, .noun, .adverb, .adjective, .adjective]
    }
}
