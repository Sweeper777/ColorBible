import UIKit
import CoreData

class ColorDetailsController: UITableViewController {

    var color: UIColor!
    var colorTuple: (color: UIColor, r: Float, g: Float, b: Float, h: Float, s: Float, v: Float)!
    @IBOutlet var colorPreview: UIImageView!
    @IBOutlet var rLabel: UILabel!
    @IBOutlet var gLabel: UILabel!
    @IBOutlet var bLabel: UILabel!
    @IBOutlet var hLabel: UILabel!
    @IBOutlet var sLabel: UILabel!
    @IBOutlet var vLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = color.hexDescription()
        colorTuple = UIColor.hexStringToColor(title!)
        colorPreview.backgroundColor = color
        
        rLabel.text = "\(Int(colorTuple.r * 255.0)) (\(colorTuple.r))"
        gLabel.text = "\(Int(colorTuple.g * 255.0)) (\(colorTuple.g))"
        bLabel.text = "\(Int(colorTuple.b * 255.0)) (\(colorTuple.b))"
        
        hLabel.text = "\(colorTuple.h)"
        sLabel.text = "\(colorTuple.s)"
        vLabel.text = "\(colorTuple.v)"
        
        ToastManager.shared.queueEnabled = false
        ToastManager.shared.tapToDismissEnabled = true
    }

    @IBAction func addFavouriteClick(sender: UIBarButtonItem) {
        let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        
        if dataContext != nil {
            let entity = NSEntityDescription.entityForName("Favourites", inManagedObjectContext: dataContext)
            let request = NSFetchRequest()
            request.entity = entity
            let favourites = try? dataContext.executeFetchRequest(request) as! [Favourites]
            
            for item in favourites! {
                if item.colorValue == self.color.intValue() {
                    self.view.makeToast("Your favourites already contains this color!", duration: 3.0, position: .Center, title: nil, image: UIImage(named: "cross"), style: nil, completion: nil)
                    return
                }
            }
            
            _ = Favourites(entity: entity!, insertIntoManagedObjectContext: dataContext, color: Int32(self.color.intValue()))
            
            if dataContext.saveData() {
                //self.view.makeToast(String(format: "The color %@ has been added to your favourites.", self.color.hexDescription()), duration: 3.0, position: .Center)
                self.view.makeToast(String(format: "The color %@ has been added to your favourites.", self.color.hexDescription()), duration: 3.0, position: .Center, title: nil, image: UIImage(named: "tick"), style: nil, completion: nil)
            } else {
                self.view.makeToast(String(format: "An error occurred while adding the color to your favourites.", self.color.intValue()))
            }
        }

    }
    
    @IBAction func doneClicked(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension NSManagedObjectContext {
    func saveData() -> Bool {
        do {
            try self.save()
            return true
        } catch let error as NSError {
            print(error)
            return false;
        }
    }
}