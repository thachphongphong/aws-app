//
//  SettingViewController.swift
//  aws-app
//
//  Created by Linh Do on 5/28/18.
//  Copyright © 2018 Linh Do. All rights reserved.
//

import UIKit
import Alamofire

class SettingViewController: UIViewController, ViewControllerAlerting {
    
    weak var delegate:ApiDelegate?
    @IBOutlet weak var networkSwitch: UISwitch!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    // get a session manager and add the request adapter
    let sessionManager = SessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionManager.adapter = AccessTokenAdapter(accessToken: "hWd3uNMVpjaRAbPs9Nt3");
        let prefs = Preferences.shared
        
        // update UI
        networkSwitch.isOn = prefs.isLocalNetwork
//        loadAutoStats()
    }

    @IBAction func mode(_ mode: UISwitch) {
//        Alamofire.request(api + "mode", method: .post).responseString { response in
//            switch response.result {
//            case .success(_):
//                print(response)
//                Preferences.shared.isAutoMode = mode.isOn
//                break
//            case .failure(let error):
//
//                print(error)
//            }
//        }
    }
    
    @IBAction func network(_ mode: UISwitch) {
        if(mode.isOn){
            checkApi(MainViewController.PI_HOST, m: true)
        }else{
            checkApi(MainViewController.IOT_HOST, m: false)
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
        
        var request = URLRequest(url: NSURL.init(string: url+"/api/v1.0/status")! as URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 3 // 10 secs
        sessionManager.request(request).responseString { response in
            switch response.result {
            case .success(let value):
                activityIndicator.removeFromSuperview()
                if (value == "working"){
                    self.showConfirmActionAlert(title: "API available",
                                                message: "Do you want to API ?",
                                                buttonTitle: "Use",
                                                buttonStyle: .destructive, cancelAction: nil) {
                                                    self.delegate?.onApiChange(controller: self, api: url)
                                                }
                }
                break
            case .failure( _):
                activityIndicator.removeFromSuperview()
                self.showAlert()
                self.networkSwitch.setOn(!m, animated: true)
                Preferences.shared.isLocalNetwork = self.networkSwitch.isOn
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Cannot connect API", message: "Maybe public Ip is changed.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
//    func loadAutoStats()  {
//        print("Load auto status")
//        Alamofire.request(api + "mode", method: .get).responseString { response in
//            switch response.result {
//            case .success(let value):
//                print(value)
//                if (value == "AUTO"){
//                    self.modeSwitch.setOn(true, animated: false)
//                    Preferences.shared.isAutoMode = true
//                }else{
//                    self.modeSwitch.setOn(false, animated: false)
//                    Preferences.shared.isAutoMode = false
//                }
//                break
//                
//            case .failure(let error):
//                
//                print(error)
//            }
//        }
//    }
}

protocol ApiDelegate: class
{
    func onApiChange(controller:SettingViewController, api: String)
}
