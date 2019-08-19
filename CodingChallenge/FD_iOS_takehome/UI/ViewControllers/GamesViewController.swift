import UIKit
import Foundation
import Firebase
import FirebaseStorage


final class GamesViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var gamesTableView: UITableView!
    
    var games: [Games] = []
    var gamesRef = Database.database().reference().child("games")
    var game_states: [Game_States] = []
    var game_statesRef = Database.database().reference().child("game_states")
    var teamsRef = Database.database().reference().child("teams")
    var handles: [DatabaseHandle] = []
    var keyArray:[String] = []
    var store = Storage.storage()
    var storeRef = Storage.storage().reference()
}

extension GamesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title and navigation bar and title color
        title = "Games"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        // Table view delegate
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        
        // Clear User defaults snippet
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()

        // set default rows
        gamesTableView.tableFooterView = UIView()
        self.gamesTableView.reloadData()

        gamesTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        
        // Populate table with game ids from Firebase
        gamesRef.observe(.childAdded, with: { snapshot in
            guard let gameDict = snapshot.value as? [String: Any] else { return print("couldn't cast") }
            let game = Games(dictionary: gameDict)
            self.games.append(game)
            self.gamesRef.keepSynced(true)
            self.gamesTableView.insertRows(at: [IndexPath(row: self.games.count - 1, section: 0)], with: .automatic)
        })
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        // Reload table data
        self.gamesTableView.reloadData()
    }
}


//// MARK: - UITableViewDataSource
extension GamesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Setup table cells
        let cell = gamesTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath as IndexPath) as! GameTableViewCell

        // Get away team data
        teamsRef.queryOrdered(byChild: "id").queryEqual(toValue: games[indexPath.row].away_team_id).observe(.value, with: { snapshot in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let awayTeam = snap.value as? [String : AnyObject] ?? [:]
                let awayTeamColor = awayTeam["color"] as! String
                cell.awayTeamLabel?.text = awayTeam["name"] as? String
                cell.awayTeamLogo?.image = UIImage(named: awayTeam["name"] as! String)
                cell.awayTeamColor?.backgroundColor = UIColor(hexString: "\(awayTeamColor)")
            }
        })

        // Get home team data
        teamsRef.queryOrdered(byChild: "id").queryEqual(toValue: games[indexPath.row].home_team_id).observe(.value, with: { snapshot in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let homeTeam = snap.value as? [String : AnyObject] ?? [:]
                let homeTeamColor = homeTeam["color"] as! String
                cell.homeTeamLabel?.text = homeTeam["name"] as? String
                cell.homeTeamLogo?.image = UIImage(named: homeTeam["name"] as! String)
                cell.homeTeamColor?.backgroundColor = UIColor(hexString: "\(homeTeamColor)")
            }
        })

        // Get game states data
        game_statesRef.queryOrdered(byChild: "game_id").queryEqual(toValue: games[indexPath.row].id).observe(.value, with: { snapshot in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let gameCenter = snap.value as? [String : AnyObject] ?? [:]
                let awayTeamScore = gameCenter["away_team_score"]
                let homeTeamScore = gameCenter["home_team_score"]
                let gameBroadcast = gameCenter["broadcast"] as! String
                let gameStartTime = gameCenter["game_start"] as? String
                let gameQuarter = gameCenter["quarter"]
                let gameTimeLeft = gameCenter["time_left_in_quarter"] as? String
                // Game status logic depending on IN PROGRESS, SCHEDULED, FINAL
                // Update cells for games IN PROGRESS
                if gameCenter["game_status"] as? String == "IN_PROGRESS" {
                    cell.awayTeamScoreLabel?.text = "\(awayTeamScore!)"
                    cell.homeTeamScoreLabel?.text = "\(homeTeamScore!)"
                    cell.gameStatusLabel?.text = "Q\(gameQuarter!) \(gameTimeLeft as! String)"
                    cell.gameStatusLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                }
                
                // Update cells for FINAL games
                if gameCenter["game_status"] as? String == "FINAL" {
                    cell.awayTeamScoreLabel?.text = "\(awayTeamScore!)"
                    cell.homeTeamScoreLabel?.text = "\(homeTeamScore!)"
                    cell.gameStatusLabel?.text = gameCenter["game_status"] as? String
                    
                    // Loop through each cell with FINAL game_status
                    for gameCenter in gameCenter {
                        // Convert scores to Int
                        let getAwayScore = Int("\(awayTeamScore!)")!
                        let getHomeScore = Int("\(homeTeamScore!)")!
                        
                        //Bold team name winner and remove bold from losing team's score label
                        if getAwayScore < getHomeScore {
                            cell.homeTeamLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
                            cell.awayTeamScoreLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
                        } else {
                            cell.awayTeamLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
                            cell.homeTeamScoreLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
                        }
                    }
                }
                
                // Update cells for SCHEDULED games
                if gameCenter["game_status"] as? String == "SCHEDULED" {
                    cell.gameStatusLabel?.text = "\(gameStartTime as! String) \n \(gameBroadcast) "
                    cell.awayTeamScoreLabel.isHidden = true
                    cell.homeTeamScoreLabel.isHidden = true
                }
            }
        })
    
        return cell

    }

    /* NAVIGATION */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var secondView = PlayersViewController()
        var navBar = UINavigationController(rootViewController: secondView)
        
        // Store game id of row selected to pass onto player stats view
        UserDefaults.standard.set(games[indexPath.row].id, forKey: "game_id")

        self.present(navBar,animated: true, completion: nil)
        
        // set default rows
        UserDefaults.standard.set(4, forKey: "playerRows")
        UserDefaults.standard.synchronize()

    }
}


