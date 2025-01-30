
import Foundation
import CoreData


@objc(ItemDM)
public class ItemDM: NSManagedObject {

}

extension ItemDM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemDM> {
        return NSFetchRequest<ItemDM>(entityName: "ItemDM")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var todo: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var completed: Bool

}

extension ItemDM : Identifiable {

}
