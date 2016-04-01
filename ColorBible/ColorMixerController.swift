import UIKit

class ColorMixerController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "First Color"
        case 1:
            return "Second Color"
        case 2:
            return "Amount of the Two Colors During Mixing"
        default:
            assert(false)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("colorCell")!
                let image = cell.viewWithTag(1) as! UIImageView
                let label = cell.viewWithTag(2) as! UILabel
                image.backgroundColor = nil
                label.text = "Not Selected"
                return cell
            } else {
                return tableView.dequeueReusableCellWithIdentifier("selectButton")!
            }
        } else {
            return tableView.dequeueReusableCellWithIdentifier("slider")!
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 108
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
    }
}
