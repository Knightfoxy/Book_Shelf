//
//  CommonFunctions.swift
//  BooksApp
//
//  Created by Ayush on 08/04/24.
//

import Foundation

extension String {
    
    func replaceSpacesWithPlus() -> String {
        return self.replacingOccurrences(of: " ", with: "+")
    }
    
}
