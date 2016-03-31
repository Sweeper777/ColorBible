import Foundation
import CoreData


class Favourites: NSManagedObject {
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext, color: Int32) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.colorValue = NSNumber(int: color)
    }
}
