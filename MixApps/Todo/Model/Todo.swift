//
//  Todo.swift
//  MixApps
//
//  Created by Aliia Saidillaeva  on 25/6/22.
//

import Foundation

class Todo: Codable {
    var title: String
    var desc: String
    var isDone: Bool

    init() {
        self.title = ""
        self.desc = ""
        self.isDone = false
    }
    
    init(_ title: String,_ desc: String, _ isDone: Bool) {
        self.title = title
        self.desc = desc
        self.isDone = isDone
    }
}
extension Todo: Equatable {
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        lhs.title == rhs.title  &&
        lhs.desc == rhs.desc &&
        lhs.isDone == rhs.isDone
    }
}
