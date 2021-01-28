//
//  ToDo.swift
//  ToDoList
//
//  Created by Admin1 on 9/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import Foundation

struct  ToDo: Codable {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveUrl = DocumentsDirectory.appendingPathComponent("todo_list").appendingPathExtension(".plist")
    
    static let dueDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .short
      return formatter
    
    }()
    
    static func loadTodos() -> [ToDo]?{
        guard let codedToDos = try? Data.init(contentsOf: ArchiveUrl) else { return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from:codedToDos )
    }
    
    static func saveTodos(_ todos: [ToDo]){
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ArchiveUrl, options: .noFileProtection)
    }
    
    static func loadSampleTodos() -> [ToDo]{
        let todo1 = ToDo(title: "ToDo 1", isComplete: false, dueDate: Date(), notes: "Note")
        let todo2 = ToDo(title: "Todo 2", isComplete: false, dueDate: Date(), notes: "Note")
        let todo3 = ToDo(title: "Todo 3", isComplete: false, dueDate: Date(), notes: "Note")
        
        return [todo1, todo2, todo3]
    
    }
    
}
