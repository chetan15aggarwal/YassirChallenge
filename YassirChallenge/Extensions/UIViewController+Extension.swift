//
// YassirChallenge
// Created by Chetan Aggarwal.


import UIKit

extension  UIViewController {
    func showAlert(withTitle title: String,
                          andMessage message:String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
