import UIKit


class RandomColorsViewController: UICollectionViewController {

    var colors: [Int32] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...100 {
            colors.append(Int32(arc4random_uniform(16777216)))
        }
        collectionView?.registerClass(ColorCell.self, forCellWithReuseIdentifier: "cell1")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView?.setCollectionViewLayout(flowLayout, animated: false, completion: nil)
        let currentFrame = collectionView!.frame
        let newFrame = CGRect(x: currentFrame.origin.x + 10, y: currentFrame.origin.y + 10, width: currentFrame.width - 20, height: currentFrame.height - 20)
        collectionView!.frame = newFrame
        view.backgroundColor = UIColor.whiteColor()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as! ColorCell
        cell.color = UIColor.hexColor(colors[indexPath.row])
        return cell
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        colors.removeAll()
        for _ in 1...100 {
            colors.append(Int32(arc4random_uniform(16777216)))
        }
        collectionView?.reloadData()
    }

}

extension UIColor {
    public static func hexColor(hex: Int32) -> UIColor {
        return UIColor.init(red: CGFloat((hex>>16)&0xFF) / 255.0, green: CGFloat((hex>>8)&0xFF) / 255.0, blue: CGFloat(hex&0xFF) / 255.0, alpha: 1.0)
    }
    
    public func intValue() -> Int {
        var hexString = self.hexDescription()
        hexString = hexString.substringFromIndex(hexString.startIndex.successor())
        return Int(hexString, radix: 16)!
    }
}