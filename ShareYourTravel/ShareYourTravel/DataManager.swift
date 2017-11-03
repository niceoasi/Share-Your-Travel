//
//  DataController.swift
//  ShareYourTravel
//
//  Created by Jongwook Park on 2017. 2. 18..
//  Copyright © 2017년 vanillastep. All rights reserved.
//

import UIKit

// MARK: DataController
class DataManager: NSObject {
    
    // MARK: Properties
        // constant
    
    var contents = [BoardData]()
    var user: UserData?
    var dummyList = [BoardData]()
    
    var ownContents = [BoardData]()
    var userContents: [BoardData] {
        get {
            return ownContents
        }
        set {
            ownContents = contents.filter({ (content) -> Bool in
                content.nickname == user?.nickname
            })
        }
    }
    
    struct StaticInstance {
        static var instance: DataManager?
    }
    
    class func sharedInstance() -> DataManager {
        if StaticInstance.instance == nil {
            StaticInstance.instance = DataManager()
        }
        
        return StaticInstance.instance!
    }
    
    public func add(content: BoardData) {
        contents.append(content)
    }
    
    public func getContents() -> Array<BoardData> {
        return contents;
    }
    
    public func getContent(index: Int) -> BoardData {
        return contents[index]
    }
 
    class func updateData() {
    }
    
    class func addData(content: String, completionHandler: @escaping () -> Void) {
        
        let subject = ""
        let param = ["title": subject, "content": content]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        guard let url = URL(string: kAddURL) else {
            print("Error: DataController - addData => url doesn't exist")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/json" , forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count) , forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data , response,
            error) in
            
            completionHandler()
        }
        task.resume()
    }


    
    // MARK: Dummy Data
    func initDummyList() {
        let image1 = UIImage(named: "girl1")
        let image2 = UIImage(named: "girl2")
        let image3 = UIImage(named: "girl3")
        let image4 = UIImage(named: "girl4")
        let image5 = UIImage(named: "girl5")
        let image6 = UIImage(named: "girl6")
        let image7 = UIImage(named: "girl7")
        let image8 = UIImage(named: "girl8")
        let image9 = UIImage(named: "flash")
        let image10 = UIImage(named: "ocean")
        let image11 = UIImage(named: "sunset")
        let image12 = UIImage(named: "burj-khalifa")
        
        let images1 = [image1, image2, image3, image4, image5, image6, image7, image8]
        let images2 = [image9, image10, image11, image12]
        let images3 = [image3, image5, image9, image11]
        let images4 = [image4, image6, image10, image12]
        
        
        let board1 = BoardData(id: "1", nickname: "아", content: "있다", images: images1 as NSArray)
        let board2 = BoardData(id: "2", nickname: "야", content: "아라", images: images2 as NSArray)
        let board3 = BoardData(id: "3", nickname: "어", content: "아", images: images3 as NSArray)
        let board4 = BoardData(id: "4", nickname: "여", images: images4 as NSArray)
        let board5 = BoardData(id: "5", nickname: "오", content: "바")
        let board6 = BoardData(id: "6", nickname: "요", images: [image8, image7])
        let board7 = BoardData(id: "2", nickname: "야", content: "아", images: [image6])
        let board8 = BoardData(id: "1", nickname: "아", content: "다")
        
        dummyList.append(board1)
        dummyList.append(board2)
        dummyList.append(board3)
        dummyList.append(board4)
        dummyList.append(board5)
        dummyList.append(board6)
        dummyList.append(board7)
        dummyList.append(board8)
    }
}









