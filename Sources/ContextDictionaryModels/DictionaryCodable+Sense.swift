//
//  DictionaryCodable+Sense.swift
//  
//
//  Created by Kai Shao on 2023/6/26.
//

import Foundation

public extension DictionaryCodable {
    struct Sense: DicationaryCodableKind {
        public var id: String
        public var parentID: String?
        public var text: Text
        public var usageText: String?
        public var labels: [String]
        public var grammarTraitLabels: [String]
        public var synonyms: [String]
        public var opposites: [String]
        public var relatedEntries: [String]
        public var examples: [SenseExample]
        public var likedCount: Int?
        public var children: [Sense]
        
        /// HTML to display some additional note text.
        public var noteHTML: String?
        
        public init(id: String, text: Text = .init(id: UUID().uuidString), usageText: String? = nil, labels: [String] = [], grammarTraitLabels: [String] = [], synonyms: [String] = [], opposites: [String] = [], relatedEntries: [String] = [], examples: [SenseExample] = [], likedCount: Int? = nil, noteHTML: String? = nil, children: [Sense] = []) {
            self.id = id
            self.text = text
            self.usageText = usageText
            self.synonyms = synonyms
            self.opposites = opposites
            self.relatedEntries = relatedEntries
            self.examples = examples
            self.likedCount = likedCount
            self.labels = labels
            self.grammarTraitLabels = grammarTraitLabels
            self.noteHTML = noteHTML
            self.children = children
        }
        
        public func validate() throws {
            try examples.forEach { try $0.validate() }
        }
    }
}
