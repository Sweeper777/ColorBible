import UIKit
import CoreData

class NamedColorsController: UITableViewController {
    var colorNamePairs: [ColorNamePair] = []
    let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var colorToPass: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButtonItem = self.editButtonItem()
        barButtonItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = barButtonItem
        tableView.rowHeight = 44
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if dataContext != nil {
            let entity = NSEntityDescription.entityForName("ColorNamePair", inManagedObjectContext: dataContext)
            let request = NSFetchRequest()
            request.entity = entity
            let cnPairs = try? dataContext.executeFetchRequest(request)
            if cnPairs != nil {
                self.colorNamePairs.removeAll()
                for item in cnPairs! {
                    self.colorNamePairs.append(item as! ColorNamePair)
                }
                tableView.reloadData()
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorNamePairs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1")
        
        let pair = colorNamePairs[indexPath.row]
        let color = UIColor.hexColor(pair.colorValue!.intValue)
        cell?.imageView?.backgroundColor = color
        cell?.imageView?.image = UIImage(named: "frame")
        cell?.textLabel?.text = color.properDescription()
        cell?.detailTextLabel?.text = color.hexDescription()
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dataContext.deleteObject(colorNamePairs[indexPath.row])
            dataContext.saveData()
            colorNamePairs.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        colorToPass = UIColor.hexColor(colorNamePairs[indexPath.row].colorValue!.intValue)
        performSegueWithIdentifier("nameToDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ColorPasserController {
            vc.color = colorToPass
        }
    }
}
