import Foundation
import CoreData


class ColorNamePair: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext, colorValue: Int32, colorName: String) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.colorValue = NSNumber(int: colorValue)
        self.colorName = colorName
    }

}
