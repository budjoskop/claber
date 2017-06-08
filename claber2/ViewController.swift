//
//  ViewController.swift
//  claber2
//
//  Created by Ognjen Tomić on 6/7/17.
//  Copyright © 2017 Ognjen Tomić. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var celija = MasterCell()
    var podaci:[Podaci]? = []
    
    //OUTLETI
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
      


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchPodake()
    }
    
    //Obavezni metodi za TABELU
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.podaci?.count ?? 0 // ovo je koristan kod i kaze ako je podaci.count nije nil vrati .count ako jeste nil vrati 0
        
        
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath) as! MasterCell
        
        cell.eventOutlet.text = self.podaci?[indexPath.row].event
        cell.placeOutlet.text = self.podaci?[indexPath.row].place
        cell.descOutlet.text =  self.podaci?[indexPath.row].desc
        
        return cell
    
    } 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.row == 0 {
            height = 180
        }
        else {
            height = 130
        }
        
        return height
    }
    
    
    
    //FUNKCIJA ZA HVATANJE PODATAKA POMOCU JSON-a
    
    func fetchPodake (){
        let urlRequets = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=mtv-news&sortBy=latest&apiKey=fae6d18b8b32450788c450231dd79f33")!)
        let task = URLSession.shared.dataTask(with: urlRequets) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            self.podaci = [Podaci]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                //ovo je castovanje u niz Dictionarie
                
                if let podaciIzJsona = json["articles"] as? [[String: AnyObject]] {
                    for podatakJson in podaciIzJsona {
                        let data = Podaci()
                        if let title = podatakJson["title"] as? String, let description = podatakJson["description"] as? String, let urlImage = podatakJson["urlToImage"] as? String {
                            data.event = title
                            data.desc = description
                            data.imageUrl = urlImage
                        }
                        self.podaci?.append(data)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()
                }
                
                }catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
}
