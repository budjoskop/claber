//
//  ViewController.swift
//  claber
//
//  Created by Ognjen Tomić on 6/7/17.
//  Copyright © 2017 Ognjen Tomić. All rights reserved.
//

import UIKit

class Clubs: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    
    var celija = MasterCell()
    var podaci:[Podaci]? = []
    var filterArray:[Podaci] = []
    var dayArray:[Podaci] = []
    var dayArrayUnfiltered:[Podaci] = []
    let proveraNeta = Dostupnost()!
    var hasSearched = false
    var datum = Date()
    var dateCheck = Date()
    let formatter = DateFormatter()
    var loadDate = String()
    var dateFilter = Int()
    var monthFilter = Int()
    var returnDate = ""
    var returnMonth = ""
    let imageView = UIImageView()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(Clubs.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    
    
/////////////////////// OUTLETS ///////////////////////
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var warningOutlet: UILabel!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var searchBarBtnOutlet: UIBarButtonItem!
    @IBOutlet weak var datePickerViewOutlet: UIView!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var dateLabelOutlet: UIBarButtonItem!
    @IBOutlet weak var resetBtnOutlet: UIButton!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var infoDateOutlet: UILabel!
    @IBOutlet weak var dateBtnOutlet: UIBarButtonItem!
    @IBOutlet weak var contactOutlet: UIBarButtonItem!
    @IBOutlet weak var accordianOutlet: UIBarButtonItem!
    @IBOutlet weak var toolBarOutlet: UIToolbar!
    
    

    
/////////////////////// DIDLOAD ///////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewOutlet.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        tableViewOutlet.layer.borderWidth = 0.4
        tableViewOutlet.layer.borderColor = UIColor.black.cgColor
        warningOutlet.isHidden = true
        datePickerViewOutlet.isHidden = true
        infoDateOutlet.isHidden = true
        accordianOutlet.isEnabled = false
        doneBtnOutlet.layer.cornerRadius = 12
        resetBtnOutlet.layer.cornerRadius = 12
        dateFormatFunkcija()
        tableViewOutlet.backgroundColor = UIColor.white
        proveriNet()
        date()
        loadDate = dateLabelOutlet.title!
        print("OVO JE DATUM PRILIKOM LOAD-a \(loadDate)")
        searchBarOutlet.isHidden = true
        dateLabelOutlet.isEnabled = false
        navigationItem.hidesBackButton = true
        self.accordianOutlet.width = self.view.bounds.width / 4
        self.dateBtnOutlet.width = self.view.bounds.width / 4
        self.dateLabelOutlet.width = self.view.bounds.width / 4
        self.contactOutlet.width = self.view.bounds.width / 4
        self.navigationItem.rightBarButtonItem?.width = self.view.bounds.width / 4
        self.tableViewOutlet.addSubview(self.refreshControl)
        
    }
    
    
    
    
    
    
/////////////////////// Funkcije za PUll - reload ///////////////////////
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        fetchPodake()
        self.tableViewOutlet.reloadData()
        refreshControl.endRefreshing()
    }
    
    
/////////////////////// Obavezni metodi za TableView ///////////////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if returnDate == "" && returnMonth == "" {
            print ("nalazis se ovde returnDate string je prazan")
            formatter.dateFormat = "dd/MM/yy"
            // Add Refresh Control to Table View
            let calendar = Calendar.current
            let loadDateFromPicker = formatter.date(from: loadDate)
            dateFilter = calendar.component(.day, from: loadDateFromPicker!)
            monthFilter = calendar.component(.month, from: loadDateFromPicker!)
            print ("do ovde si uspeo da doguras \(dateFilter)")
            self.dayArray = self.podaci!.filter({return $0.month == monthFilter && $0.day == dateFilter})
            //return self.podaci?.count ?? 0 // ovo je koristan kod i kaze ako je podaci.count nije nil vrati .count ako jeste nil vrati 0
        } else {
             print ("nalazis se ovde returnDate STRING nije prazan")
            formatter.dateFormat = "dd/MM/yy"
            // Add Refresh Control to Table View
            let calendar = Calendar.current
            let loadDateFromPicker = formatter.date(from: returnDate)
            dateFilter = calendar.component(.day, from: loadDateFromPicker!)
            monthFilter = calendar.component(.month, from: loadDateFromPicker!)
            print ("do ovde si uspeo da doguras \(dateFilter)")
            self.dayArray = self.podaci!.filter({return $0.month == monthFilter && $0.day == dateFilter })
            dateLabelOutlet.title! = "\(returnDate)"
        }
    
        if dayArray.count == 0  {
            self.warningOutlet.isHidden = false
            self.tableViewOutlet.isHidden = true
        
        } else {
            
            self.warningOutlet.isHidden = true
            self.tableViewOutlet.isHidden = false
        }
      return self.dayArray.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath) as! MasterCell
    
        //Table Load
        
        if (self.podaci?.isEmpty)! {
             print("Greska je nastala Array nije stigao da se napuni podaci.count")}
            
        else {
                cell.eventOutlet.text = self.dayArray[indexPath.row].event
                cell.placeOutlet.text = self.dayArray[indexPath.row].place
                cell.descOutlet.text =  self.dayArray[indexPath.row].desc
                cell.addressOutlet.text =  self.dayArray[indexPath.row].address
                cell.imageOutlet.downloadImage(from: (self.dayArray[indexPath.row].clubUrl)!) //ovo levo ima veze sa ektenzijom za UIImageView
                cell.timeOutlet.text  = self.dayArray[indexPath.row].timeOfEvent
                cell.backgroundColor = UIColor.white
                cell.eventOutlet.textColor = UIColor.black
                cell.placeOutlet.textColor = UIColor.black
                cell.descOutlet.textColor = UIColor.black
                cell.addressOutlet.textColor = UIColor.black
                cell.timeOutlet.textColor = UIColor.black
            
            }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
/////////////////////// istraziti jos ovaj deo da ne koci aplikacija ///////////////////////

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        DispatchQueue.main.async {
//            UIView.animate(withDuration: 0.3, animations: {
//                cell.contentView.alpha = 1.0
//            })
//        }
//    }
    
  
    @IBAction func backToTopBtn(_ sender: Any) {
        tableViewOutlet.setContentOffset(CGPoint.zero, animated: true)
    }
    
    
    func backToTop () {
        if tableViewOutlet.contentOffset.y > 400 {
            accordianOutlet.isEnabled = true
        } else {
            accordianOutlet.isEnabled = false
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        backToTop()
        searchBarOutlet.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {self.tableViewOutlet.frame.origin.y = 0}
        searchBarOutlet.isHidden = true
        searchBarOutlet.endEditing(true)
        searchBarOutlet.showsCancelButton = false
    }
    
  
    
    
/////////////////////// SEQUE ///////////////////////
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "masterSegvej" {
            searchBarOutlet.resignFirstResponder()
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            let svc = segue.destination as! EventDetailViewController
            let indexPath = self.tableViewOutlet.indexPathForSelectedRow!
            svc.dogadjaj = dayArray[indexPath.row].event
            svc.mesto = dayArray[indexPath.row].place
            svc.opis = self.dayArray[indexPath.row].desc
            svc.date = self.dayArray[indexPath.row].date
            svc.eventId = self.dayArray[indexPath.row].eventId
            svc.slika = self.dayArray[indexPath.row].imageUrl
            svc.eventPhone = self.dayArray[indexPath.row].phone
            svc.address = self.dayArray[indexPath.row].address
            svc.latitudeClub = self.dayArray[indexPath.row].latitudeEvent
            svc.longitudeClub = self.dayArray[indexPath.row].longitudeEvent
            
        } else if segue.identifier == "contact" {
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem
        } else if segue.identifier == "switch" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        } 
    }
    

    
    
    func tableAnimation () {
        UIView.animate(withDuration: 0.3) {self.tableViewOutlet.frame.origin.y = 200}
        UIView.animate(withDuration: 0.3) {self.tableViewOutlet.frame.origin.y = 0}
    }

    
/////////////////////// Func to catch JSON feed ///////////////////////
    
    func fetchPodake (){
        let urlRequets = URLRequest(url: URL(string: "http://138.201.1.10/api/v1/events")!)
        let task = URLSession.shared.dataTask(with: urlRequets) { (data, response, error) in
            
            if error != nil {
                self.whoops()
                print(error as Any)
                //DODATI KASNIJE ALERT ZA HVATANJE LOSEG JSON-a
                return
            }
            
            self.podaci = [Podaci]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
       
                //ovo je castovanje u niz Dictionarie
                
                if let podaciIzJsona = json["events"] as? [[String: AnyObject]] {
                    for podatakJson in podaciIzJsona {
                    
                        let data = Podaci()
                        
                        if let title = podatakJson["EventName"] as? String,
                            let description = podatakJson["EventDescription"] as? String,
                            let urlImage = podatakJson["EventImage"] as? String,
                            let place = podatakJson["ClubName"] as? String,
                            let eventDate = podatakJson["EventStartTime"] as? String,
                            let eventStreet = podatakJson["EventStreet"] as? String,
                            let clubImage = podatakJson ["ClubImage"] as? String,
                            let eventId = podatakJson["EventId"] as? String,
                            let phone = podatakJson["Phone"] as? String,
                            let latitude = podatakJson["Latitude"] as? String,
                            let longitude = podatakJson["Longitude"] as? String{
                            data.eventId = eventId
                            data.event = title
                            data.desc = description
                            data.imageUrl = urlImage
                            data.place = place
                            data.clubUrl = clubImage
                            data.date = eventDate
                            data.address = eventStreet
                            data.phone = phone
                            data.latitudeEvent = latitude
                            data.longitudeEvent = longitude
                            self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            data.checkDate = self.formatter.date(from: data.date!)
                            let calendar = Calendar.current
                            data.day = calendar.component(.day, from: data.checkDate!)
                            data.month = calendar.component(.month, from: data.checkDate!)
                            
                            func convertTimeFormater(_ time: String) -> String {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let time = dateFormatter.date(from: data.date!)
                                dateFormatter.dateFormat = "HH:mm"
                                return  dateFormatter.string(from: time!)
                            }
                            data.timeOfEvent = convertTimeFormater(data.date!)
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
                    self.whoops()
                    print(error)
            }
        }
        task.resume()
    }
    
/////////////////////// ALERT CONTROLLER ///////////////////////
    
    func displayAlert () {
        let alert = UIAlertController(title: "Attention", message: "Internet connection is not found", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        tableViewOutlet.isHidden = true
    }
    
    func whoops () {
        let alert = UIAlertController(title: "Whoops", message: "Something went wrong, we will back soon", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        tableViewOutlet.isHidden = true
    }
    
    

/////////////////////// INTERNET CONNECTION CHECK ///////////////////////
    
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
    
    
/////////////////////// INTERNET CONNECTION CHECK in realtime ///////////////////////
    
    @objc func internetChanged (note: Notification) {
        let reachability = note.object as! Dostupnost
        if reachability.isReachable {
            if reachability.isReachableViaWiFi{
                DispatchQueue.main.async {
                    self.fetchPodake()
                    self.tableViewOutlet.isHidden = false
                    self.warningOutlet.isHidden = true
                    self.warningOutlet.text = "No events today"
                }
            } else {
                //ovo se odnosi za cellular
                DispatchQueue.main.async {
                    self.fetchPodake()
                    self.tableViewOutlet.isHidden = false
                    self.warningOutlet.isHidden = true
                    self.warningOutlet.text = "No events today"
                }
            }
        } else {
            DispatchQueue.main.async {
                self.displayAlert()
                self.warningOutlet.isHidden = false
                self.warningOutlet.text = "Network problem"
            }
        }
    }
    
    
/////////////////////// Funkcije za SEARCH //////////////////////////
  
    @IBAction func searchBtn(_ sender: Any) {
        if searchBarOutlet.isHidden == true {
            
            searchBarOutlet.isHidden = false
            UIView.animate(withDuration: 0.3) {self.tableViewOutlet.frame.origin.y = 65}
            searchBarOutlet.becomeFirstResponder()
        } else {
            UIView.animate(withDuration: 0.3) {self.tableViewOutlet.frame.origin.y = 0}
            searchBarOutlet.isHidden = true
            searchBarOutlet.resignFirstResponder()
        }
    }
    
    func resetArray () {
        if dayArrayUnfiltered.count == 0  {
            dayArrayUnfiltered = self.podaci!.filter({return $0.month == monthFilter && $0.day == dateFilter})
            print ("Sada ovaj niz ima \(dayArrayUnfiltered.count)")
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        podaci! = filterArray
        searchBarOutlet.endEditing(true)
        searchBarOutlet.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {self.tableViewOutlet.frame.origin.y = 0}
        searchBarOutlet.isHidden = true
        searchBarOutlet.showsCancelButton = false
        print ("ovde si usao")
    }
    

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         searchBarOutlet.showsCancelButton = true
         podaci! = filterArray
        print ("ovde si usao")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarOutlet.showsCancelButton = true
        podaci! = filterArray
        searchFunkcija()
        print ("ovde si usao")
    }
    
    func searchFunkcija () {
        if searchBarOutlet.text == nil || searchBarOutlet.text == ""{
            warningOutlet.text = "No events today"
            hasSearched = false
            searchBarOutlet.showsCancelButton = true
            podaci! = filterArray
            view.endEditing(true)
            self.tableViewOutlet.reloadData()
        }
        else {
            resetArray()
            dayArray = dayArrayUnfiltered
            hasSearched = true
            searchBarOutlet.showsCancelButton = true
            print ("ovoliko ima pre filtera \(dayArrayUnfiltered.count)")
            podaci! = dayArray.filter({ (pod) -> Bool in
                if (pod.event?.lowercased().contains((searchBarOutlet.text?.lowercased())!))! || (pod.place?.lowercased().contains((searchBarOutlet.text?.lowercased())!))! || (pod.desc?.lowercased().contains((searchBarOutlet.text?.lowercased())!))! {
                   
                    print ("ovoliko ima posle filtera \(dayArrayUnfiltered.count)")
                    return true
                }
                else {
                   
                    warningOutlet.text = "Nothing found"
                    print ("vraca false")
                    return false
                }
            })
            self.tableViewOutlet.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFunkcija()
    }
    
    
/////////////////////// Funkcije DatePicker-a ///////////////////////
    
    func displayTodayBtn () {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yy"
        let inputDate = dateFormater.string(from: datum)
        print (inputDate)
        print (dateLabelOutlet.title!)
        if dateLabelOutlet.title! == inputDate {
            resetBtnOutlet.isHidden = true
        } else {
            resetBtnOutlet.isHidden = false
        }
    }
    
    
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
       // print (inputDate)
        dateLabelOutlet.title! = "\(inputDate)"
    }
    
    
    @IBAction func dateBtn(_ sender: Any) {
        displayTodayBtn()
        accordianOutlet.isEnabled = false
        contactOutlet.isEnabled = false
        dateBtnOutlet.isEnabled = false
        searchBarBtnOutlet.isEnabled = false
        datePickerViewOutlet.isHidden = false
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tableViewOutlet.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableViewOutlet.addSubview(blurEffectView)
        tableViewOutlet.isScrollEnabled = false
        tableViewOutlet.allowsSelection = false
        infoDateOutlet.isHidden = false
        searchBarOutlet.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {self.tableViewOutlet.frame.origin.y = -100}
        dayArrayUnfiltered = []
    }
    

    @IBAction func doneBtn(_ sender: Any) {
        tableViewOutlet.contentOffset.y = 0
        accordianOutlet.isEnabled = false
        contactOutlet.isEnabled = true
        dateBtnOutlet.isEnabled = true
        searchBarBtnOutlet.isEnabled = true
        datePickerViewOutlet.isHidden = true
        infoDateOutlet.isHidden = true
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
        tableViewOutlet.allowsSelection = true
        let dateFormater = DateFormatter()
        let calendar = Calendar.current
        dateFormater.dateFormat = "dd/MM/yy"
        let inputDate = dateFormater.string(from: datePickerOutlet.date)
        dateLabelOutlet.title! = "\(inputDate)"
        let loadDateFromPicker = formatter.date(from: loadDate)
        dateFilter = calendar.component(.day, from: loadDateFromPicker!)
        print("Sad si uspeo ovo da izaberese \(dateFilter)")
        loadDate = "\(inputDate)"
        returnDate = ""
        returnMonth = ""
        dayArrayUnfiltered = []
        self.tableViewOutlet.reloadData()
    }
    
    @IBAction func resetBtn(_ sender: Any) {
    
        searchBarOutlet.isUserInteractionEnabled = true
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yy"
        let inputDate = dateFormater.string(from: datum)
        dateLabelOutlet.title! = "\(inputDate)"
        datePickerOutlet.date = Date()
        resetBtnOutlet.isHidden = true
        dayArrayUnfiltered = []
    }
 
    @IBAction func datePickerBtn(_ sender: Any) {
        resetBtnOutlet.isHidden = false
    }
    
    
/////////////////////// kraj Funkcije DatePicker-a ///////////////////////
    
} /////////////// KRAJ KLASE UIVIEW KONTROLER



/////////////////////// Ekstenzija da se URL parsuje u UIImageView///////////////////////

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
                var imageToCache = UIImage(data: data!)
                if imageToCache == nil {
                    let imageName = "Klaber.png"
                    imageToCache = UIImage(named: imageName)
                    imageCache.setObject(imageToCache!, forKey: url as AnyObject)
                    self.image = imageToCache
                    print(error as Any)
                    return
                }
                imageCache.setObject(imageToCache!, forKey: url as AnyObject)
                self.image = imageToCache
            }
        }
        task.resume()
    }
}







