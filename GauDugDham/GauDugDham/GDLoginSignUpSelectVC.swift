//
//  GDLoginSignUpSelectVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 06/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit

class GDLoginSignUpSelectVC: UIViewController {

   // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers

    @IBAction func goToLoginPage(_ sender: Any) {
        let vc : GDLoginVC = GDLoginVC()
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func goToRegisterPage(_ sender: Any) {
        let vc : GDRegisterVC = GDRegisterVC()
        self.present(vc, animated: true, completion: nil)
    }

}
