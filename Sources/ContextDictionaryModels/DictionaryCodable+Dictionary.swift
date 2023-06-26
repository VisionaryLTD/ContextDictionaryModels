//
//  DictionaryCodable+Dictionary.swift
//  
//
//  Created by Kai Shao on 2023/6/26.
//

import Foundation

public extension DictionaryCodable {
    struct Dictionary: DicationaryCodableKind {
        public var id: String
        public var title: String
        
        public init(id: String, title: String) {
            self.id = id
            self.title = title
        }
        
        public func validate() throws {}
    }
}
