//
//  ViewController.swift
//  claber2
//
//  Created by Ognjen Tomić on 6/7/17.
//  Copyright © 2017 Ognjen Tomić. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    
    var celija = MasterCell()
    var podaci:[Podaci]? = []
    var filterArray:[Podaci] = []
    let proveraNeta = Dostupnost()!
    var hasSearched = false
    var datum = Date()
    
    
    //OUTLETI
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var warningOutlet: UILabel!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var datePickerViewOutlet: UIView!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var dateBtnOutlet: UIButton!
    @IBOutlet weak var resetBtnOutlet: UIButton!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var dateInfoViewOutlet: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewOutlet.contentInset = UIEdgeInsets(top: 94, left: 0, bottom: 64, right: 0)
        dateInfoViewOutlet.layer.borderWidth = 0.4
        dateInfoViewOutlet.layer.borderColor = UIColor.black.cgColor
        tableViewOutlet.layer.borderWidth = 0.4
        tableViewOutlet.layer.borderColor = UIColor.black.cgColor

        
        warningOutlet.isHidden = true
        datePickerViewOutlet.isHidden = true
        dateBtnOutlet.layer.cornerRadius = 12
        doneBtnOutlet.layer.cornerRadius = 12
        resetBtnOutlet.layer.cornerRadius = 12
        //searchBarOutlet.showsCancelButton = false
        dateFormatFunkcija()
        
        proveriNet()
        date()
        
    }

    
 
    //Obavezni metodi za TABELU
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.podaci?.count ?? 0 // ovo je koristan kod i kaze ako je podaci.count nije nil vrati .count ako jeste nil vrati 0
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath) as! MasterCell
        
        if (self.podaci?.isEmpty)! {
             print("Greska je nastala Array nije stigao da se napuni podaci.count")
            
                }
        else {
            
            cell.eventOutlet.text = self.podaci?[indexPath.row].event
            cell.placeOutlet.text = self.podaci?[indexPath.row].place
            cell.descOutlet.text =  self.podaci?[indexPath.row].desc
            cell.imageOutlet.downloadImage(from: (self.podaci?[indexPath.row].imageUrl)!) //ovo levo ima veze sa ektenzijom za UIImageView
           
            }
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBarOutlet.resignFirstResponder()
        searchBarOutlet.endEditing(true)
        searchBarOutlet.showsCancelButton = false

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
    
        if segue.identifier == "masterSegvej" {
            let eventVC = segue.destination as! EventDetailViewController
            let indexPath = self.tableViewOutlet.indexPathForSelectedRow!
            eventVC.dogadjaj = podaci?[indexPath.row].event
            eventVC.mesto = podaci?[indexPath.row].place
            eventVC.opis = self.podaci?[indexPath.row].desc
            eventVC.slika = self.podaci?[indexPath.row].imageUrl
            
        }
    }
    
    
  
    
    
    
    //FUNKCIJA ZA HVATANJE PODATAKA POMOCU JSON-a
    
    func fetchPodake (){
        let urlRequets = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=mtv-news&sortBy=latest&apiKey=fae6d18b8b32450788c450231dd79f33")!)
        let task = URLSession.shared.dataTask(with: urlRequets) { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                //DODATI KASNIJE ALERT ZA HVATANJE LOSEG JSON-a
                return
            }
            
            self.podaci = [Podaci]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                //ovo je castovanje u niz Dictionarie
                
                if let podaciIzJsona = json["articles"] as? [[String: AnyObject]] {
                    for podatakJson in podaciIzJsona {
                        
                        let data = Podaci()
                        
                        if let title = podatakJson["title"] as? String,
                            let description = podatakJson["description"] as? String,
                            let urlImage = podatakJson["urlToImage"] as? String,
                            let url = podatakJson["url"] as? String {
                            
                            data.event = title
                            data.desc = description
                            data.imageUrl = urlImage
                            data.place = url
                        }
                        
                        self.podaci?.append(data)
                        self.filterArray = self.podaci!
                        
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
    
    
    // Funkcije za SEARCH

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarOutlet.endEditing(true)
        searchBarOutlet.resignFirstResponder()
        searchBarOutlet.showsCancelButton = false
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         searchBarOutlet.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarOutlet.showsCancelButton = true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBarOutlet.text == nil || searchBarOutlet.text == ""{
            
            hasSearched = false
            searchBarOutlet.showsCancelButton = true
            
           
            
            podaci = filterArray
            
            view.endEditing(true)
            self.tableViewOutlet.reloadData()
            
        } else {
            
            hasSearched = true
            searchBarOutlet.showsCancelButton = true
         
            podaci = podaci?.filter({ (pod) -> Bool in
                if (pod.event?.lowercased().contains((searchBarOutlet.text?.lowercased())!))!{
                                        
                    return true
                    
                } else {
                    
                    return false
                }
            })
            
            self.tableViewOutlet.reloadData()
            
        }
       
    }
    
    
    
    //Funkcije DatePicker-a
    
    
    func date(){
        let date = Date()
        var components = DateComponents()
        components.day = +7
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        datePickerOutlet.minimumDate = date
        datePickerOutlet.maximumDate = maxDate
        datePickerOutlet.setValue(UIColor.black, forKeyPath: "textColor")
    }
    
    func dateFormatFunkcija (){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yy"
        let inputDate = dateFormater.string(from: datum)
        dateLabelOutlet.text = "\(inputDate)"
    }
    
 
    
    
    @IBAction func dateBtn(_ sender: Any) {
        datePickerViewOutlet.isHidden = false
        dateLabelOutlet.isHidden = true
        resetBtnOutlet.isHidden = true
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tableViewOutlet.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableViewOutlet.addSubview(blurEffectView)
        
        UIView.animate(withDuration: 0.3) {self.tableViewOutlet.frame.origin.y = 200}
        tableViewOutlet.isScrollEnabled = false
        tableViewOutlet.allowsSelection = false
        dateBtnOutlet.isHidden = true
        searchBarOutlet.isUserInteractionEnabled = false
       
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        datePickerViewOutlet.isHidden = true
        dateLabelOutlet.isHidden = false
        searchBarOutlet.isUserInteractionEnabled = true
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tableViewOutlet.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        
        for subview in tableViewOutlet.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.3) {self.tableViewOutlet.frame.origin.y = 0}
        tableViewOutlet.isScrollEnabled = true
        dateBtnOutlet.isHidden = false
        tableViewOutlet.allowsSelection = true
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yy"
        let inputDate = dateFormater.string(from: datePickerOutlet.date)
        dateLabelOutlet.text = "\(inputDate)"
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        
        searchBarOutlet.isUserInteractionEnabled = true
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yy"
        let inputDate = dateFormater.string(from: datum)
        dateLabelOutlet.text = "\(inputDate)"
        datePickerOutlet.date = Date()
        resetBtnOutlet.isHidden = true
        
    }
 
    @IBAction func datePickerBtn(_ sender: Any) {
        
        
        resetBtnOutlet.isHidden = false
        
        
        
    }
    
    

    
    
    
    
    
/////////////// KRAJ KLASE UIVIEW KONTROLER
}





// Extenzija da se parsuje url u UIImageView

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func downloadImage(from url: String) {
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            
            self.image = imageFromCache
            return
            
        }
        
        let urlRequest = URLRequest (url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async {
                
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: url as AnyObject)
                self.image = imageToCache
            }
        }
        task.resume()
        
    }
}












