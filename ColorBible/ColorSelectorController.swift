import UIKit

class ColorSelectorController: UITableViewController {
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
}

extension UIColor {
    public static func hexStringToColor(hexString: String) -> (color: UIColor, r: Float, g: Float, b: Float, h: Float, s: Float, v: Float)? {
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if cString.characters.count < 6 {return nil}
        if cString.hasPrefix("0X") || cString.hasPrefix("0x") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
        if cString.hasPrefix("#") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))}
        if cString.characters.count != 6 {return nil}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substringWithRange(range)
        range.location = 2
        let gString = (cString as NSString).substringWithRange(range)
        range.location = 4
        let bString = (cString as NSString).substringWithRange(range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        NSScanner.init(string: rString).scanHexInt(&r)
        NSScanner.init(string: gString).scanHexInt(&g)
        NSScanner.init(string: bString).scanHexInt(&b)
        
        if (rString != "00" && r == 0) || (gString != "00" && g == 0) || (bString != "00" && b == 0) {
            return nil
        }
        
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var v: CGFloat = 0
        var a: CGFloat = 0
        let color = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        color.getHue(&h, saturation: &s, brightness: &v, alpha: &a)
        
        return (color, Float(r) / 255.0, Float(g) / 255.0, Float(b) / 255.0, Float(h), Float(s), Float(v))
    }
    
    public func hexDescription() -> String {
        var rF: CGFloat = 0,
        gF: CGFloat = 0,
        bF: CGFloat = 0,
        aF: CGFloat = 0
        self.getRed(&rF, green: &gF, blue: &bF, alpha: &aF)
        let r = Int(rF * 255.0)
        let g = Int(gF * 255.0)
        let b = Int(bF * 255.0)
        
        return "#" + String(format: "%02x%02x%02x", r, g, b)
    }
}
