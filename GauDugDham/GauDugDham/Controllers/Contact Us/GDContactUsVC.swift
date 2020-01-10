//
//  GDContactUsVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 13/08/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit

class GDContactUsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button1 = UIBarButtonItem(title :"View Payment Details", style: .plain, target: self, action: #selector(GDContactUsVC.showAccountDetails)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAccountDetails(){
        let alertController = UIAlertController(title: "Payment Details", message: "Back To Roots Marketing Private Limited \n Account Number : 184305000191 \n FSAI : ICIC0001843", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in

        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
