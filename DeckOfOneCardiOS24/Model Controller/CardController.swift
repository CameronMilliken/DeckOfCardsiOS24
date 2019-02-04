//
//  CardController.swift
//  DeckOfOneCardiOS24
//
//  Created by Cameron Milliken on 2/4/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//


import UIKit

class CardController {
    
    //Base URL
    //Makes it hidden from the rest of the application but availabe within the class.
    private static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/")
    
    //CRUD
    //Create
    //Static makes the function public
    static func drawCard(numberOfCards: Int, completion: @escaping ((_ cards: [Card]) -> Void)) {
        //build URL
        guard let url = baseURL else {fatalError("🤬 URL optional is having issues!")}
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let countQueryItem = URLQueryItem(name: "count", value: "\(numberOfCards)")
        components?.queryItems = [countQueryItem]
        
        //build Request URL
        guard let requestURL = components?.url else {return}
        print(requestURL)
        
        //Get My Data
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        //Data Task
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            do {
                if let error = error {throw error}
                guard let data = data else {throw NSError()}
                
                //Decode
                let jsonDeocder = JSONDecoder()
                let deck = try! jsonDeocder.decode(TopLevelDictionary.self, from: data)
                completion(deck.cards)
            } catch {
                //Handle my data and error accordingly
                print("Error retreiving cards from  \(requestURL)")
                //Complete with my cards
                completion([])
                return
            }
        }
        
        dataTask.resume()
    }
    
    static func image(forURL url:String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: url) else {return}
        let imageDataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let imageError = error {
                print("Error retriving image\(imageError.localizedDescription)")
            }
            guard let data = data,
                let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(nil)
                        
                    }
                    return
            }
            DispatchQueue.main.async {
                completion(image)
                
            } //Asyncing takes you back to the main thread.
        }
        imageDataTask.resume()
    }
}

