//
//  DictionaryCodable.swift
//
//
//  Created by Kai Shao on 2023/2/15.
//

import Foundation

public enum DictionaryCodable {}

public protocol DicationaryCodableKind: Codable, Hashable {
    func validate() throws
}

public enum DicationaryCodableError: Error {
    case invalid(String)
}
