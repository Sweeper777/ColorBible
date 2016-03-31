import UIKit

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
    }

    @IBAction func doneClicked(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        return cell
    }*/

}
