//
//  SearchHeader.swift
//  BooksApp
//
//  Created by Ayush on 08/04/24.
//

import UIKit

protocol SearchInput {
    
}

protocol SearchOutput {
    
}

protocol SearchBarAction {
    
}

typealias SearchBarProtocol = SearchInput & SearchOutput & SearchBarAction

class SearchBar: UIView, SearchBarProtocol {
    
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var tapSearchBtn: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
