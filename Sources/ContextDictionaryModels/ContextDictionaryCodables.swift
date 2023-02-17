//
//  DictionaryCodable.swift
//
//
//  Created by Kai Shao on 2023/2/15.
//

import Foundation

public enum DictionaryCodable {}

public extension DictionaryCodable {
    struct Entry: Codable {
        public var id: String
        public var text: String
        public var definitionGroups: [DefinitionGroup]
        
        public init(id: String, text: String, definitionGroups: [DefinitionGroup]) {
            self.id = id
            self.text = text
            self.definitionGroups = definitionGroups
        }
    }
}

public extension DictionaryCodable {
    struct SenseExample: Codable {
        public var id: String
        public var summary: String
        public var text: [String]
        public var labels: [CDSenseLabel]
        
        public init(id: String, summary: String, text: [String], labels: [CDSenseLabel]) {
            self.id = id
            self.summary = summary
            self.text = text
            self.labels = labels
        }
    }
    
    struct Sense: Codable {
        public var id: String
        public var text: String
        public var grammarTraits: [CDGrammarTrait]
        public var senseLabels: [CDSenseLabel]
        public var synonyms: [String]
        public var opposites: [String]
        public var examples: [SenseExample]
        public var children: [Sense]
        
        public init(id: String, text: String, grammarTraits: [CDGrammarTrait], senseLabels: [CDSenseLabel], synonyms: [String], opposites: [String], examples: [SenseExample], children: [Sense]) {
            self.id = id
            self.text = text
            self.grammarTraits = grammarTraits
            self.senseLabels = senseLabels
            self.synonyms = synonyms
            self.opposites = opposites
            self.examples = examples
            self.children = children
        }
    }
    
    struct DefinitionGroup: Codable {
        public var id: String
        public var partOfSpeech: CDPartOfSpeech?
        public var senses: [Sense]
        
        public init(id: String, partOfSpeech: CDPartOfSpeech? = nil, senses: [Sense]) {
            self.id = id
            self.partOfSpeech = partOfSpeech
            self.senses = senses
        }
    }
}
