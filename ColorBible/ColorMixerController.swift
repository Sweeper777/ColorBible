import UIKit

class ColorMixerController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectColorFor: Int!
    var colorSelected: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ToastManager.shared.queueEnabled = false
        ToastManager.shared.tapToDismissEnabled = true
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
            return NSLocalizedString("First Color", comment: "")
        case 1:
            return NSLocalizedString("Second Color", comment: "")
        case 2:
            return NSLocalizedString("Transparency", comment: "")
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("colorCell")!
                let image = cell.viewWithTag(1) as! UIImageView
                let label = cell.viewWithTag(2) as! UILabel
                image.backgroundColor = nil
                label.text = NSLocalizedString("Not Selected", comment: "")
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
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 || indexPath.section == 1 {
            if indexPath.row == 1 {
                func showFav(action: UIAlertAction) {
                    performSegueWithIdentifier("showFavouritesSelector", sender: self)
                }
                
                func showSelector(action: UIAlertAction) {
                    performSegueWithIdentifier("showColorSelector", sender: self)
                }
                
                selectColorFor = indexPath.section
                let alert = UIAlertController(title: NSLocalizedString("Select a color from", comment: ""), message: nil, preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Favourites", comment: ""), style: .Default, handler: showFav))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Color Selector", comment: ""), style: .Default, handler: showSelector))
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .Default, handler: {
                    (action) -> Void in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                        imagePicker.sourceType = .PhotoLibrary
                        self.presentViewController(imagePicker, animated: true, completion: nil)
                    } else {
                        self.view.makeToast(NSLocalizedString("Photo Library is not available!", comment: ""), duration: 3.0, position: .Center, title: nil, image: UIImage(named: "cross"), style: nil, completion: nil)
                    }
                }))
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .Default, handler: {
                    (action) -> Void in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                        imagePicker.sourceType = .Camera
                        self.presentViewController(imagePicker, animated: true, completion: nil)
                    } else {
                        self.view.makeToast(NSLocalizedString("Camera is not available!", comment: ""), duration: 3.0, position: .Center, title: nil, image: UIImage(named: "cross"), style: nil, completion: nil)
                    }
                }))
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
                alert.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)?.textLabel
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        loadSelectedColor()
    }
    
    @IBAction func unwindWithoutSelection(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func resetAlpha(sender: UIButton) {
        let slider = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(3)! as! UISlider
        slider.value = 0.5
    }
    
    @IBAction func mixClick(sender: UIBarButtonItem) {
        let color1 = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(1)! as! UIImageView).backgroundColor
        let color2 = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(2)! as! UIImageView).backgroundColor
        if color1 == nil || color2 == nil {
            self.view.makeToast(NSLocalizedString("Please select 2 colors before mixing", comment: ""), duration: 3.0, position: .Center, title: nil, image: UIImage(named: "cross"), style: nil, completion: nil)
        } else {
            performSegueWithIdentifier("showResult", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ColorPasserController {
            let color1 = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(1)! as! UIImageView).backgroundColor!
            let color2 = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(2)! as! UIImageView).backgroundColor!
            let slider = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(3)! as! UISlider
            let result = color1.mixWith(color2, myAlpha: CGFloat(slider.value))
            vc.color = result
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        colorSelected = image.getPixelColor(CGPointMake(image.size.width / 2, image.size.height / 2))
        loadSelectedColor()
    }
    
    func loadSelectedColor() {
        let label = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: selectColorFor))!.viewWithTag(2)! as! UILabel
        let image = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: selectColorFor))!.viewWithTag(1)!
        
        image.backgroundColor = colorSelected
        label.text = colorSelected.properDescription()
        
        let sliderImage = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(selectColorFor + 1)! as! UIImageView
        let slider = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.viewWithTag(3)! as! UISlider
        if selectColorFor == 0 {
            slider.minimumTrackTintColor = colorSelected
        } else {
            slider.maximumTrackTintColor = colorSelected
        }
        sliderImage.backgroundColor = colorSelected
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
