/*
 Created by Idrees Hassan, hope you enjoy!
 GitHub Repository: https://github.com/IdreesInc/Dark-Sky-API-Example
 Personal Website: http://idreesinc.com
 License: MIT
 */

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true // API request will time out otherwise

// Get the Dark Sky API key from 'api_key.secret' in the resources folder [not provided w/ this code]
guard let keyFileURL = Bundle.main.url(forResource: "api_key", withExtension: "secret") else {
    fatalError("'api_key.secret' file not found. Please provide a Dark Sky API key to continue")
}
let key = try String(contentsOf: keyFileURL, encoding: .utf8).replacingOccurrences(of: "\n", with: "")
// The coordinates for UNC Chapel Hill
let latitude = "35.912034"
let longitude = "-79.051228"
let apiURL = "https://api.darksky.net/forecast/\(key)/\(latitude),\(longitude)"
guard let requestURL = URL(string: apiURL) else {
    fatalError("URL not formatted correctly")
}
let request = URLRequest(url: requestURL)

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    guard error == nil else {
        fatalError("API request failed with error")
    }
    guard let responseData = data else {
        fatalError("Error: did not receive data")
    }
    guard let json = try! JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] else {
        fatalError("JSON conversion failed")
    }
    guard let currently = json["currently"] as? [String: Any] else {
        fatalError("'currently' not found")
    }
    guard let daily = json["daily"] as? [String: Any] else {
        fatalError("'daily' not found")
    }
    guard let temperature = currently["temperature"] as? Double else {
        fatalError("'currently.temperature' not found")
    }
    guard let dailySummary = daily["summary"] as? String else {
        fatalError("'daily.summary' not found")
    }
    print("--- Weather in UNC Chapel Hill ---")
    print("Temperature is currently \(temperature)")
    print("\(dailySummary)")
}
task.resume()
