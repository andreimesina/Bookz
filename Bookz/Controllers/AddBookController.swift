//
//  AddBookController.swift
//  Bookz
//
//  Created by Andrei Mesina on 27/05/2020.
//  Copyright © 2020 Andrei Mesina. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

protocol AddBookControllerDelegate: class {
    func setAddedBookSuccess(isSuccessful: Bool)
}

class AddBookController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var pagesTextField: UITextField!
    @IBOutlet weak var currentPageTextField: UITextField!
    @IBOutlet weak var pdfLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var uploadProgressView: UIProgressView!
    
    weak var delegate: AddBookControllerDelegate?
    lazy var booksManager: BooksManager = BooksManager()
    
    private var localFilename: String?
    private var localPdfUrl: URL?
    
    @IBAction func onSelectButtonClick(_: UIButton) {
        // Create a document picker for directories.
        let documentPicker =
            UIDocumentPickerViewController(documentTypes: [kUTTypePDF] as [String],
                                           in: .open)

        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        // Present the document picker.
        present(documentPicker, animated: true)
    }
    
    @IBAction func onUploadButtonClick(_: UIButton) {
        guard let localPdfUrl = localPdfUrl else {
            return
        }
        
        guard let localFilename = localFilename else {
            return
        }
        
        uploadProgressView.alpha = 1
        selectButton.isEnabled = false
        uploadButton.isEnabled = false
        
        booksManager.uploadPdf(localURL: localPdfUrl, filename: localFilename) { error in
            if let error = error {
                self.selectButton.isEnabled = true
                self.uploadButton.isEnabled = true
                print(error)
            } else {
                self.uploadProgressView.setProgress(0.5, animated: true)
                
                let book = Book(
                    id: 1,
                    author: self.authorTextField.text ?? "No author",
                    coverImageName: "test.jpg",
                    currentPage: Int(self.currentPageTextField.text ?? "0") ?? 0,
                    fileName: localFilename,
                    genreId: 1,
                    pages: Int(self.pagesTextField.text ?? "0") ?? 0,
                    title: self.titleTextField.text ?? "No title"
                )
                
                self.booksManager.addBook(book: book) { error in
                    if let error = error {
                        self.uploadProgressView.setProgress(0.0, animated: true)
                        self.selectButton.isEnabled = true
                        self.uploadButton.isEnabled = true
                        print(error)
                    } else {
                        self.uploadProgressView.setProgress(1.0, animated: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            self.dismiss(animated: true) {
                                self.delegate?.setAddedBookSuccess(isSuccessful: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func closeKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

extension AddBookController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        localPdfUrl = urls[0]
        localFilename = localPdfUrl?.lastPathComponent
        pdfLabel.text = localFilename
        print("Found file \(localFilename!) at \(localPdfUrl!)")
    }
}
