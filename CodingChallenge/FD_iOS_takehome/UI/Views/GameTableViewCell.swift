import UIKit
import Firebase
import FirebaseStorage

class GameTableViewCell: UITableViewCell {
        
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamScoreLabel: UILabel!
    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var awayTeamColor: UILabel!
    @IBOutlet weak var homeTeamColor: UILabel!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    
    
    
    var starButtonStatus = UserDefaults.standard.bool(forKey: "starButtonStatus")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Style game cells
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.borderWidth = CGFloat(10)
        self.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        
        UserDefaults.standard.register(defaults: ["starButtonStatus" : true])
        // Get star button state
        DispatchQueue.main.async(execute: {
            UserDefaults.standard.synchronize()
            self.starButton.isHidden = UserDefaults.standard.bool(forKey: "starButtonStatus")
        })
//        if starButtonStatus != nil {
//            // do nothing
//            starButton.isHidden = true
//        } else {
//            starButton.isHidden = true
//        }

        NotificationCenter.default.addObserver(self, selector: #selector(refreshLbl), name: NSNotification.Name(rawValue: "refresh"), object: nil)

    }
    
    // TO DO: fix star button toggle when game is favorited on PlayersViewController
    
    @objc func refreshLbl() -> Void  {
        DispatchQueue.main.async(execute: {
            UserDefaults.standard.synchronize()
            self.starButton.isHidden = UserDefaults.standard.bool(forKey: "starButtonStatus")

        })        
    }
    
}

// Use hex codes for team colors 
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
