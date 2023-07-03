//
//  DictionaryCodable+Entry.swift
//  
//
//  Created by Kai Shao on 2023/6/26.
//

import Foundation

public extension DictionaryCodable {
    struct Entry: DicationaryCodableKind {
        public enum Kind: String, DicationaryCodableKind {
            case word, phrasalVerb, idiom
            
            public func validate() throws {}
        }
        
        public struct ExtensionInfo: DicationaryCodableKind {
            public var extID: String
            public var title: String
            public var version: String
            public var imageData: Data?
            public var copyright: String?
            
            public init(extID: String, title: String, version: String, imageData: Data? = nil, copyright: String? = nil) {
                self.extID = extID
                self.title = title
                self.version = version
                self.imageData = imageData
                self.copyright = copyright
            }
            
            public func validate() throws {
                
            }
        }
        
        public var id: String
        public var text: String
        public var definitionGroups: [DefinitionGroup]
        public var sourceURL: URL?
        public var extInfo: ExtensionInfo?
        
        public var kind: Kind {
            switch definitionGroups.first?.partOfSpeech {
            case CDPartOfSpeech.phrasalVerb: return .phrasalVerb
            case CDPartOfSpeech.idiom: return .idiom
            default: return .word
            }
        }
        
        /// Text in Markdown to display some additional information about the entry, such as concise senses of the entry.
        public var additionalMDText: String?
        
        public init(id: String, text: String = "", definitionGroups: [DefinitionGroup] = [], additionalMDText: String? = nil) {
            self.id = id
            self.text = text
            self.definitionGroups = definitionGroups
            self.additionalMDText = additionalMDText
        }
        
        public func validate() throws {
            try definitionGroups.forEach { try $0.validate() }
            
            switch kind {
            case .phrasalVerb:
                guard definitionGroups.isEmpty == false else {
                    throw DicationaryCodableError.invalid("phrasal verb's definition group can't be empty or more than one")
                }
            case .idiom:
                guard definitionGroups.isEmpty == false else {
                    throw DicationaryCodableError.invalid("idiom's definition group can't be empty or more than one")
                }
            default:
                guard definitionGroups.isEmpty == false else {
                    throw DicationaryCodableError.invalid("definition group can't be empty or more than one")
                }
            }
        }
    }
}
