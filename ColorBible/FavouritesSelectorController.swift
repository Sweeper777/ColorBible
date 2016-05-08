import UIKit
import CoreData

class FavouritesSelectorController: UITableViewController {
    var favourites: [Favourites] = []
    let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var colorToPass: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
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
        return false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        colorToPass = UIColor.hexColor(favourites[indexPath.row].colorValue!.intValue)
        
        performSegueWithIdentifier("backToMixer", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ColorMixerController {
            vc.colorSelected = self.colorToPass
        }
    }
}
