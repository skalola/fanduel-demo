import UIKit
import Firebase
import FirebaseStorage

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerStatLineLabel: UILabel!
    @IBOutlet weak var nerdTitleLabel: UILabel!
    @IBOutlet weak var nerdValueLabel: UILabel!
    @IBOutlet weak var playerTeamLogo: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Style game cells
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.borderWidth = CGFloat(10)
        self.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        
        // Hide player stats labels until there are stats to show
        playerStatLineLabel.isHidden = true
        playerNameLabel.isHidden = true
        nerdTitleLabel.isHidden = true
        nerdValueLabel.isHidden = true
        
    }

}
