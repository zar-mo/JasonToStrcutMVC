//
//  ViewModel.swift
//  JasonToStrcutMVC
//
//  Created by Abouzar Moradian on 9/13/24.
//

import Foundation
import Combine

protocol ViewModelDelegate: AnyObject{
    
    func didLibraryChange(library: Library)
}

class ViewModel{
    
    //for observing viewModel using delegate approach
    weak var delegate: ViewModelDelegate?
    
    //for observing viewModel using Combine approach
    var library: CurrentValueSubject<Library?, Never>
    
    //for observing viewModel using closure approach
    var closure: ((Library) -> ())?
    
    
    init(){
        self.library = CurrentValueSubject<Library?, Never>(nil)
        setInitialLibrary()
    }
    
    
    func setInitialLibrary() {
        
        let libraryObject = decodeLibraryFromJsonString(jsonString: jsonLibrary)
        library = CurrentValueSubject<Library?, Never>(libraryObject)
        
        //for delegate approach only
        if let libraryObject = libraryObject{
            delegate?.didLibraryChange(library: libraryObject)
        }
        
        //for closure approach only
        if let libraryObject = libraryObject{
            closure?(libraryObject)
        }
    }
    
    func decodeLibraryFromJsonString(jsonString: String) -> Library?{
        
        guard let jsonData = convertJSONStringToData(jsonString: jsonString) else { return nil}
        return  decodeLibraryFromData(jsonData: jsonData)
        
        
    }
    
    func convertJSONStringToData(jsonString: String) -> Data? {
        return jsonString.data(using: .utf8)
    }
 
    func decodeLibraryFromData(jsonData: Data) -> Library? {
        
        struct LibraryWrapper: Codable {
            let library: Library
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        
        do {
            let libraryWrapper = try decoder.decode(LibraryWrapper.self, from: jsonData)
            return libraryWrapper.library
        } catch {
            print("Error decoding JSON data: \(error)")
            return nil
        }
    }
    
    func saveJsonStringTofile(jsonString: String, fileName: String) {
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let fileUrl = directory.appendingPathComponent("\(fileName).json")
        
        do{
            try jsonString.write(to: fileUrl, atomically: true, encoding: .utf8)
        }catch{
            print("Failed to save json file \(error)")
        }
    }
    
    func loadJsonFromFile(fileName: String) -> Data?{
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first else {return nil}
        
        let fileUrl = directory.appendingPathComponent("\(fileName).json")
        do{
             return try Data(contentsOf: fileUrl)
        }catch{
            print("Failed to load data:  \(error)")
            return nil
        }
     
    }
    
    
    let jsonLibrary = """
    {
      "library": {
        "name": "My Library",
        "location": "New York",
        "books": [
          {
            "title": "The Great Gatsby",
            "author": {
              "name": "F. Scott Fitzgerald",
              "birth_year": 1896,
              "nationality": "American"
            },
            "publication_year": 1925,
            "genres": ["Fiction", "Classic", "Literary"]
          },
          {
            "title": "To Kill a Mockingbird",
            "author": {
              "name": "Harper Lee",
              "birth_year": 1926,
              "nationality": "American"
            },
            "publication_year": 1960,
            "genres": ["Fiction", "Classic", "Literary"]
          }
        ]
      }
    }
   """



    
}


