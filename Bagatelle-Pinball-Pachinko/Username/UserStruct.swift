/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Vu Bui Khanh Linh
  ID: 3864120
  Created date: 18/08/2022
  Last modified: 28/08/2022
  Acknowledgement:
    - UserDefaults Logic: https://viblo.asia/p/userdefaults-trong-swift-51-WAyK8OkN5xX 
*/

import Foundation

struct Defaults {
    // There are 2 different list of UserDefaults
    // Representing by these 2 different keys : userSessionKey, leaderboardKey
    static let (nameKey, scoreKey, ballKey) = ("username", "score", "ball")
    static let userSessionKey = "CurrentPlayerData"
    static let leaderboardKey = "LeaderboardData"
    private static let userDefault = UserDefaults.standard
    private static let leaderboardData = UserDefaults.standard
    
    /* Is used to save User to UserDefault following this "UserDetail Struct"*/
    struct UserDetails {
        let username: String
        let score: String
        let ball: String
        
        init(_ json: [String: String]) {
            self.username = json[nameKey] ?? ""
            self.score = json[scoreKey] ?? "0"
            self.ball = json[ballKey] ?? "0"
        }
    }
    
    /* Save User to UserDefault */
    static func save(_ username: String, score: String, ball: String){
        userDefault.set([nameKey: username, scoreKey: score, ballKey: ball],
                        forKey: userSessionKey)
    }
    
    static func saveToLeaderboard(_ username: String, score: String, ball: String) {
        leaderboardData.set([nameKey: username, scoreKey: score, ballKey: ball], forKey: username)
    }
    
    /* Get Value from UserDefaults */
    static func getNameScoreBall() -> UserDetails {
        return UserDetails((userDefault.value(forKey: userSessionKey) as? [String: String]) ?? [:])
    }
    
    static func getUserLeaderboard(username: String) -> UserDetails {
        return UserDetails((leaderboardData.value(forKey: username) as? [String: String]) ?? [:])
    }
    
    // Return Leaderboard List getting from "leaderboardData"
    static func getLeaderboardList() -> [String: [Any]] {
        var allUsersArr: [String:[Any]] = [:]
        
        for data in leaderboardData.dictionaryRepresentation() {
            if (data.value is NSDictionary) && (data.key != userSessionKey){
                allUsersArr[data.key] = [data.value]
            }
        }
        return allUsersArr
    }
    
    
    /* Delete UserDefault */
    // Remove the current signed-in player
    static func clearUserSessionData() {
        userDefault.removeObject(forKey: userSessionKey)
    }
    
    // Remove the specified user
    static func clearUserData(username: String){
        userDefault.removeObject(forKey: username)
    }
    
    // Remove all Users
    static func clearAllUsers() {
        for data in userDefault.dictionaryRepresentation() {
            userDefault.removeObject(forKey: data.key)
        }
    }
    
    // Remove all leaderboard data
    static func clearAllLeaderboard(){
        for data in leaderboardData.dictionaryRepresentation() {
            leaderboardData.removeObject(forKey: data.key)
        }
    }
}
