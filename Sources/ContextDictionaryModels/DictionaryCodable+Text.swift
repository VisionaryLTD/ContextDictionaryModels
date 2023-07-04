//
//  DictionaryCodable+Text.swift
//
//
//  Created by Kai Shao on 2023/6/26.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

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
        
        public func displayText() -> String {
            var string = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let translation = translation?.rawText {
                string += " \(translation.trimmingCharacters(in: .whitespacesAndNewlines))"
            }
            
            return string.trimmingCharacters(in: .whitespacesAndNewlines)
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
            
            if let translation = try? container.decodeIfPresent(DictionaryCodable.Text.self, forKey: DictionaryCodable.Text.CodingKeys.translation) {
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
            
            public func validate() throws {}
        }

        public func validate() throws {
//            guard !rawText.isEmpty else {
//                throw DicationaryCodableError.invalid("Text's raw text can't be empty")
//            }
        }
    }
}
