//
//  ViewController.swift
//  aws-app
//
//  Created by Linh Do on 5/22/18.
//  Copyright © 2018 Linh Do. All rights reserved.
//

import UIKit
import Alamofire
import SocketIO

class MainViewController: UIViewController, ApiDelegate {
    
    var manager:SocketManager!
    var socket:SocketIOClient!
    
    var LIGHT_ID1 = "sonoff1";
    var LIGHT_ID2 = "sonoff2";
    var VALVE_ID1 = "sonoff-valve";
    
    // Reference to UIButton in Storyboard
    @IBOutlet var valveButton: UIButton!
    @IBOutlet var lightButton: UIButton!
    @IBOutlet var light2Button: UIButton!
    
    // get a session manager and add the request adapter
//    let sessionManager = SessionManager();
    
    var resetAck: SocketAckEmitter?
    
    @IBAction func valveButton(_ sender: UIButton) {
        APIClient.switchDevice(devId: VALVE_ID1){result in
            switch result {
            case .success(let status):
                print("_____________________________")
                print(status)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func lightButton(_ sender: UIButton) {
//        sessionManager.request(API_URL + LIGHT_ID1, method: .post).responseString { response in
//            switch response.result {
//            case .success(let value):
//                sender.setImage((value == "on") ? #imageLiteral(resourceName: "light") : #imageLiteral(resourceName: "light-off"),for: .normal)
//                break
//            case .failure(let error):
//
//                print(error)
//            }
//        }
        
    }
    
    @IBAction func light2Button(_ sender: UIButton) {
//        sessionManager.request(API_URL + LIGHT_ID2, method: .post).responseString { response in
//            switch response.result {
//            case .success(let value):
//                print(response)
//                sender.setImage((value == "on") ? #imageLiteral(resourceName: "light2"): #imageLiteral(resourceName: "light2-off"), for: .normal)
//                break
//            case .failure(let error):
//
//                print(error)
//            }
//        }
        
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
        loadButtonStats()
    }
    
    
    @IBAction func showSetting(_ sender: Any) {
        UIView.setAnimationsEnabled(false)
        self.performSegue(withIdentifier: "SettingViewController"
            , sender: self)
    }
    
    func loadButtonStats()  {
        APIClient.getAllStatus{result in
            switch result {
            case .success(let status):
                print("__________SUCCESS_________________")
                for s in status{
                    if (s.devId == self.LIGHT_ID1) {
                        self.lightButton.setImage((s.status == 1) ? #imageLiteral(resourceName: "light") : #imageLiteral(resourceName: "light-off"),for: .normal)
                    }
                    if (s.devId == self.LIGHT_ID2) {
                        self.light2Button.setImage((s.status == 1) ? #imageLiteral(resourceName: "light2") : #imageLiteral(resourceName: "light2-off"),for: .normal)
                    }
                    if (s.devId == self.VALVE_ID1) {
                        self.valveButton.setImage((s.status == 1) ? #imageLiteral(resourceName: "valve") : #imageLiteral(resourceName: "valve-off"),for: .normal)
                    }
                }
            case .failure(let error):
                print("__________ERROR___________________")
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //socket
        self.manager = SocketManager(socketURL: URL(string: K.ProductionServer.baseURL)!, config: [.log(true), .reconnects(true)]);
        self.socket = manager.defaultSocket;
        self.setSocketEvents();
        self.socket.connect();
        self.loadButtonStats();
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: nil)
        
    }
    
    @objc func applicationDidBecomeActive(_ note: Notification) {
      //  loadButtonStats()
    }
    
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    
    func setSocketEvents() {
        self.socket.on(clientEvent: .connect){data, ack in
            print("IOT socket connected");
        }
        
        self.socket.on("mqtt_message") {data, ack in
            self.loadButtonStats();
        }
        
    }
    
}

//class AccessTokenAdapter: RequestAdapter {
//    private let accessToken: String
//
//    init(accessToken: String) {
//        self.accessToken = accessToken
//    }
//
//    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
//        var urlRequest = urlRequest
//
////        if urlRequest.urlString.hasPrefix("https://httpbin.org") {
//            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
////        }
//
//        return urlRequest
//    }
//}
//
//struct Resp : Decodable {
//    let data: Any
//}
