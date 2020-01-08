//
//  ViewController.swift
//  Messenger
//
//  Created by Dawid on 08/01/2020.
//  Copyright © 2020 Dawid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let jsonUrlString = "http://tgryl.pl/shoutbox/messages"
        //guard let url = URL(string: jsonUrlString) else { return }
        
        if let url = URL(string: "http://tgryl.pl/shoutbox/messages") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                 }
               }
           }.resume()
        }
        
        
    }
    


}

