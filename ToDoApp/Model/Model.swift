import UIKit

struct TaskItem:Codable {
    let id: Int
    let title: String
    let todo: String
    let creationDate: Date
    var completed: Bool
    
}


struct TodoResponse: Codable {
    let todos: [Todo]
}

struct Todo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
