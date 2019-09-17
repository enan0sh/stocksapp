//
//  SearchViewController.swift
//  StocksApp
//
//  Created by Nahir Gamaliel Haro Sanchez on 9/17/19.
//  Copyright © 2019 Nahir Gamaliel Haro Sanchez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var symbol: String?
    
    
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var lblSearching: UILabel!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Search"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(symbolNotFound), name: Notification.Name.init(rawValue: Utilities.SYMBOL_NOT_FOUND_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(symbolFound), name: Notification.Name.init(rawValue: Utilities.SYMBOL_FOUND_NOTIFICATION), object: nil)
        super.viewWillAppear(animated)
    }
    

    @IBAction func btnSearchTouchUp(_ sender: Any) {
        symbol = symbolTextField.text
        APIComm.singletonInstace.existSymbol(symbol!)
        waitingIndicator.isHidden = false
        waitingIndicator.startAnimating()
        lblSearching.isHidden = false
    }
    
    @objc func symbolFound(){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "popUp") as! PopUpViewController
        viewController.symbol = symbol
        DispatchQueue.main.async {
            self.waitingIndicator.isHidden = true
            self.waitingIndicator.stopAnimating()
            self.lblSearching.isHidden = true
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func symbolNotFound(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Not found", message: "The Symbol wasn't found, please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                
            }))
            self.present(alert, animated: true, completion: nil)
            self.waitingIndicator.isHidden = true
            self.waitingIndicator.stopAnimating()
            self.lblSearching.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: Utilities.SYMBOL_NOT_FOUND_NOTIFICATION), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: Utilities.SYMBOL_FOUND_NOTIFICATION), object: nil)
        super.viewWillDisappear(animated)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
