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

class ViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    //var messagesArray:[(content: String, login: String, date: String)] = []
    var messagesArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        print(messagesArray.count)
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
                    //self.messagesArray.append((message.content,message.login,message.date))
                    self.messagesArray.append("Content: "+message.content+"Login: "+message.login+"Date "+message.date)
                }
            }catch let jsonErr{
                print(jsonErr)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }.resume()

    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.numberOfLines = 3
        
        cell.textLabel?.text = messagesArray[indexPath.row]

        let message = messagesArray[indexPath.row]
        cell.textLabel?.text = message
        return cell
    }
}
