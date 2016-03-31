import UIKit

class ColorCell: UICollectionViewCell {
    let label = UILabel()
    var color: UIColor? {
        get {
            return backgroundColor
        }
        
        set {
            backgroundColor = newValue
            label.text = backgroundColor?.hexDescription()
            label.textColor = UIColor.hexColor(~Int32((backgroundColor?.intValue())!))
            label.frame = CGRect(x: 5, y: CGRectGetMidY(self.bounds), width: self.frame.width, height: self.frame.height)
            label.font = UIFont(name: "Helvetica", size: 10)
            label.sizeToFit()
            label.removeFromSuperview()
            self.addSubview(label)
            bringSubviewToFront(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
