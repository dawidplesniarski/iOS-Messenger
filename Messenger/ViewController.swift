//
//  ViewController.swift
//  Messenger
//
//  Created by Dawid on 08/01/2020.
//  Copyright © 2020 Dawid. All rights reserved.
//

import UIKit


struct User: Codable{
       var content: String
       var login: String
       var date: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData(){
        let jsonUrlString = "http://tgryl.pl/shoutbox/messages"
        guard let url = URL(string: jsonUrlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do{
                let decoder = JSONDecoder()
                let messages = try decoder.decode([User].self, from:data) //Decode JSON Response Data
                //print(messages)
                
                for message in messages{
                    print("Content: " + message.content)
                    print("Login: " + message.login)
                    print("Date: " + message.date)
                }
            }catch let jsonErr{
                print(jsonErr)
            }
        }.resume()

    }


}

