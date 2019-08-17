//
//  ViewController.swift
//  TargetAIScanner
//
//  Created by Owais Raza on 8/17/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func Camera(_ sender: Any) {
        performSegue(withIdentifier: "showPhoto_Segue", sender: nil)
    }
    
}

