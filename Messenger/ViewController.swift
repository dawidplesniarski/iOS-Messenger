//
//  ViewController.swift
//  Messenger
//
//  Created by Dawid on 08/01/2020.
//  Copyright © 2020 Dawid. All rights reserved.
//

import UIKit
import FirebaseAuth


struct User: Codable{
       var content: String
       var login: String
       var date: String
       var id: String
}

class ViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var messagesArray:[(content: String, id: String)] = []
    //var messagesArray:[String] = []
    var myLogin: String = ""
    
    func getUserMail(){
        let user = Auth.auth().currentUser
        if let user = user {
            myLogin = user.email ?? "User"
        }
        
        print(myLogin)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserMail()
        loadData()
        print(messagesArray.count)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
       sendMsg()
    }
    /*
    func deleteMsg(id: String){
        //let parameters = ["ID": "16"] as [String : Any]
        guard let url = URL(string: "http://tgryl.pl/shoutbox/message/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject:id, options: []) else { return }
        request.httpBody = httpBody
    }*/
    
    func deleteMsg(id: String){
        let firstTodoEndpoint: String = "http://tgryl.pl/shoutbox/message/\(id)"
        print(firstTodoEndpoint)
        var firstTodoUrlRequest = URLRequest(url: URL(string: firstTodoEndpoint)!)
        firstTodoUrlRequest.httpMethod = "DELETE"

        let session = URLSession.shared

        let task = session.dataTask(with: firstTodoUrlRequest) {
          (data, response, error) in
          guard let _ = data else {
            print("error calling DELETE on /todos/1")
            return
          }
          print("DELETE ok")
        }
        task.resume()
    }
    
    func sendMsg(){
        let parameters = ["content": textView.text ?? "message", "login": myLogin] as [String : Any]

            //create the url with URL
            let url = URL(string: "http://tgryl.pl/shoutbox/message")!

            //create the session object
            let session = URLSession.shared

            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

                guard error == nil else {
                    return
                }

                guard let data = data else {
                    return
                }

                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        // handle json...
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            task.resume()
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
                    //self.messagesArray.append("Content: "+message.content+"\nLogin: "+message.login+"\nDate "+message.date)
                    self.messagesArray.append(("Content: \(message.content), Login: \(message.login), Date: \(message.date)",message.id))
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
        
        cell.textLabel?.text = messagesArray[indexPath.row].content

        let message = messagesArray[indexPath.row].content
        cell.textLabel?.text = message
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
        let idToDelete = messagesArray[indexPath.row].id //przypisujemy ID do usunięcia
        self.messagesArray.remove(at: indexPath.row) // usuwamy z tablicy
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        print(idToDelete)//wypisuje ID
        
        deleteMsg(id: idToDelete)
      }
    }
}
