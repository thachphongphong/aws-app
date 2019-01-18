//
//  UI+Extension.swift
//  WhiteFox
//
//  Created by Tuong Dang on 5/2/18.
//  Copyright © 2018 AAVN. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerAlerting { }

extension ViewControllerAlerting where Self: UIViewController {

    func showErrorAlert(title: String,
                        message: String,
                        buttonTitle: String = "OK",
                        buttonStyle: UIAlertAction.Style = .default,
                        preferredStyle: UIAlertController.Style = .alert,
                        action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: buttonTitle, style: buttonStyle, handler: { _ in
            action?()
        }))
        present(alert, animated: true, completion: nil)
    }

    func showConfirmActionAlert(title: String,
                                message: String,
                                buttonTitle: String,
                                buttonStyle: UIAlertAction.Style,
                                cancelAction: (() -> Void)? = nil,
                                action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: buttonStyle, handler: { _ in
            action()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            cancelAction?()
        }))
        present(alert, animated: true, completion: nil)
    }

    func handleNetworkFailure(title: String, message: String? = nil, cancelAction: (() -> Void)? = nil, retryAction: @escaping () -> Void) {
        // Show error by confirming the deletion again but showing an
        // error message and "retry" button instead
        showConfirmActionAlert(title: title,
                               message: message ?? "There was a problem and your changes could not be uploaded",
                               buttonTitle: "Retry",
                               buttonStyle: .default, cancelAction: cancelAction) {
            retryAction()
        }
    }

}
