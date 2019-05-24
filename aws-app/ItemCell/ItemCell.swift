//
//  ItemCell.swift
//  aws-app
//
//  Created by Linh Do on 5/17/19.
//  Copyright © 2019 Linh Do. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var deviceSwitch: UISwitch!
    
    /*
     No need to keep track the index since we are using closure to store the function that will be executed when user tap on it.
     */
    
    // the closure, () -> () means take no input and return void (nothing)
    // it is wrapped in another parentheses outside in order to make the closure optional
    var subscribeButtonAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deviceSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75);
        // Add action to perform when the button is tapped
        self.deviceSwitch.addTarget(self, action: #selector(onSwitchChange(_:)), for: .touchUpInside)
    }
    
    func setData(device: Device) {
        self.name.text = device.name
        switch device.icon {
        case "light":
            self.icon.image = device.status == 1 ? UIImage(named: "bulb_on") : UIImage(named: "bulb")
        case "hydroponic":
            self.icon.image = device.status == 1 ? UIImage(named: "hydro_on") : UIImage(named: "hydro")
        case "valve":
            self.icon.image = device.status == 1 ? UIImage(named: "valve_on") : UIImage(named: "valve")
        default:
            self.icon.image = device.status == 1 ? UIImage(named: "bulb_on") : UIImage(named: "bulb")
        }
        self.deviceSwitch.setOn(device.status == 1, animated: false)
    }
    
    @IBAction func onSwitchChange(_ sender: UISwitch) {
        subscribeButtonAction?()
    }
}
