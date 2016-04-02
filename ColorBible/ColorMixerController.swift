import UIKit

class ColorMixerController: UITableViewController {
    var selectColorFor: Int!
    var colorSelected: UIColor!
    
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
            return "Transparency"
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
            return 139
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 || indexPath.section == 1 {
            if indexPath.row == 1 {
                selectColorFor = indexPath.section
            }
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        let label = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: selectColorFor))!.viewWithTag(2)! as! UILabel
        let image = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: selectColorFor))!.viewWithTag(1)!
        
        image.backgroundColor = colorSelected
        label.text = colorSelected.hexDescription()
        
        let sliderImage = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(selectColorFor + 1)! as! UIImageView
        let slider = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(3)! as! UISlider
        if selectColorFor == 0 {
            slider.minimumTrackTintColor = colorSelected
        } else {
            slider.maximumTrackTintColor = colorSelected
        }
        sliderImage.backgroundColor = colorSelected
    }
    
    @IBAction func resetAlpha(sender: UIButton) {
        let slider = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(3)! as! UISlider
        slider.value = 0.5
    }
}

extension UIColor {
    public func mixWith(color: UIColor, myAlpha: CGFloat) -> UIColor {
        let otherAlpha = 1 - myAlpha
        
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        
        getRed(&r1, green: &g1, blue: &b1, alpha: nil)
        
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        
        color.getRed(&r2, green: &g2, blue: &b2, alpha: nil)
        
        let newR = sqrt(r1 * r1 * myAlpha + r2 * r2 * otherAlpha)
        let newG = sqrt(g1 * g1 * myAlpha + g2 * g2 * otherAlpha)
        let newB = sqrt(b1 * b1 * myAlpha + b2 * b2 * otherAlpha)
        
        return UIColor(red: newR, green: newG, blue: newB, alpha: 1.0)
    }
}
