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
    struct Dictionary: DicationaryCodableKind {
        public var id: String
        public var title: String
        
        public init(id: String, title: String) {
            self.id = id
            self.title = title
        }
    }
    
    struct Entry: DicationaryCodableKind {
        public enum Kind: String, DicationaryCodableKind {
            case word, phrasalVerb, idiom
        }
        
        public var id: String
        public var text: String
        public var origin: String?
        public var definitionGroups: [DefinitionGroup]
        
        public var kind: Kind {
            switch definitionGroups.first?.partOfSpeech {
            case "phrasalVerb":
                return .phrasalVerb
            case "idiom":
                return .idiom
            default:
                return .word
            }
        }
        
        /// Text in Markdown to display some additional information about the entry, such as concise senses of the entry.
        public var additionalMDText: String?
        
        public init(id: String, text: String = "", origin: String? = nil, definitionGroups: [DefinitionGroup] = [], additionalMDText: String? = nil) {
            self.id = id
            self.text = text
            self.origin = origin
            self.definitionGroups = definitionGroups
            self.additionalMDText = additionalMDText
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
        var translations: [Text]?
        
        public var translation: Text? {
            get {
                translations?.first
            }
            
            set {
                translations = [newValue].compactMap { $0 }
            }
        }
        
        public var unwrappedAttributedString: AttributedString {
            attributedString ?? .init(rawText)
        }
        
        enum CodingKeys: CodingKey {
            case id
            case rawText
            case attributedString
            case lang
            case translations
            case translation
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<DictionaryCodable.Text.CodingKeys> = try decoder.container(keyedBy: DictionaryCodable.Text.CodingKeys.self)
            self.id = try container.decode(String.self, forKey: DictionaryCodable.Text.CodingKeys.id)
            self.rawText = try container.decode(String.self, forKey: DictionaryCodable.Text.CodingKeys.rawText)
            self.attributedString = try container.decodeIfPresent(AttributedString.self, forKey: DictionaryCodable.Text.CodingKeys.attributedString)
            self.lang = try container.decode(DictionaryCodable.Text.Lang.self, forKey: DictionaryCodable.Text.CodingKeys.lang)
            
            if let translation = try container.decodeIfPresent(DictionaryCodable.Text.self, forKey: DictionaryCodable.Text.CodingKeys.translation) {
                self.translations = [translation]
            } else if let translations = try container.decodeIfPresent([DictionaryCodable.Text].self, forKey: DictionaryCodable.Text.CodingKeys.translations) {
                self.translations = translations
            } else {
                self.translations = []
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(id, forKey: .id)
            try container.encode(rawText, forKey: .rawText)
            try container.encode(attributedString, forKey: .attributedString)
            try container.encode(lang, forKey: .lang)
            try container.encode(translations, forKey: .translations)
        }
        
        public init(id: String, rawText: String = "", attributedString: AttributedString? = nil, lang: Lang = .en, translation: Text? = nil) {
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
    struct SenseExample: DicationaryCodableKind {
        public var id: String
        public var summary: String?
        public var texts: [Text]
        public var children: [SenseExample]
        
        public var text: Text! {
            get { texts.first }
            set { texts = [newValue].compactMap { $0 } }
        }
        
        public init(id: String, summary: String? = nil, text: Text = .init(id: UUID().uuidString), children: [SenseExample] = []) {
            self.id = id
            self.summary = summary
            self.texts = [text]
            self.children = children
        }
        
        enum CodingKeys: CodingKey {
            case id
            case summary
            case texts
            case text
            case children
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<DictionaryCodable.SenseExample.CodingKeys> = try decoder.container(keyedBy: DictionaryCodable.SenseExample.CodingKeys.self)
            
            self.id = try container.decode(String.self, forKey: DictionaryCodable.SenseExample.CodingKeys.id)
            self.summary = try container.decodeIfPresent(String.self, forKey: DictionaryCodable.SenseExample.CodingKeys.summary)
            
            if let text = try container.decodeIfPresent(DictionaryCodable.Text.self, forKey: .text) {
                self.texts = [text]
            } else if let texts = try container.decodeIfPresent([DictionaryCodable.Text].self, forKey: DictionaryCodable.SenseExample.CodingKeys.texts) {
                self.texts = texts
            } else {
                self.texts = []
            }
            
            self.children = try container.decode([DictionaryCodable.SenseExample].self, forKey: DictionaryCodable.SenseExample.CodingKeys.children)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(id, forKey: .id)
            try container.encode(summary, forKey: .summary)
            try container.encode(texts, forKey: .texts)
            try container.encode(children, forKey: .children)
        }
    }
    
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
    }
    
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
    }
    
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
    }
}
