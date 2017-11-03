//
//  NetworkManager.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 08/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import Foundation
import UIKit

// MARK: NetworkManager
class NetworkManager {
    
    // MARK: Board Data
    class func updateBoardData(completionHandler: @escaping ([BoardData]) -> Void)  {
        
        var result: [[String: String]]?
        
        guard let url = URL(string: kUpdateBoardURL) else {
            print("Error: NetworkManager - updateBoardData => url doesn't exist")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            result = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]]
            
            
            if let datas = result {
                var contents = [BoardData]()
                for data in datas {
                    let id = data["b_id"]
                    let content = data["b_content"]
                    let nickname = data["u_nickname"]
                    let createTime = data["b_insert_date"]
                    let updateDate = data["b_update_date"]
                    
                        if let id = id, let content = content, let nickname = nickname {
                            let boardData = BoardData(id: id, nickname: nickname, content: content, createTime: createTime, updateTime: updateDate)
                            
                            contents.append(boardData)
                        }
                    
                }
                completionHandler(contents)
            }
        }
        task.resume()
    }
    
    class func updateData(completionHandler: @escaping ([BoardData]) -> Void)  {
        let request = Request()
        
        guard let url = URL(string: kUpdateBoardURL) else {
            print("Error: NetworkManager - updateData => url doesn't exist")
            return
        }
        
        try request.get(url: url, completionHandler: { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: NetworkManager - updateData => Data is empty")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] else {
                print("Error: NetworkManager - updateData => JSONSerialization Error")
                return
            }
            
            
            if let datas = result {
                
                var contents = [BoardData]()
                for data in datas {
                    let id = data["b_id"]
                    let content = data["b_content"]
                    let nickname = data["u_nickname"]
                    let createTime = data["b_insert_date"]
                    let updateDate = data["b_update_date"]
                    
                    NetworkManager.getImagePath(boardID: id!, completionHandler: { (imageURLs) in
                        
                        if let id = id, let content = content, let nickname = nickname {
                            let boardData = BoardData(id: id, nickname: nickname, content: content, createTime: createTime, updateTime: updateDate, imageURLs: imageURLs)
                            
                            contents.append(boardData)
                        }
                    })
                }
                completionHandler(contents)
            }
        })
        
    }
    
    class func uploadData(content: String, userID: String, images: [UIImage]? = nil, completionHandler: @escaping (String) -> Void) {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddhhmmss"
        let currentID = "\(userID)\(dateFormatter.string(from: date))"
        
        let param = ["b_id": currentID, "b_content": content, "u_id": userID]
        guard let paramData = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            print("Error: NetworkManager - loginUser => doesn't encoding to JSON")
            return
        }
        
        guard let url = URL(string: kUploadDataURL) else {
            print("Error: NetworkManager - loginUser => url doesn't exist")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        let task  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Error: NetworkManager - checkUser => Data is empty")
                return
            }
            
            guard let result = String(data: data, encoding: String.Encoding.utf8) else {
                print("Error: NetworkManager - checkUser => Data is not String")
                return
            }
            
            switch result {
            case "1":
                if let uploadImages = images {
                    for (index, value) in uploadImages.enumerated() {
                        uploadImageRequest(userID: userID, boardID: currentID, index: index, image: value)
                    }
                }
                completionHandler(result)
                
            default:
                completionHandler("-1")
            }
        }
        task.resume()
    }
    
    class func uploadImageRequest(userID: String, boardID: String, index: Int, image: UIImage) {

        let fID = "\(boardID)_\(index)"
        let param = ["f_id": fID, "fk_b_id": boardID, "u_id": userID]
        
        guard let paramData = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            print("Error: NetworkManager - loginUser => doesn't encoding to JSON")
            return
        }
        
        guard let url = URL(string: kUploadImageURL) else {
            print("Error: NetworkManager - loginUser => url doesn't exist")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let imageData = UIImageJPEGRepresentation(image, 1) else {
            print("Error: NetworManager - uploadImageRequest => image doesn't exist")
            return
        }
        
//        let json = createRequestBodyWith(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary, fileName: fID)
        
        request.httpBody = createRequestBodyWith(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary, fileName: fID)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Error: NetworkManager - uploadImageRequest => Data is empty")
                return
            }
            
            print("******* response = \(response)")
            
            
            let responseString = String(data: data, encoding: String.Encoding.utf8)
            print("****** response data = \(responseString!)")
        }
        
        task.resume()
    }
    
    class func getImagePath(boardID: String, completionHandler: @escaping ([String?]) -> Void) {
        
        let param = ["b_id": boardID]
        guard let paramData = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            print("Error: NetworkManager - getImagePath => doesn't encoding to JSON")
            return
        }
        
        guard let url = URL(string: kGetImagePath) else {
            print("Error: NetworkManager - getImagePath => url doesn't exist")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/json" , forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count) , forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data , response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            guard let result = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                print("Error: NetworkManager - getImagePath => Database Error.")
                return
            }
            
            print(result)
            
            if result.count == 0 {
                
                print("Error: NetworkManager - getImagePath => image doesn't exist.")
                completionHandler([])
                
                return
            }
            
            var paths = [String]()
            
            for path in result {
                paths.append(path["f_path"] as! String)
            }
            
            completionHandler(paths)
            
        }
        task.resume()
        
    }
    
    class func downLoadImage(path: String, completionHandler handler: @escaping (_ image: UIImage) -> Void){
        
        DispatchQueue.global(qos: .userInitiated).async { () -> Void in
            
            if let url = URL(string: kImageBaseURL + path), let imgData = try? Data(contentsOf: url), let img = UIImage(data: imgData) {
                DispatchQueue.main.async(execute: { () -> Void in
                    handler(img)
                })
            }
        }
    }
    
    
    // MARK: User Data
    class func getUserData(completionHandler: @escaping (UserData?) -> Void) {
        let id = UserDefaults.standard.string(forKey: kLoginUserIDKey)
        
        let param = ["id": id]
        guard let paramData = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            print("Error: NetworkManager - checkUser => doesn't encoding to JSON")
            return
        }
        
        guard let url = URL(string: kGetUserDataURL) else {
            print("Error: NetworkManager - checkUser => url doesn't exist.")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data , response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                print("Error: NetworkManager - checkUser => JSONSerialization Error.")
                return
            }
            
            if result?.count == 0 {
                
                print("Error: NetworkManager - loginUser => couldn't find user")
                completionHandler(nil)
                
                return
            }
            
            let uID = result?[0]["u_id"] as? String
            let uNickname = result?[0]["u_nickname"] as? String
            
            if let uID = uID, let uNickname = uNickname {
                let user = UserData(id: uID, nickname: uNickname, createTime: "")
                
                completionHandler(user)
            }
            
        }
        task.resume()
    }
    
    class func loginUser(id: String, password: String, completionHandler: @escaping (UserData) -> Void) {
        let request = Request()
        
        guard let url = URL(string: kLoginURL) else {
            print("Error: NetworkManager - loginUser => url doesn't exist.")
            return
        }
        
        let body = NSMutableDictionary()
        body.setValue(id, forKey: "id")
        body.setValue(password, forKey: "password")
        do {
            try request.post(url: url, body: body, completionHandler: { (data, response, error) in
                
                let result = try! JSONSerialization.data(withJSONObject: data, options: []) as? [[String: String]]
                
                
                guard let uID = result?[0]["u_id"], let uNickname = result?[0]["u_nickname"], let uJoinDate = result?[0]["u_join_date"] else {
                    print("Error: NetworkManager - loginUser => data doesn't exist.")
                    return
                }
                let userData = UserData(id: uID, nickname: uNickname, createTime: uJoinDate)
                
                completionHandler(userData)
            })
        } catch {
            print("Error : NetworkManager - loginUser => request Error ")
        }
    }
    
    class func login(id: String, completionHandler: @escaping (UserData?) -> Void) {
        
        let param = ["id": id]
        guard let paramData = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            print("Error: NetworkManager - loginUser => doesn't encoding to JSON")
            return
        }
        
        guard let url = URL(string: kLoginURL) else {
            print("Error: NetworkManager - loginUser => url doesn't exist")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/json" , forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count) , forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data , response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let result = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            
            if result?.count == 0 {
                
                print("Error: NetworkManager - loginUser => couldn't find user")
                completionHandler(nil)
                
                return
            }
            
            let uID = result?[0]["u_id"] as? String
            let uNickname = result?[0]["u_nickname"] as? String
            
            if let uID = uID, let uNickname = uNickname {
                let user = UserData(id: uID, nickname: uNickname, createTime: "")
                
                completionHandler(user)
            }
            
        }
        task.resume()
    }
    
    class func checkUser(id: String, completionHandler: @escaping (String) -> Void) {
        
        let param = ["id": id]
        guard let paramData = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            print("Error: NetworkManager - checkUser => doesn't encoding to JSON")
            return
        }
        
        guard let url = URL(string: kCheckUserURL) else {
            print("Error: NetworkManager - checkUser => url doesn't exist.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        let task  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Error: NetworkManager - checkUser => Data is empty")
                return
            }
            
            guard let result = String(data: data, encoding: String.Encoding.utf8) else {
                print("Error: NetworkManager - checkUser => Data is not String")
                return
            }
            
            completionHandler(result)
            
        }
        task.resume()
    }
    
    class func addUser(id: String, nickname: String, password: String, completionHandler: @escaping (String) -> Void) {
        
        let param = ["id": id, "nickname": nickname, "password": password]
        guard let paramData = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            print("Error: NetworkManager - checkUser => doesn't encoding to JSON")
            return
        }
        
        guard let url = URL(string: kJoinURL) else {
            print("Error: NetworkManager - checkUser => url doesn't exist.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        let task  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Error: NetworkManager - checkUser => Data is empty")
                return
            }
            
            guard let result = String(data: data, encoding: String.Encoding.utf8) else {
                print("Error: NetworkManager - checkUser => Data is not String")
                return
            }
            
            switch result {
            case "1":
                completionHandler(result)
            default:
                completionHandler("-1")
            }
        }
        task.resume()
    }
}

/*
    /* 1. Set the parameters */
    let param = ["key": "value"]
    let parmData = try! JSONSerialization.data(withJSONObject: param, options: [])
    
    /* 2/3. Build the URL, Configure the request */
    let url = "http://~"
    let request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = paramData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
    
    /* 4. Make the request */
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandler(Any)
        }
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            sendError("There was an error with your request: \(error)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            sendError("Your request returned a status code other than 2xx!")
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            sendError("No data was returned by the request!")
            return
        }
        
        /* 5/6. Parse the data and use the data (happens in completion handler) */
        completionHandler(Any)
    }
    
    /* 7. Start the request */
    task.resume()
    
    return task
*/
