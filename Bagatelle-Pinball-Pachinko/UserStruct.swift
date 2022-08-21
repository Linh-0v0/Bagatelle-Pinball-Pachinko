//
//  UserStruct.swift
//  Bagatelle-Pinball-Pachinko
//
//  Created by Vu Bui Khanh Linh on 18/08/2022.
//

import Foundation

struct Defaults {
    
    static let (nameKey, scoreKey, ballKey) = ("username", "score", "ball")
    static let userSessionKey = "CurrentPlayerData"
    private static let userDefault = UserDefaults.standard
    static let leaderboardData = UserDefaults.standard
    static let leaderboardKey = "LeaderboardData"
    
    /**
     Nó được sử dụng để lấy ra và gán giá trị người dùng vào UserDefaults
     */
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
    
    /**
     - Lưu chi tiết người dùng
     - Inputs - name `String` & address `String`
     */
    static func save(_ username: String, score: String, ball: String){
        userDefault.set([nameKey: username, scoreKey: score, ballKey: ball],
                        forKey: userSessionKey)
    }
    
    static func saveToLeaderboard(_ username: String, score: String, ball: String) {
        leaderboardData.set([nameKey: username, scoreKey: score, ballKey: ball], forKey: username)
    }
    
    /**
     - Tìm nạp các giá trị thông qua Model `UserDetails`
     - Output - `UserDetails` model
     */
    static func getNameScoreBall() -> UserDetails {
        return UserDetails((userDefault.value(forKey: userSessionKey) as? [String: String]) ?? [:])
    }
    
    static func getUserLeaderboard(username: String) -> UserDetails {
        return UserDetails((leaderboardData.value(forKey: username) as? [String: String]) ?? [:])
    }
    
    static func getLeaderboardList() -> [String: [Any]] {
        var allUsersArr: [String:[Any]] = [:]
        
        for data in leaderboardData.dictionaryRepresentation() {
            if (data.value is NSDictionary) && (data.key != userSessionKey){
                allUsersArr[data.key] = [data.value]
            }
        }
        return allUsersArr
    }
    
    
    /**
     - Xoá chi tiết người dùng trong UserDefault qua key "com.save.usersession"
     */
    static func clearUserSessionData(username: String){
        userDefault.removeObject(forKey: userSessionKey)
    }
    
    static func clearUserData(username: String){
        userDefault.removeObject(forKey: username)
        leaderboardData.removeObject(forKey: username)
    }
    
}
