import Foundation
import CoreData


class ColorNamePair: NSManagedObject {
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext, color: Int32, colorName: String) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.colorValue = NSNumber(int: color)
        self.colorName = colorName
    }
}
