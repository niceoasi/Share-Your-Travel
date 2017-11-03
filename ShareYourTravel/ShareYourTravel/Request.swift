//
//  Request.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 04/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import Foundation

class Request {
    let session: URLSession = URLSession.shared
    
    // GET METHOD
    func get(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    // POST METHOD
    func post(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    // PUT METHOD
    func put(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    // PATCH METHOD
    func patch(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    // DELETE METHOD
    func delete(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    
    
    
}

/*
 let request: Request = Request()

let url: URL = URL(string: "https://api.example.com/path/to/resource")!
let body: NSMutableDictionary = NSMutableDictionary()
body.setValue("value", forKey: "key")

try request.post(url: url, body: body, completionHandler: { data, response, error in
    // code
})
 */


// RequestBody
func createRequestBodyWith(parameters: [String: String], filePathKey: String, imageDataKey: Data, boundary: String, fileName: String) -> Data {
    
    var body = Data()
    
    for (key, value) in parameters {
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.appendString(string: "\(value)\r\n")
    }
    
    body.appendString(string: "--\(boundary)\r\n")
    
    let mimetype = "image/jpg"
    //        let defFileName = fileName
    
    body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(fileName)\"\r\n")
    body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
    body.append(imageDataKey)
    body.appendString(string: "\r\n")
    
    body.appendString(string: "--\(boundary)--\r\n")
    
//    let json =  try? JSONSerialization.data(withJSONObject: body, options: []) as? [String: String]
    
    return body
}
// USE => request.httpBody = self.createRequestBodyWith(parameters:yourParamsDictionary, filePathKey:yourKey, boundary:self.generateBoundaryString)

func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}

extension Data {
    
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
