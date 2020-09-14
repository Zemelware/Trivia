//
//  DecodeHTMLExtension.swift
//  Trivia
//
//  Created by Ethan Zemelman on 2020-09-13.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import Foundation

extension String {
    
    func decodeHTML() -> String {
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let decodedString = try? NSAttributedString(data: Data(utf8), options: options, documentAttributes: nil).string
        
        return decodedString ?? self
        
    }
    
}
