import UIKit

class ColorSchemeController: UITableViewController {
    var color: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0...2:
            return 3
        case 3:
            return 5
        case 4:
            return 2
        default:
            assert(false)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
        let imageView = cell.viewWithTag(1)! as! UIImageView
        let label = cell.viewWithTag(2)! as! UILabel
        
        func setColor(color: UIColor) {
            imageView.backgroundColor = color
            label.text = color.hexDescription()
        }
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                setColor(self.color)
            case 1:
                setColor(self.color.rotateHueByDegrees(120))
            case 2:
                setColor(self.color.rotateHueByDegrees(-120))
            default:
                assert(false)
            }
        case 1:
            switch indexPath.row {
            case 0:
                setColor(self.color)
            case 1:
                setColor(self.color.rotateHueByDegrees(150))
            case 2:
                setColor(self.color.rotateHueByDegrees(-150))
            default:
                assert(false)
            }
        case 2:
            switch indexPath.row {
            case 0:
                setColor(self.color)
            case 1:
                setColor(self.color.rotateHueByDegrees(30))
            case 2:
                setColor(self.color.rotateHueByDegrees(-30))
            default:
                assert(false)
            }
        case 3:
            switch indexPath.row {
            case 0:
                setColor(self.color)
            case 1:
                var s: CGFloat = 0
                self.color.getHue(nil, saturation: &s, brightness: nil, alpha: nil)
                if s <= 0.1 {
                    setColor(self.color.incrementSaturationBy(0.1))
                } else {
                    setColor(self.color.incrementSaturationBy(-0.1))
                }
            case 2:
                var s: CGFloat = 0
                self.color.getHue(nil, saturation: &s, brightness: nil, alpha: nil)
                if s >= 0.9 {
                    setColor(self.color.incrementSaturationBy(-0.2))
                } else {
                    setColor(self.color.incrementSaturationBy(0.2))
                }
            case 3:
                var v: CGFloat = 0
                self.color.getHue(nil, saturation: nil, brightness: &v, alpha: nil)
                if v <= 0.1 {
                    setColor(self.color.incrementValueBy(0.1))
                } else {
                    setColor(self.color.incrementValueBy(-0.1))
                }
            case 4:
                var v: CGFloat = 0
                self.color.getHue(nil, saturation: nil, brightness: &v, alpha: nil)
                if v >= 0.9 {
                    setColor(self.color.incrementValueBy(-0.2))
                } else {
                    setColor(self.color.incrementValueBy(0.2))
                }
            default:
                assert(false)
            }
        case 4:
            switch indexPath.row {
            case 0:
                setColor(self.color)
            case 1:
                setColor(self.color.rotateHueByDegrees(180))
            default:
                assert(false)
            }
        default:
            assert(false)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Triadic"
        case 1:
            return "Split Complements"
        case 2:
            return "Analogous"
        case 3:
            return "Monochromatic"
        case 4:
            return "Complements"
        default:
            assert(false)
        }
    }
}

extension UIColor {
    public func rotateHueByDegrees(degrees: Int) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var v: CGFloat = 0
        
        self.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        
        h = CGFloat(fmod(Double(h) + Double(degrees) / 360.0, 1.0))
        return UIColor(hue: h, saturation: s, brightness: v, alpha: 1.0)
    }
    
    public func incrementSaturationBy(n: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var v: CGFloat = 0
        
        self.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        
        s += n
        return UIColor(hue: h, saturation: s, brightness: v, alpha: 1.0)
    }
    
    public func incrementValueBy(n: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var v: CGFloat = 0
        
        self.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        
        v += n
        return UIColor(hue: h, saturation: s, brightness: v, alpha: 1.0)
    }
}