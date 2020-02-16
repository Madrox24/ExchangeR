//
//  UIViewController+Extension.swift
//  ExchangeR
//
//  Created by Robert Moryson on 16/02/2020.
//  Copyright © 2020 Robert Moryson. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
