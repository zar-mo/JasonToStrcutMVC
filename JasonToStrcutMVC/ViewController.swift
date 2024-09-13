//
//  ViewController.swift
//  JasonToStrcutMVC
//
//  Created by Abouzar Moradian on 9/13/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    
    var viewModel = ViewModel()
    
    var library: Library?
    var cancellable: AnyCancellable?
    
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var libraryNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if we take delegate approach
        //viewModel.delegate = self
        //if we take combine approach
        subscribeToLibrary()
        //if we take closure approach
        //viewModel.closure = { library in self.libraryNameLabel.text = library.name}
        
  
    }
    
    @IBAction func changeNameButton(_ sender: UIButton) {
        
        if let newName = libraryNameTF.text, !newName.isEmpty{
            viewModel.library.value?.name = newName
            
            //for delegate approach only
            if let newLibrary = viewModel.library.value{
                viewModel.delegate?.didLibraryChange(library: newLibrary)
            }
            
            //for closure approach only
            if let newLibrary = viewModel.library.value{
                viewModel.closure?(newLibrary)
            }
        }
    }
    
    func subscribeToLibrary(){
        cancellable = viewModel.library.sink(receiveValue: { [weak self] value in
            
            if let library = value {
                self?.library = library
                self?.libraryNameLabel.text = library.name
                
            }
        })
            
       
        
    }
    
}


//only for delegate approach
extension  ViewController:  ViewModelDelegate {
    func didLibraryChange(library: Library) {
        
        libraryNameLabel.text = library.name
    }
    
}
    


