//
//  DictionaryCodable+DefinitionGroup.swift
//  
//
//  Created by Kai Shao on 2023/6/26.
//

import Foundation

public extension DictionaryCodable {
    struct DefinitionGroup: DicationaryCodableKind {
        public var id: String
        public var partOfSpeech: String?
        public var senses: [Sense]
        public var idioms: [Entry]
        public var phrasalVerbs: [Entry]
        public var pronunciations: [Pronunciation]
        
        /// Head info is used to display some additional information at the head of a definition group.
        ///
        /// Such as the inflection changes of a verb: "get and got", the degree of comparison: "good and better".
        /// This string is expected to be parsed as MarkDown.
        public var headInfoMDText: String?
        
        public init(id: String, partOfSpeech: String? = nil, senses: [Sense] = [], idioms: [Entry] = [], phrasalVerbs: [Entry] = [], pronunciations: [Pronunciation] = [], headInfoMDText: String? = nil) {
            self.id = id
            self.partOfSpeech = partOfSpeech
            self.senses = senses
            self.idioms = idioms
            self.phrasalVerbs = phrasalVerbs
            self.pronunciations = pronunciations
            self.headInfoMDText = headInfoMDText
        }
        
        public func validate() throws {
            guard !senses.isEmpty else {
                throw DicationaryCodableError.invalid("senses of the definitionGroup can't be empty")
            }
            
            try senses.forEach({ try $0.validate() })
            try idioms.forEach( { try $0.validate() })
            try phrasalVerbs.forEach( { try $0.validate() })
            try pronunciations.forEach( { try $0.validate() })
        }
    }
}

public extension DictionaryCodable {
    struct Pronunciation: DicationaryCodableKind {
        public var id: String
        public var geoKind: String
        public var phoneticAlphabet: String
        public var url: URL?
        
        public init(id: String, geoKind: String = "", phoneticAlphabet: String = "", url: URL? = nil) {
            self.id = id
            self.geoKind = geoKind
            self.phoneticAlphabet = phoneticAlphabet
            self.url = url
        }
        
        public func validate() throws {}
    }
}
