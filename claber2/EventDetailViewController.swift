//
//  EventDetailViewController.swift
//  claber2
//
//  Created by Ognjen Tomić on 6/9/17.
//  Copyright © 2017 Ognjen Tomić. All rights reserved.
//

import UIKit
import EventKit

class EventDetailViewController: UIViewController {
    
    
    //promenljive za prenos podataka iz ViewControllera
    
    var slika:String? 
    var datum:String?
    var vreme:String?
    var dogadjaj:String?
    var mesto: String?
    var opis:String?
    var date:String?
    var dateAction: String?
    var eventId: String?
    var eventPhone: String?
    var address:String?
    var clubImage:String?
    var latitudeClub:String?
    var longitudeClub: String?
    var latitudeDouble: Double?
    var longitudeDouble: Double?
    
    
    //Outleti
    
    @IBOutlet weak var eventImageOutlet: UIImageView!
    @IBOutlet weak var visualOutlet: UIVisualEffectView!
    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var dogadjajOutlet: UITextView!
    //@IBOutlet weak var mestoOutlet: UILabel!
    @IBOutlet weak var mestoOutlet: UIButton!
    @IBOutlet weak var opisOutlet: UITextView!
    @IBOutlet weak var titleOutlet: UINavigationItem!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var phoneOutlet: UIBarButtonItem!
    @IBOutlet weak var locationOutlet: UIBarButtonItem!
    @IBOutlet weak var toolBarOutlet: UIToolbar!
    @IBOutlet weak var shareOutlet: UIBarButtonItem!
    @IBOutlet weak var saveEventOutlet: UIBarButtonItem!
    
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ubacivanjePodataka()
        title = mesto
        self.navigationController?.navigationBar.tintColor = UIColor.black
        checkPhoneString()
        checkLongitudeLatidude()
        self.saveEventOutlet.width = self.view.bounds.width / 4
        self.shareOutlet.width = self.view.bounds.width / 4
        self.phoneOutlet.width = self.view.bounds.width / 4
        self.locationOutlet.width = self.view.bounds.width / 4
    }
    
    override func viewDidLayoutSubviews() {
        self.opisOutlet.setContentOffset(.zero, animated: false)
    }
    
    
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MM/yy"
        return  dateFormatter.string(from: date!)
    }
    
    func convertTimeFormater(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = dateFormatter.date(from: self.date!)
        dateFormatter.dateFormat = "HH:mm"
        return  dateFormatter.string(from: time!)
    }
    
    
    func checkPhoneString () {
        if eventPhone != "" {
            phoneOutlet.isEnabled = true
            } else {
            phoneOutlet.isEnabled = false
        }
    }
    
    @IBAction func phoneBtn(_ sender: Any) {
        
            guard let url = URL(string: "tel://\(eventPhone!)") else {
                return //be safe
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
    }
    

    @IBAction func saveEventBtn(_ sender: Any) {
        displayAlert()
    }
    
    
    func displayAlert () {
        let alert = UIAlertController(title: "Save event?", message: "Do you want to add this event to your calendar", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) -> Void in self.saveEvent()}))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveEvent () {
        dateAction  = date
        let eventStore: EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) {(granted, error) in
            if (granted) && (error == nil) {
                print ("Granted \(granted)")
                print ("Error \(String(describing: error))")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateCalendar = dateFormatter.date(from: self.dateAction!)
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.dogadjaj
                event.startDate = dateCalendar
                event.endDate = dateCalendar
                event.notes = self.opis
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError{
                    print("error: \(error)")
                }
                print ("Save Event")
            } else {
                print ("Error: \(String(describing: error))")
            }
        }
    }
    
    
    func checkLongitudeLatidude () {
        if (longitudeClub != nil) && (latitudeClub != nil) {
            locationOutlet.isEnabled = true
            latitudeDouble = Double("\(latitudeClub!)") ?? 44.7866
            longitudeDouble = Double("\(longitudeClub!)") ?? 20.4489
        } else {
            locationOutlet.isEnabled = false
        }
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }

    @IBAction func shareBtn(_ sender: Any) {
        displayShareSheet(shareContent: "http://www.facebook.com/\(eventId!)")
    }
    
    func ubacivanjePodataka() {
        dogadjajOutlet.text = dogadjaj
        let yourAttributes : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: "\(mesto!)", attributes: yourAttributes)
        mestoOutlet.setAttributedTitle(attributeString,for: .normal)
        opisOutlet.text = opis
        eventImageOutlet.downloadImage(from: slika!)
        dateOutlet.text = "Date: \(convertDateFormater(date!))"
        timeOutlet.text = "Event starts: \(convertTimeFormater(date!))"
    }
    
    @IBAction func openLinkBtn(_ sender: Any) {
        guard let url = URL(string: "http://www.facebook.com/\(eventId!)") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "map" {
                let svc = segue.destination as! MapController
                svc.clubName = mesto
                svc.clubAdress = mesto
                svc.clubAdress = address
                svc.longitude = longitudeDouble
                svc.latitude = latitudeDouble
            }
        }
    
    
}
