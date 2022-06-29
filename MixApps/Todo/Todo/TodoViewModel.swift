//
//  TodoViewModel.swift
//  MixApps
//
//  Created by Aliia Saidillaeva  on 29/6/22.
//

import Foundation

protocol ITodoViewModel {
    func update(index: Int) -> Todo
    func changeOrder(sourceIndex: Int, destinationIndex: Int)
    func remove(at index: Int)
    func updateDefaultsList()
    func save(todo: Todo)
    func updateDataByTitle(title: String)
    var data: [Todo] { get }
    var isFiltering: Bool { set get }
    
}

class TodoViewModel: ITodoViewModel {
    
    var isFiltering: Bool = false
    
    var data: [Todo] {
        isFiltering ? filteredTodo : defaults.data
    }

    var defaults: TodoDefaults = .init()
    
    private var filteredTodo: [Todo] = []

    func update(index: Int) -> Todo {
        let item = data[index]
        item.isDone.toggle()
        defaults.update(todo: item)
        return item
    }
    
    func save(todo: Todo) {
        defaults.save(todo: todo)
        updateDefaultsList()
    }
    
    func updateDataByTitle(title: String) {
        filteredTodo = defaults.data.filter({ (todo: Todo) -> Bool in
            return  todo.title.lowercased().contains(title)})
    }
    
    func updateDefaultsList() {
        defaults.updateList()
    }
    
    func changeOrder(sourceIndex: Int, destinationIndex: Int) {
        let item = defaults.remove(index: sourceIndex)
        defaults.insert(todo: item, index: destinationIndex)
    }
    
    func remove(at index: Int) {
        let todo: Todo = data[index]
        defaults.remove(todo: todo)
        
        if let index = filteredTodo.firstIndex(of: todo) {
            filteredTodo.remove(at: index)
        }
    }
    
    
        
}
