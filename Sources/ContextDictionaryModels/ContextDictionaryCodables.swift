//
//  DictionaryCodable.swift
//
//
//  Created by Kai Shao on 2023/2/15.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public enum DictionaryCodable {}

typealias DicationaryCodableKind = Codable & Hashable

public extension DictionaryCodable {
    struct Entry: DicationaryCodableKind {
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
    struct Text: DicationaryCodableKind {
        public var id: String
        public var rawText: String
        public var attributedString: AttributedString?
        public var lang: Lang
        /// Translations of the text
        ///
        /// Due to a struct can't contain recursive property, so makes it an array.
        var translations: [Text]
        
        public var translation: Text? {
            get {
                translations.first
            }
            
            set {
                translations = [newValue].compactMap { $0 }
            }
        }
        
        public var unwrappedAttributedString: AttributedString {
            attributedString ?? .init(rawText)
        }
        
        public init(id: String = UUID().uuidString, rawText: String = "", attributedString: AttributedString? = nil, lang: Lang = .en, translation: Text? = nil) {
            self.id = id
            self.rawText = rawText
            self.attributedString = attributedString
            self.lang = lang
            self.translations = [translation].compactMap { $0 }
        }
        
        #if canImport(UIKit)
        public init(id: String = UUID().uuidString, htmlString: String, lang: Lang = .en, translation: Text? = nil) throws {
            self.id = id
            
            let htmlData = htmlString.data(using: .utf8)!
            let nsAttributedString = try NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            var attributedString = AttributedString(nsAttributedString)
            attributedString.font = attributedString.font?.withSize(UIFont.preferredFont(forTextStyle: .body).pointSize)
            
            self.rawText = nsAttributedString.string
            self.attributedString = attributedString
            self.lang = lang
            self.translations = [translation].compactMap { $0 }
        }
        #endif
        
        public enum Lang: String, DicationaryCodableKind {
            case en, zh
        }
    }
}

public extension DictionaryCodable {
    struct SenseLabel: DicationaryCodableKind {
        public enum Kind: String, DicationaryCodableKind {
            case label, grammarTrait
        }
        
        public var id: String
        public var text: String
        public var kind: Kind
        
        public init(id: String, text: String, kind: Kind) {
            self.id = id
            self.text = text
            self.kind = kind
        }
    }
    
    struct SenseExample: DicationaryCodableKind {
        public var id: String
        public var summary: String
        public var texts: [Text]
        public var labels: [SenseLabel]
        public var children: [SenseExample]
        
        public var text: Text! {
            get { texts.first }
            set { texts = [newValue].compactMap { $0 } }
        }
        
        public init(id: String = UUID().uuidString, summary: String = "", text: Text = .init(), labels: [SenseLabel] = [], children: [SenseExample] = []) {
            self.id = id
            self.summary = summary
            self.texts = [text]
            self.labels = labels
            self.children = children
        }
    }
    
    struct Sense: DicationaryCodableKind {
        public var id: String
        public var text: Text
        public var senseLabels: [SenseLabel]
        public var synonyms: [String]
        public var opposites: [String]
        public var examples: [SenseExample]
        public var children: [Sense]
        
        public init(id: String = UUID().uuidString, text: Text = .init(), senseLabels: [SenseLabel] = [], synonyms: [String] = [], opposites: [String] = [], examples: [SenseExample] = [], children: [Sense] = []) {
            self.id = id
            self.text = text
            self.senseLabels = senseLabels
            self.synonyms = synonyms
            self.opposites = opposites
            self.examples = examples
            self.children = children
        }
    }
    
    struct DefinitionGroup: DicationaryCodableKind {
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
