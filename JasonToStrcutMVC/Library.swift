//
//  Library.swift
//  JasonToStrcutMVC
//
//  Created by Abouzar Moradian on 9/13/24.
//

import Foundation



struct Library: Codable{
    var name: String
    let location: String
    let books: [Book]
    
    mutating func changeName(newName: String){
        name = newName
    }
}

struct Book : Codable{
    let title: String
    let author: Author
    let publicationYear: Int
    let genres: [GenreEnum]
    
//    enum CodingKeys: String, CodingKey {
//            case title, author, publicationYear = "publication_year", genres
//        }
}

struct Author : Codable{
    let name: String
    let birthYear: Int
    let nationality: String
    
//    enum CodingKeys: String, CodingKey {
//            case name, birthYear = "birth_year", nationality
//        }
}

enum GenreEnum: String, Codable{
    case fiction = "Fiction"
    case classic = "Classic"
    case literary = "Literary"
}

 



