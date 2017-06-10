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
    let proveraNeta = Dostupnost()!
    
    
    //OUTLETI
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var warningOutlet: UILabel!
  
   
    
    
      


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewOutlet.contentInset = UIEdgeInsets(top: 74, left: 0, bottom: 64, right: 0)
        warningOutlet.isHidden = true
        proveriNet()
        
    }
    
    
    
    //Obavezni metodi za TABELU
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.podaci?.count ?? 0 // ovo je koristan kod i kaze ako je podaci.count nije nil vrati .count ako jeste nil vrati 0
        
        
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath) as! MasterCell
        
        cell.eventOutlet.text = self.podaci?[indexPath.item].event
        cell.placeOutlet.text = self.podaci?[indexPath.item].place
        cell.descOutlet.text =  self.podaci?[indexPath.item].desc
        cell.imageOutlet.downloadImage(from: (self.podaci?[indexPath.item].imageUrl)!) //ovo levo ima veze sa ektenzijom za UIImageView
        
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
    
    
   /*func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let eventVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eventDetail") as! EventDetailViewController
        let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath) as! MasterCell
        eventVC.dogadjaj = podaci?[indexPath.item].event
        eventVC.mesto = podaci?[indexPath.item].place
        eventVC.opis = self.podaci?[indexPath.item].desc
    
  
        self.present(eventVC, animated: true, completion: nil)
        
    }*/
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath) as! MasterCell
      
        if segue.identifier == "masterSegvej" {
            let eventVC = segue.destination as! EventDetailViewController
            let indexPath = self.tableViewOutlet.indexPathForSelectedRow!
            eventVC.dogadjaj = podaci?[indexPath.item].event
            eventVC.mesto = podaci?[indexPath.item].place
            eventVC.opis = self.podaci?[indexPath.item].desc
            eventVC.slika = self.podaci?[indexPath.item].imageUrl
            
        }
    }
    
    
    
    
    //FUNKCIJA ZA HVATANJE PODATAKA POMOCU JSON-a
    
    func fetchPodake (){
        let urlRequets = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=mtv-news&sortBy=latest&apiKey=fae6d18b8b32450788c450231dd79f33")!)
        let task = URLSession.shared.dataTask(with: urlRequets) { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                //DODATI KASNIJE ALERT ZA HVATANJE LOSE JSON-a
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
                
                }
                catch let error {
                    
                    print(error)
            }
        }
        task.resume()
    }
    
    // AlertController
    
    
    func displayAlert () {
        
        let alert = UIAlertController(title: "Pažnja", message: "Internet konekcija nije pronadjena", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        tableViewOutlet.isHidden = true
        
    }

    
    
    // Funkcija za proveru Dostupnosti internet konekcije
    
    func proveriNet () {
        
        proveraNeta.whenReachable = { _ in
            
            DispatchQueue.main.async {
                self.fetchPodake()
            }
        }
        
        proveraNeta.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self.displayAlert()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: ReachabilityChangedNotification, object: proveraNeta)
        
        do { try proveraNeta.startNotifier()
        } catch {
            print("Nije uspesno startovan notifier")
        }
    }
    
    
    // funkcija promeneStanja internet konekcije u realnom vremenu
    
    func internetChanged (note: Notification) {
        
        let reachability = note.object as! Dostupnost
        if reachability.isReachable {
            if reachability.isReachableViaWiFi{
                DispatchQueue.main.async {
                    self.fetchPodake()
                    self.tableViewOutlet.isHidden = false
                    self.warningOutlet.isHidden = true
                }
            } else {
                //ovo se odnosi za cellular
                DispatchQueue.main.async {
                    self.fetchPodake()
                    self.tableViewOutlet.isHidden = false
                    self.warningOutlet.isHidden = true
                }
            }
        } else {
            DispatchQueue.main.async {
                self.displayAlert()
                self.warningOutlet.isHidden = false
            }
        }
    }
    
    
    
    
    
    
    
}





// Extenzija da se parsuje url u UIImageView

extension UIImageView {
    
    func downloadImage(from url: String) {
        
        let urlRequest = URLRequest (url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
        
    }
}




