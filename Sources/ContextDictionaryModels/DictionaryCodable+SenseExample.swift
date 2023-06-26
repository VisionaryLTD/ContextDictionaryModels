//
//  DictionaryCodable+SenseExample.swift
//  
//
//  Created by Kai Shao on 2023/6/26.
//

import Foundation

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
        
        public func validate() throws {
            guard !texts.isEmpty else {
                throw DicationaryCodableError.invalid("example's texts can't be empty")
            }
            
            try texts.forEach({ try $0.validate() })
        }
    }
}
