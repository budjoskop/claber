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
    
    
    //OUTLETI
    @IBOutlet var tableViewOutlet: UIView!
    
      
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Obavezni metodi za TABELU
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 80
        
        
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath)
        
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
    
    
    
}
