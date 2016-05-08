import UIKit

class ColorSelectorDialogController: UITableViewController, UIGestureRecognizerDelegate {
    @IBOutlet var hexField: UITextField!
    @IBOutlet var preview: UIView!
    @IBOutlet var colorModeSelector: UISegmentedControl!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    
    @IBOutlet var firstValue: UISlider!
    @IBOutlet var secondValue: UISlider!
    @IBOutlet var thirdValue: UISlider!
    
    override func viewDidLoad() {
        loadCurrentColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func tapped(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func colorModeChanged(sender: UISegmentedControl) {
        view.endEditing(true)
        switch sender.selectedSegmentIndex {
        case 0:
            firstLabel.text = "R"
            secondLabel.text = "G"
            thirdLabel.text = "B"
        case 1:
            firstLabel.text = "H"
            secondLabel.text = "S"
            thirdLabel.text = "V"
        default:
            break
        }
        loadCurrentColor()
    }
    
    @IBAction func valuesChanged(sender: UISlider) {
        loadCurrentColor()
    }
    
    @IBAction func hexChanged(sender: UITextField) {
        if let colorTuple = UIColor.hexStringToColor(sender.text!) {
            preview.backgroundColor = colorTuple.color
            if colorModeSelector.selectedSegmentIndex == 0 {
                firstValue.value = colorTuple.r
                secondValue.value = colorTuple.g
                thirdValue.value = colorTuple.b
            } else {
                firstValue.value = colorTuple.h
                secondValue.value = colorTuple.s
                thirdValue.value = colorTuple.v
            }
        }
    }
    
    func loadCurrentColor() {
        var color: UIColor!
        
        if colorModeSelector.selectedSegmentIndex == 0 {
            color = UIColor(red: CGFloat(firstValue.value), green: CGFloat(secondValue.value), blue: CGFloat(thirdValue.value), alpha: 1.0)
            preview.backgroundColor = color
        } else {
            color = UIColor(hue: CGFloat(firstValue.value), saturation: CGFloat(secondValue.value), brightness: CGFloat(thirdValue.value), alpha: 1.0)
            preview.backgroundColor = color
        }
        
        hexField.text = color.hexDescription()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ColorMixerController {
            vc.colorSelected = preview.backgroundColor
        }
    }
}
