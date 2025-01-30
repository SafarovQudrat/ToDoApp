import UIKit
import CoreData

public final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func createTask(_ task: TaskItem) {
        let newTask = ItemDM(context: context)
        newTask.id = Int16(task.id)
        newTask.title = task.title
        newTask.todo = task.todo
        newTask.completed = task.completed
        newTask.creationDate = task.creationDate
        
        do {
            try context.save()
        } catch {
            print("Core Data saqlashda xatolik: \(error.localizedDescription)")
        }
    }

    
    func fetchTasks() -> [TaskItem] {
        do {
            let result = try context.fetch(ItemDM.fetchRequest())
            let tasks = result.map { item in
                TaskItem(id: Int(item.id),
                         title: item.title ?? "",
                         todo: item.todo ?? "",
                         creationDate: item.creationDate ?? Date(),
                         completed: item.completed)
            }
            return tasks
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func updateTask(_ id: Int, _ completed: Bool, _ creationDate: Date, _ title: String, _ todo: String) {
        do {
            guard let tasks = try? context.fetch(ItemDM.fetchRequest()) as? [ItemDM],
                  let task = tasks.first(where: { $0.id == id }) else { return }
            
            task.completed = completed
            task.creationDate = creationDate
            task.title = title
            task.todo = todo
            
            try context.save() // ✅ Shu yerda saqlash kerak
        } catch {
            print(error.localizedDescription)
        }
    }

    
    func deleteAllTask() {
        
        do {
            let tasks = try? context.fetch(ItemDM.fetchRequest()) as? [ItemDM]
                    tasks?.forEach({context.delete($0)})
            
        }
        appDelegate.saveContext()
    }
    
    func deleteTask(item: TaskItem) {
        do {
            guard let tasks = try? context.fetch(ItemDM.fetchRequest()) as? [ItemDM],
                  let task = tasks.first(where: { $0.id == item.id }) else { return }
            context.delete(task)
            try context.save() 
        } catch {
            print(error.localizedDescription)
        }
    }

    
    
}
