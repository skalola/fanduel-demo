import UIKit
import Foundation
import Firebase
import FirebaseStorage

class PlayersViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var playersTableView: UITableView!
    
    var games: [Games] = []
    var player_stats: [Player_Stats] = []
    var gamesRef = Database.database().reference().child("games")
    var playersRef = Database.database().reference().child("players")
    var player_statsRef = Database.database().reference().child("player_stats")
    var teamsRef = Database.database().reference().child("teams")

}

extension PlayersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title and navigation bar and title color
        title = "Away @ Home"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Add star button
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "star-unselected"), for: .normal)
        btn1.setImage(UIImage(named: "star-selected"), for: .selected)
        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn1.addTarget(self, action: #selector(self.starAction(sender:)), for: .touchUpInside)
        let starButton = UIBarButtonItem()
        starButton.customView = btn1
        self.navigationItem.rightBarButtonItem  = starButton
        
        // add back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        // Table view delegate
        playersTableView.delegate = self
        playersTableView.dataSource = self
        
        playersTableView.tableFooterView = UIView()

        playersTableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerTableViewCell")

        // TO FIX: Populate table with game ids from dictionary
        player_statsRef.observe(.childAdded, with: { snapshot in
            guard let playerStatsDict = snapshot.value as? [String: Any] else { return print("couldn't cast") }
//            let stat = Player_Stats(dictionary: playerStatsDict)
//            self.player_stats.append(stat)
//            self.player_statsRef.keepSynced(true)
//            print(playerStatsDict)
        })
      

        // Temporary Solution to populate table
        player_statsRef.queryOrdered(byChild: "game_id").queryEqual(toValue: UserDefaults.standard.value(forKey: "game_id")).observeSingleEvent(of: .value, with: { snapshot in
            let stats = CFGetRetainCount(snapshot as CFTypeRef)
            UserDefaults.standard.set(stats - 1 , forKey: "playerRows")
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        // Remove Firebase listeners
        UserDefaults.standard.removeObject(forKey: "game_id")
        UserDefaults.standard.removeObject(forKey: "playerRows")
        UserDefaults.standard.synchronize()
        
        // Remove Firebase listeners
//        teamsRef.removeAllObservers()
//        playersRef.removeAllObservers()
//        player_statsRef.removeAllObservers()
//        gamesRef.removeAllObservers()
    }
}


//// MARK: - UITableViewDataSource
extension PlayersViewController: UITableViewDataSource {
    
    @objc func starAction(sender: UIButton) -> Void {
        print("star")
        if sender.isSelected == true {
            sender.isSelected = false
            // Add unfavorite logic
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)

            // Star button logic
            UserDefaults.standard.set(true, forKey: "starButtonStatus")
            print("not Selected",  UserDefaults.standard.bool(forKey: "starButtonStatus"))
        } else {
            sender.isSelected = true
            // Add favorite logic
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
            UserDefaults.standard.set(false, forKey: "starButtonStatus")
            print("Selected",  UserDefaults.standard.bool(forKey: "starButtonStatus"))
        }
    }
    
    @objc func backAction(sender: UIBarButtonItem) -> Void {
        let firstView = GamesViewController()
        let navBar = UINavigationController(rootViewController: firstView)
        self.present(navBar,animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let playerRows = Int("\(UserDefaults.standard.value(forKey: "playerRows")!)")!
        
        return playerRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Setup table cells
        let cell = playersTableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath as IndexPath) as! PlayerTableViewCell

        // Select game and get away team and home team for title
        gamesRef.queryOrdered(byChild: "id").queryEqual(toValue: UserDefaults.standard.value(forKey: "game_id")).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let currentGameData = snap.value as? [String : AnyObject] ?? [:]
                let awayTeamId = currentGameData["away_team_id"]
                let homeTeamId = currentGameData["home_team_id"]

                self.teamsRef.queryOrdered(byChild: "id").queryEqual(toValue: awayTeamId).observeSingleEvent(of: .value, with: { snapshot in
                    for child in snapshot.children{
                        let snap = child as! DataSnapshot
                        let currentTeamData = snap.value as? [String : AnyObject] ?? [:]
                        let awayTeamName = currentTeamData["name"]
                        // Add away team name to nav bar title
                        self.title = "\(awayTeamName!) @"
                    }
                })
                self.teamsRef.queryOrdered(byChild: "id").queryEqual(toValue: homeTeamId).observeSingleEvent(of: .value, with: { snapshot in
                    for child in snapshot.children{
                        let snap = child as! DataSnapshot
                        let currentTeamData = snap.value as? [String : AnyObject] ?? [:]
                        let homeTeamName = currentTeamData["name"]
//                       print(currentTeamData)
                        // Append nav bar title to add home team name
                        self.title?.append(" \(homeTeamName!)")
                    }
                })
   
            }
        })
   
        // Get player stats data
        player_statsRef.queryOrdered(byChild: "game_id").queryEqual(toValue: UserDefaults.standard.value(forKey: "game_id")).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let playerStats = snap.value as? [String : AnyObject] ?? [:]
                let playerPoints = playerStats["points"]
                let playerAssists = playerStats["assists"]
                let playerRebounds = playerStats["rebounds"]
                let playerNerd = playerStats["nerd"]
                let playerStatsGameId = playerStats["game_id"]
                let playerStatsTeamId = playerStats["team_id"]
                let playerStatsPlayerId = playerStats["player_id"]
                let playerName = playerStats["name"]
                // Unhide player stats labels
                cell.playerStatLineLabel.isHidden = false
                cell.playerNameLabel.isHidden = false
                cell.nerdTitleLabel.isHidden = false
                cell.nerdValueLabel.isHidden = false

                // Get data for player stats labels
                if playerNerd != nil {
                    cell.playerStatLineLabel?.text = "\(playerPoints!) Pts, \(playerAssists!) Ast, \(playerRebounds!) Rebs"
                    cell.nerdValueLabel?.text = "\(playerNerd!)"
                }
                
                // Get player's name
                self.playersRef.queryOrdered(byChild: "id").queryEqual(toValue: playerStatsPlayerId).observeSingleEvent(of: .value, with: { snapshot in
                    for child in snapshot.children{
                        let snap = child as! DataSnapshot
                        let currentPlayerData = snap.value as? [String : AnyObject] ?? [:]
                        let playerName = currentPlayerData["name"]
                        let playerId = currentPlayerData["id"]

//                        print(currentPlayerData)
     
                        // Get team abbrev to append player name label
                        self.teamsRef.queryOrdered(byChild: "id").queryEqual(toValue: playerStatsTeamId).observeSingleEvent(of: .value, with: { snapshot in
                            for child in snapshot.children{
                                let snap = child as! DataSnapshot
                                let currentTeamData = snap.value as? [String : AnyObject] ?? [:]
                                let teamAbbrev = currentTeamData["abbrev"]
//                                print(playerName!)
                                cell.playerNameLabel?.text = "\(playerName!) - \(teamAbbrev!)"
                                cell.playerTeamLogo.image = UIImage(named: "Player-Images/\(playerId!)")
                                
                            }
                        })

                    }

                })

            }

        })
        return cell

    }

}

