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
    let LOCAL_URL = "http://192.168.1.100/api/v1.0/";
    let API_URL = "http://iothome.ddns.net/api/v1.0/"
    @IBOutlet weak var networkSwitch: UISwitch!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    var api = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs = Preferences.shared
        
        api = API_URL
        
        // update UI
        networkSwitch.isOn = prefs.isLocalNetwork
        modeSwitch.isOn = prefs.isAutoMode
    }

    @IBAction func mode(_ mode: UISwitch) {
        Alamofire.request(api + "mode", method: .post).responseString { response in
            switch response.result {
            case .success(_):
                print(response)
                Preferences.shared.isAutoMode = mode.isOn
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    @IBAction func network(_ mode: UISwitch) {
        if(mode.isOn){
            checkApi(LOCAL_URL, m: true)
//            api = LOCAL_URL
        }else{
            checkApi(API_URL, m: false)
//            api = API_URL
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
        
        var request = URLRequest(url: NSURL.init(string: url)! as URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 3 // 10 secs
        Alamofire.request(request).responseString { response in
            switch response.result {
            case .success(let value):
                activityIndicator.removeFromSuperview()
                if (value == "working"){
                    self.showConfirmActionAlert(title: "API available",
                                                message: "Do you want to API ?",
                                                buttonTitle: "Use",
                                                buttonStyle: .destructive, cancelAction: nil) {
                                                    self.api = url
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
}

protocol ApiDelegate: class
{
    func onApiChange(controller:SettingViewController, api: String)
}
