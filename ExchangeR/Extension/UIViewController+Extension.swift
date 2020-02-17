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
        if let vc = self.presentedViewController, vc is UIAlertController { dismiss(animated: false, completion: nil) }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showLoadingSpinner() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    

}
