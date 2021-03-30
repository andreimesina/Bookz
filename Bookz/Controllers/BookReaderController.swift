//
//  BookReaderController.swift
//  Bookz
//
//  Created by Andrei Mesina on 26/05/2020.
//  Copyright © 2020 Andrei Mesina. All rights reserved.
//

import Foundation
import UIKit
import PDFKit

class BookReaderController: UIViewController {
    
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var addNoteButton: UIButton!
    
    private let notesManager = NotesManager()
    
    let pdfView = PDFView()
    let container = UIView()
    
    private var currentBook: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.subviews[0].bottomAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @IBAction func closeKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onAddNoteButtonClick(_: UIButton) {
        if (noteTextField.text != nil && noteTextField.text?.count ?? 0 > 0) {
            let note = Note(id: 1, bookId: currentBook?.id ?? 0, note: noteTextField.text!, page: 0)
            notesManager.addNote(note: note)
        }
    }
}

extension BookReaderController: BooksControllerDelegate {
    func displayPdf(pdfUrl: URL, book: Book) {
        currentBook = book
        let document = PDFDocument(url: pdfUrl)
        
        pdfView.autoresizesSubviews = true
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin]
        pdfView.displayDirection = .vertical

        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displaysPageBreaks = true
        pdfView.document = document
        
        print("!!! currentPage \(book.currentPage)")
        if let page = document?.page(at:book.currentPage) {
            print("!!! page \(page)")
            pdfView.go(to: page)
        }
    }
}
