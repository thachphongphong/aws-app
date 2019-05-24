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

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var manager:SocketManager!
    var socket:SocketIOClient!
    var resetAck: SocketAckEmitter?
    
    var devices:[Device] = [];
    
    //    var estimateWidth = 100.0
    var cellMarginSize = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //socket
        self.manager = SocketManager(socketURL: URL(string: K.ProductionServer.baseURL)!, config: [.log(true), .reconnects(true)]);
        self.socket = manager.defaultSocket;
        self.setSocketEvents();
        self.socket.connect();
        
        // Register Cell
        self.collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        //Setup Grid view
        self.setupGridView()
        
        // Load devices
        self.loadDevices()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    fileprivate func updateDeviceStatus(devices:([Device]), status: ([Status])) {
        let map = status.reduce([String: Int]()) { (dict, s) -> [String: Int] in
            var dict = dict
            dict[s.devId] = s.status
            return dict
        }
        for d in devices {
            let keyExists = map[d.devId!] != nil
            if keyExists {
                d.status = map[d.devId!] ?? 0
            }
        }
        self.devices = devices;
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func loadDevices (){
        APIClient.getDevices{result in
            switch result {
            case .success(let devices):
                if(!devices.isEmpty){
                    APIClient.getAllStatus{result in
                        switch result {
                        case .success(let status):
                            self.updateDeviceStatus(devices: devices, status: status)
                            
                        case .failure(let error):
                            print("__________ERROR___________________")
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                print("__________ERROR___________________")
                print(error.localizedDescription)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "SettingViewController"{
    //            let vc = segue.destination as! SettingViewController
    //            vc.delegate = self
    //        }
    //    }
    
    
    //    func onApiChange(controller: SettingViewController, api: String) {
    //        loadButtonStats()
    //    }
    
    
    @IBAction func showSetting(_ sender: Any) {
        UIView.setAnimationsEnabled(false)
        self.performSegue(withIdentifier: "SettingViewController"
            , sender: self)
    }
    
    func loadButtonStats()  {
        APIClient.getAllStatus{result in
            switch result {
            case .success(let status):
                self.updateDeviceStatus(devices: self.devices, status: status)
            case .failure(let error):
                print("__________ERROR___________________")
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func applicationDidBecomeActive(_ note: Notification) {
        //  loadButtonStats()
    }
    
    func setSocketEvents() {
        self.socket.on(clientEvent: .connect){data, ack in
            print("IOT socket connected");
        }
        
        self.socket.on("mqtt_message") {data, ack in
            self.loadButtonStats();
        }
        
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.setData(device: self.devices[indexPath.row])
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderWidth = 0.1
        cell.contentView.layer.borderColor = UIColor.init(red: 15, green: 156, blue: 230, alpha: 0.15).cgColor
        
        cell.layer.shadowColor = UIColor.init(red: 15, green: 156, blue: 230, alpha: 0.05).cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell.layer.shadowOpacity = 0.03
        cell.layer.shadowRadius = 10
        cell.layer.masksToBounds = false
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: cell.bounds.width-10, height: cell.bounds.height-10))
        cell.layer.shadowPath = shadowPath.cgPath
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.subscribeButtonAction = { [unowned self] in
            let device = self.devices[indexPath.row]
            let status = cell.deviceSwitch.isOn ? 1 : 0;
            APIClient.switchDevice(devId: device.devId!, status: status, completion: {_ in });
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let width = self.calculateWith()
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: width/4)
        
    }
    
    //    func calculateWith() -> CGFloat {
    //        let estimatedWidth = CGFloat(estimateWidth)
    //        let cellCount = floor(CGFloat(self.view.frame.size.width/estimatedWidth))
    //        let margin = CGFloat(cellMarginSize * 2)
    //        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
    //        return width
    //    }
}
