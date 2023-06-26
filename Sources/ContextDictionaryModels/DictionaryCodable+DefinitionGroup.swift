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
        public var partOfSpeech: CDPartOfSpeech
        public var senses: [Sense]
        public var idioms: [Entry]
        public var phrasalVerbs: [Entry]
        public var pronunciations: [Pronunciation]
        
        /// Head info is used to display some additional information at the head of a definition group.
        ///
        /// Such as the inflection changes of a verb: "get and got", the degree of comparison: "good and better".
        /// This string is expected to be parsed as MarkDown.
        public var headInfoMDText: String?
        
        public init(id: String, partOfSpeech: CDPartOfSpeech = .verb, senses: [Sense] = [], idioms: [Entry] = [], phrasalVerbs: [Entry] = [], pronunciations: [Pronunciation] = [], headInfoMDText: String? = nil) {
            self.id = id
            self.partOfSpeech = partOfSpeech
            self.senses = senses
            self.idioms = idioms
            self.phrasalVerbs = phrasalVerbs
            self.pronunciations = pronunciations
            self.headInfoMDText = headInfoMDText
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<DictionaryCodable.DefinitionGroup.CodingKeys> = try decoder.container(keyedBy: DictionaryCodable.DefinitionGroup.CodingKeys.self)
            
            self.id = try container.decode(String.self, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.id)
            self.senses = try container.decode([DictionaryCodable.Sense].self, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.senses)
            self.idioms = try container.decode([DictionaryCodable.Entry].self, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.idioms)
            self.phrasalVerbs = try container.decode([DictionaryCodable.Entry].self, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.phrasalVerbs)
            self.pronunciations = try container.decode([DictionaryCodable.Pronunciation].self, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.pronunciations)
            self.headInfoMDText = try container.decodeIfPresent(String.self, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.headInfoMDText)
            
            if let pos = try? container.decodeIfPresent(CDPartOfSpeech.self, forKey: .partOfSpeech) {
                self.partOfSpeech = pos
            } else if let posString = try container.decodeIfPresent(String.self, forKey: .partOfSpeech) {
                self.partOfSpeech = .init(posString)
            } else {
                throw DecodingError.typeMismatch(CDPartOfSpeech.self, .init(codingPath: [CodingKeys.partOfSpeech], debugDescription: "can't decode part of speech"))
            }
        }
        
        enum CodingKeys: CodingKey {
            case id
            case partOfSpeech
            case senses
            case idioms
            case phrasalVerbs
            case pronunciations
            case headInfoMDText
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: DictionaryCodable.DefinitionGroup.CodingKeys.self)
            
            try container.encode(self.id, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.id)
            try container.encode(self.partOfSpeech, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.partOfSpeech)
            try container.encode(self.senses, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.senses)
            try container.encode(self.idioms, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.idioms)
            try container.encode(self.phrasalVerbs, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.phrasalVerbs)
            try container.encode(self.pronunciations, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.pronunciations)
            try container.encodeIfPresent(self.headInfoMDText, forKey: DictionaryCodable.DefinitionGroup.CodingKeys.headInfoMDText)
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
