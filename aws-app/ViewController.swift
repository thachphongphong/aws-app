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
import SocketIO

class MainViewController: UIViewController, ApiDelegate {
    
    static var DEBUG_HOST = "http://localhost:5000";
    static var PI_HOST = "http://192.168.1.100";
    static var IOT_HOST = "http://iotgcloud.ddns.net";
    
    var API_URL: String!;
    var SOCKET_URL: String!;
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
    let sessionManager = SessionManager();
    
    var resetAck: SocketAckEmitter?
    
    func initAPI(){
        self.API_URL = MainViewController.IOT_HOST + "/api/v1.0/";
        self.SOCKET_URL = MainViewController.IOT_HOST;
        self.manager = SocketManager(socketURL: URL(string: self.SOCKET_URL)!, config: [.log(true), .reconnects(true)]);
    }
    
    @IBAction func valveButton(_ sender: UIButton) {
        sessionManager.request(API_URL + VALVE_ID1 , method: .post).responseString { response in
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
        sessionManager.request(API_URL + LIGHT_ID1, method: .post).responseString { response in
            switch response.result {
            case .success(let value):
                sender.setImage((value == "on") ? #imageLiteral(resourceName: "light") : #imageLiteral(resourceName: "light-off"),for: .normal)
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
    }
    
    @IBAction func light2Button(_ sender: UIButton) {
        sessionManager.request(API_URL + LIGHT_ID2, method: .post).responseString { response in
            switch response.result {
            case .success(let value):
                print(response)
                sender.setImage((value == "on") ? #imageLiteral(resourceName: "light2"): #imageLiteral(resourceName: "light2-off"), for: .normal)
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
        self.API_URL = api + "/api/v1.0/";
        self.SOCKET_URL = api;
        self.manager = SocketManager(socketURL: URL(string: self.SOCKET_URL)!, config: [.log(true), .reconnects(true)]);
        loadButtonStats()
    }
    
    
    @IBAction func showSetting(_ sender: Any) {
        UIView.setAnimationsEnabled(false)
        self.performSegue(withIdentifier: "SettingViewController"
            , sender: self)
    }
    
    func loadButtonStats()  {
        print("Load devices status")
        sessionManager.request(API_URL + "status", method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let data = value as? [String]
                self.valveButton.setImage((data![2] == "on") ? #imageLiteral(resourceName: "valve") : #imageLiteral(resourceName: "valve-off"), for: .normal)
                self.lightButton.setImage((data![0] == "on") ? #imageLiteral(resourceName: "light") : #imageLiteral(resourceName: "light-off"),for: .normal)
                self.light2Button.setImage((data![1] == "on") ? #imageLiteral(resourceName: "light2"): #imageLiteral(resourceName: "light2-off"), for: .normal)
                break
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    
    //    // MARK: Deleage TextFiled
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        self.view.endEditing(true)
    //        return true
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAPI();
        //socket
        self.socket = manager.defaultSocket;
        self.setSocketEvents();
        self.socket.connect();
        self.loadButtonStats();
        
        sessionManager.adapter = AccessTokenAdapter(accessToken: "hWd3uNMVpjaRAbPs9Nt3");
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: nil)
        
    }
    
    @objc func applicationDidBecomeActive(_ note: Notification) {
        loadButtonStats()
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

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
//        if urlRequest.urlString.hasPrefix("https://httpbin.org") {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//        }
        
        return urlRequest
    }
}

