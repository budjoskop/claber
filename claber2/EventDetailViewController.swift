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
    @IBOutlet weak var dogadjajOutlet: UILabel!
    @IBOutlet weak var mestoOutlet: UILabel!
    @IBOutlet weak var opisOutlet: UITextView!
    @IBOutlet weak var titleOutlet: UINavigationItem!
    @IBOutlet weak var containerOutlet: UIView!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ubacivanjePodataka()
       
        
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
        titleOutlet.title = dogadjaj
        dateOutlet.text = "Date: \(date!)"
    }

}
