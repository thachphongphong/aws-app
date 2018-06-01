//
//  ViewController.swift
//  aws-app
//
//  Created by Linh Do on 5/22/18.
//  Copyright © 2018 Linh Do. All rights reserved.
//

//
//  ViewController.swift
//  aws-app
//
//  Created by Linh Do on 5/22/18.
//  Copyright © 2018 Linh Do. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, ApiDelegate {
    
//    var API = "http://192.168.79.83:5000/api/v1.0/";
    var API = "http://iothome.ddns.net/api/v1.0/";

    // Reference to UIButton in Storyboard
    @IBOutlet var valveButton: UIButton!
    @IBOutlet var lightButton: UIButton!
    @IBOutlet var fanButton: UIButton!

    @IBAction func valveButton(_ sender: UIButton) {
        Alamofire.request(API + "valve" , method: .post).responseString { response in
            switch response.result {
            case .success(let value):
                print(response)
                
                sender.setImage((value == "on") ? #imageLiteral(resourceName: "valve") : #imageLiteral(resourceName: "valve-off"), for: .normal)
                break
            case .failure(let error):

                print(error)
            }
        }
        
    }
    
    @IBAction func lightButton(_ sender: UIButton) {
        Alamofire.request(API + "light", method: .post).responseString { response in
            switch response.result {
            case .success(let value):
                print(response)
                
                sender.setImage((value == "on") ? #imageLiteral(resourceName: "light") : #imageLiteral(resourceName: "light-off"),for: .normal)
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
    }
    
    @IBAction func fanButton(_ sender: UIButton) {
        Alamofire.request(API + "fan", method: .post).responseString { response in
            switch response.result {
            case .success(let value):
                print(response)
                sender.setImage((value == "on") ? #imageLiteral(resourceName: "fan"): #imageLiteral(resourceName: "fan-off"), for: .normal)
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingViewController"{
            let vc = segue.destination as! SettingViewController
            vc.delegate = self
        }
    }
    
    
    func onApiChange(controller: SettingViewController, api: String) {
        API = api;
        loadButtonStats()
    }
    
    
    @IBAction func showSetting(_ sender: Any) {
        UIView.setAnimationsEnabled(false)
        self.performSegue(withIdentifier: "SettingViewController"
            , sender: self)
    }
    
    func loadButtonStats()  {
        print("Load devices status")
        Alamofire.request(API + "status", method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let data = value as? [String : String]
//                print(data)
                self.valveButton.setImage((data!["valve"] == "on") ? #imageLiteral(resourceName: "valve") : #imageLiteral(resourceName: "valve-off"), for: .normal)
                self.lightButton.setImage((data!["light"] == "on") ? #imageLiteral(resourceName: "light") : #imageLiteral(resourceName: "light-off"),for: .normal)
                self.fanButton.setImage((data!["fan"] == "on") ? #imageLiteral(resourceName: "fan"): #imageLiteral(resourceName: "fan-off"), for: .normal)
                break
                
            case .failure(let error):
                
                print(error)
            }
        }
    }


    
//    func setApi(_ URL: String) -> String{
//        loadButtonStats()
//        return API
//    }
    
//    // MARK: Deleage TextFiled
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: nil)
        
    }
    
    @objc func applicationDidBecomeActive(_ note: Notification) {
        loadButtonStats()
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

}

