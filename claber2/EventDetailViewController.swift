//
//  EventDetailViewController.swift
//  claber2
//
//  Created by Ognjen Tomić on 6/9/17.
//  Copyright © 2017 Ognjen Tomić. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    
    //promenljive za prenos podataka iz ViewControllera
    
    var slika:String? //proveriti da li je mozda UIImage
    var datum:String?
    var vreme:String?
    var dogadjaj:String?
    var mesto: String?
    var opis:String?
    var date:String?
    
    
    
    //Outleti
    
    @IBOutlet weak var eventImageOutlet: UIImageView!
    @IBOutlet weak var visualOutlet: UIVisualEffectView!
    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var dogadjajOutlet: UITextView!
    @IBOutlet weak var mestoOutlet: UILabel!
    @IBOutlet weak var opisOutlet: UITextView!
    @IBOutlet weak var titleOutlet: UINavigationItem!
    @IBOutlet weak var containerOutlet: UIView!
    @IBOutlet weak var timeOutlet: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.8, animations: {
            self.eventImageOutlet.alpha = 1
            self.visualOutlet.alpha = 1
            self.dateOutlet.alpha = 1
            self.dogadjajOutlet.alpha = 1
            self.mestoOutlet.alpha = 1
            self.opisOutlet.alpha = 1
            self.containerOutlet.alpha = 1
            self.timeOutlet.alpha = 1
        })
    }
 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ubacivanjePodataka()
            self.eventImageOutlet.alpha = 0
            self.visualOutlet.alpha = 0
            self.dateOutlet.alpha = 0
            self.dogadjajOutlet.alpha = 0
            self.mestoOutlet.alpha = 0
            self.opisOutlet.alpha = 0
            self.containerOutlet.alpha = 0
            self.timeOutlet.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        self.opisOutlet.setContentOffset(.zero, animated: false)
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "masterSegvej" {
//            let eventVC = segue.destination as! UINavigationController
//            let svc = eventVC.topViewController as! EventDetailViewController
//            svc.dogadjaj = dayArray[indexPath.row].event
//            svc.mesto = dayArray[indexPath.row].place
//            svc.opis = self.dayArray[indexPath.row].desc
//            svc.date = self.dayArray[indexPath.row].date
//            svc.slika = self.dayArray[indexPath.row].imageUrl
//
//        }
//    }
//
    
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rewind" {
            let eventVC = segue.destination as! UINavigationController
            let vc = eventVC.topViewController as! ViewController
            vc.returnDate = convertDateFormater(date!)
        }
    }
    
    
    
    func ubacivanjePodataka() {
        dogadjajOutlet.text = dogadjaj
        mestoOutlet.text = mesto
        opisOutlet.text = opis
        eventImageOutlet.downloadImage(from: slika!)
        dateOutlet.text = "Date: \(convertDateFormater(date!))"
        timeOutlet.text = "Event starts: \(convertTimeFormater(date!))"
    }

}
