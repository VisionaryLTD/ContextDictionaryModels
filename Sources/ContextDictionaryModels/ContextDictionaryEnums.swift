//
//  CDEnums.swift
//
//
//  Created by Kai Shao on 2022/11/8.
//

import Foundation

public enum CDGrammarTrait: String, CaseIterable, Codable, Hashable {
    case intransitive
    case transitive
    case uncountable
    case countable
    case singular
    case plural
    case noPassive
    case usuallyPassive
    case usuallySingular
    case onlyBeforeNoun
    case oftenPassive
    case linkingVerb
}

public enum CDSenseLabel: String, Codable, Hashable {
    case usuallyDisapproving
    case literary
    case informal
    case formal
    case humorous
    case oldFashioned
    case saying
    case brE
    case nAE
    case slang
    case figurative
    case phonetics
    case disapproving
    case computing
    case politics
    case colloquial
    case obsolete
}

public enum CDPartOfSpeech: String, CaseIterable, Codable, Hashable {
    case verb
    case noun
    case adverb
    case adjective
    case definiteArticle
    case indefiniteArticle
    case infinitiveMarker
    case phrasalVerb
    case modalVerb
    case exclamation
    case preposition
    case pronoun
    case interjection
    case idiom
    case conjunction
    case determiner
    case number
    case none
    case abbreviation
    case symbol
    case suffix
    case prefix
    case combiningForm
    case shortForm
    
    case unknown
}

//public enum CDEntryType: String, CaseIterable, Codable, Hashable {
//    case word
//    case phrasalVerb
//}
