//
//  Contact.swift
//  claber
//
//  Created by ognjen on 1/21/18.
//  Copyright © 2018 Ognjen Tomić. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class Contact: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["gtomicognjen@gmail.com"])
            mail.setSubject("Add my club to your app")
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            whoops()
        }
    }
    
    func whoops () {
        let alert = UIAlertController(title: "Whoops", message: "Something went wrong, we will back soon", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func contactBtn(_ sender: Any) {
        sendEmail()
    }
    
    
}
