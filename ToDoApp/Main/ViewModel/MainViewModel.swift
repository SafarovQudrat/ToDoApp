//
//  MainViewModel.swift
//  ToDoApp
//
//  Created by Qudrat on 28/01/25.
//

import UIKit

class MainViewModel {
    
    func getTasks() {
        let isDataFetched = UserDefaults.standard.bool(forKey: "isDataFetched")
        if isDataFetched {return  }
        
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received.")
                return
            }
            do {
                let todos = try JSONDecoder().decode(TodoResponse.self, from: data)
                DispatchQueue.main.async {
                    for i in 0..<todos.todos.count {
                        CoreDataManager.shared.createTask(TaskItem(id: todos.todos[i].id, title: "ToDo", todo: todos.todos[i].todo, creationDate: Date(), completed: todos.todos[i].completed))
                    }
                    UserDefaults.standard.set(true, forKey: "isDataFetched")
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    
    func fetchTasks() -> [TaskItem] {
        let tasks = CoreDataManager.shared.fetchTasks()
        UserDefaults.standard.set(tasks.last?.id, forKey: "lastID")
        return tasks
    }
    
    func uncheckTasks(_ indexPath: IndexPath)-> [TaskItem] {
        CoreDataManager.shared.updateTask(fetchTasks()[indexPath.row].id, !fetchTasks()[indexPath.row].completed, fetchTasks()[indexPath.row].creationDate, fetchTasks()[indexPath.row].title, fetchTasks()[indexPath.row].todo)
        
        
        return fetchTasks()
    }
    
    
}
