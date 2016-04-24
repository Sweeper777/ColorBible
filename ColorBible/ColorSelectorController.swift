import UIKit
import CoreData

class ColorSelectorController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
        tableView.userInteractionEnabled = true
        hexField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        ToastManager.shared.queueEnabled = false
        ToastManager.shared.tapToDismissEnabled = true
    }
    
    @IBAction func tapped(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func colorDetailsClick(sender: UIButton) {
        performSegueWithIdentifier("selectorToDetails", sender: self)
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
    
    @IBAction func cameraTapped(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: NSLocalizedString("Get a Color From a Photo", comment: ""), message: NSLocalizedString("The color of the pixel at the center of the image will be taken.", comment: ""), preferredStyle: .ActionSheet)
        alert.popoverPresentationController?.barButtonItem = sender
        
        let imagePicker: UIImagePickerController? = UIImagePickerController()
        imagePicker!.delegate = self
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .Default, handler: {
            (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                imagePicker!.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker!, animated: true, completion: nil)
            } else {
                self.view.makeToast(NSLocalizedString("Photo Library is not available!", comment: ""), duration: 3.0, position: .Center, title: nil, image: UIImage(named: "cross"), style: nil, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .Default, handler: {
            (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                imagePicker!.sourceType = .Camera
                self.presentViewController(imagePicker!, animated: true, completion: nil)
            } else {
                self.view.makeToast(NSLocalizedString("Camera is not available!", comment: ""), duration: 3.0, position: .Center, title: nil, image: UIImage(named: "cross"), style: nil, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        
        alert.popoverPresentationController?.barButtonItem = sender
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        var rF: CGFloat = 0,
        gF: CGFloat = 0,
        bF: CGFloat = 0,
        aF: CGFloat = 0
        
        var hF: CGFloat = 0,
        sF: CGFloat = 0,
        vF: CGFloat = 0
        
        let color = image.getPixelColor(CGPointMake(image.size.width / 2, image.size.height / 2))
        color.getRed(&rF, green: &gF, blue: &bF, alpha: &aF)
        color.getHue(&hF, saturation: &sF, brightness: &vF, alpha: &aF)
        
        if colorModeSelector.selectedSegmentIndex == 0 {
            firstValue.value = Float(rF)
            secondValue.value = Float(gF)
            thirdValue.value = Float(bF)
        } else {
            firstValue.value = Float(hF)
            secondValue.value = Float(sF)
            thirdValue.value = Float(vF)
        }
        
        loadCurrentColor()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ColorPasserController {
            vc.color = preview.backgroundColor
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
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
    
    public func properDescription() -> String {
        let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        if dataContext != nil {
            let entity = NSEntityDescription.entityForName("ColorNamePair", inManagedObjectContext: dataContext)
            let request = NSFetchRequest()
            request.entity = entity
            let colorNamePairs = try? dataContext.executeFetchRequest(request)
            if let pairs = colorNamePairs {
                for item in pairs {
                    let pair = item as! ColorNamePair
                    if pair.colorValue == self.intValue() {
                        return pair.colorName!
                    }
                }
            }
        }
        return self.hexDescription()
    }
}
