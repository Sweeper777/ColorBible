import UIKit
import CoreData

class FavouritesController: UITableViewController {

    var favourites: [Favourites] = []
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
            let entity = NSEntityDescription.entityForName("Favourites", inManagedObjectContext: dataContext)
            let request = NSFetchRequest()
            request.entity = entity
            let favourites = try? dataContext.executeFetchRequest(request)
            if favourites != nil {
                self.favourites.removeAll()
                for item in favourites! {
                    self.favourites.append(item as! Favourites)
                }
                tableView.reloadData()
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1")
        let imageView = cell!.viewWithTag(1)! as! UIImageView
        let label = cell!.viewWithTag(2)! as! UILabel
        
        let fav = favourites[indexPath.row]
        let favColor = UIColor.hexColor(fav.colorValue!.intValue)
        imageView.backgroundColor = favColor
        label.text = favColor.properDescription()
        
        return cell!
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dataContext.deleteObject(favourites[indexPath.row])
            dataContext.saveData()
            favourites.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        colorToPass = UIColor.hexColor(favourites[indexPath.row].colorValue!.intValue)
        performSegueWithIdentifier("favToDetails", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ColorPasserController {
            vc.color = colorToPass
        }
    }
}
