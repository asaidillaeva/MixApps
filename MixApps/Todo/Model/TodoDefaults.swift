//
//  TodoDefaults.swift
//  MixApps
//
//  Created by Aliia Saidillaeva  on 25/6/22.
//
import Foundation
import UIKit

enum Key: String {
    case todoList
}

class TodoDefaults {
    
    static let shared = TodoDefaults()
    let defaults = UserDefaults.standard
    private var todoList: [Todo] = []
    
    private var filteredTodo: [Todo] = []
    
    var count: Int {
        todoList.count
    }
    
    var data: [Todo] {
        todoList
    }
    
    init() {
        updateList()
    }
    
    func insert(todo: Todo, index: Int){
        todoList.insert(todo, at: index)
        updateData()
    }
    
    @discardableResult
    func remove(index: Int) -> Todo {
        let removed = todoList.remove(at: index)
        updateData()
        return removed
    }
    
    @discardableResult
    func remove(todo: Todo) -> Todo {
        let index: Int = todoList.firstIndex(of: todo) ?? 0
        let removed = todoList.remove(at: index)
        updateData()
        return removed
    }
    
    func update(todo: Todo){
        let index: Int = todoList.firstIndex(of: todo) ?? 0
        todoList.remove(at: index)
        todoList.insert(todo, at: index)
        updateData()
    }
    
    func save(todo: Todo){
        todoList.append(todo)
        updateData()
    }
    
    func updateList() {
        if let data = defaults.object(forKey: Key.todoList.rawValue) as? Data{
            todoList = (try? JSONDecoder().decode([Todo].self, from: data)) ?? []
        }
    }
    
    private func updateData(){
        if let data = try? JSONEncoder().encode(todoList){
            print("Some data updated")
            defaults.set(data, forKey: Key.todoList.rawValue)
        }
    }
}
