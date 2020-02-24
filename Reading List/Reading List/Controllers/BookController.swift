//
//  BookController.swift
//  Reading List
//
//  Created by Karen Rodriguez on 2/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class BookController: Codable {
    var books: [Book] = []
    
    var readingListURL: URL? {
        get {
//            guard FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: .none, create: false) is String else {return nil}
            
            let fileManager = FileManager.default
            guard let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
            let plistFile = documentsDir.appendingPathComponent("ReadingList.plist")
            
            return plistFile
        } }
    
    // PropertyListEncoder
    
    func saveToPersistentStore() {
        
        guard let fileUrl = readingListURL else { return }
        let propertyList = PropertyListEncoder()
        
        do {
            let booksData = try propertyList.encode(books)
            try booksData.write(to: fileUrl)
        } catch {
            print("Error encoding Book: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        do {
            guard let fileUrl = readingListURL else { return }
            let data = try Data(contentsOf: fileUrl)
            let plistDecoder = PropertyListDecoder()
            let decodedBooks = try plistDecoder.decode([Book].self , from: data)
            books = decodedBooks
            
        } catch {
            print("Failed to load decoded books array: \(error)")
        }
    }
    
    // CRUD Methods
    
    func create(title: String, reasonToRead: String) {
        books.append(Book(title: title, reasonToRead: reasonToRead))
        saveToPersistentStore()
    }
    
}
