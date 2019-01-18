//
//  SettingViewController.swift
//  aws-app
//
//  Created by Linh Do on 5/28/18.
//  Copyright © 2018 Linh Do. All rights reserved.
//

import UIKit
import Alamofire

class SettingViewController: UIViewController {
    
    weak var delegate:ApiDelegate?
    @IBOutlet weak var networkSwitch: UISwitch!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs = Preferences.shared
        
        // update UI
        networkSwitch.isOn = prefs.isLocalNetwork
    }

    @IBAction func mode(_ mode: UISwitch) {

    }
    
    @IBAction func network(_ mode: UISwitch) {
        if(mode.isOn){

        }else{
            
        }
        Preferences.shared.isLocalNetwork = mode.isOn
    }
    
    func checkApi(_ url: String, m: Bool) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        // Add it to the view where you want it to appear
        view.addSubview(activityIndicator)
        // Set up its size (the super view bounds usually)
        activityIndicator.frame = view.bounds
        // Start the loading animation
        activityIndicator.startAnimating()
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Cannot connect API", message: "Maybe public Ip is changed.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}

protocol ApiDelegate: class
{
    func onApiChange(controller:SettingViewController, api: String)
}
