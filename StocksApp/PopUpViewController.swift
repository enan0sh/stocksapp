//
//  PopUpViewController.swift
//  StocksApp
//
//  Created by Nahir Gamaliel Haro Sanchez on 9/16/19.
//  Copyright © 2019 Nahir Gamaliel Haro Sanchez. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var symbol : String?
    var isPrimaryDataDone = false
    var isSecundaryDataDone = false
    var currentCompany : Company?

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sectorTextField: UITextField!
    @IBOutlet weak var valueChangeTable: UITableView!
    @IBOutlet weak var loadingOverlay: UIView!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(primaryDataDone), name: Notification.Name.init(rawValue: Utilities.PRIMARY_COMPANY_DATA_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(secundaryDataDone), name: Notification.Name.init(rawValue: Utilities.SECUNDARY_COMPANY_DATA_NOTIFICATION), object: nil)
        
        if self.symbol != nil {
            APIComm.singletonInstace.getDataCompany(withSymbol: self.symbol!)
            loadingOverlay.isHidden = false
            waitingIndicator.startAnimating()
        }
        
        valueChangeTable?.delegate = self
        valueChangeTable?.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let firstTouch : UITouch? = touches.first
        if firstTouch?.view != contentView && firstTouch?.view != loadingOverlay {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func primaryDataDone() {
        self.isPrimaryDataDone = true
        if self.isSecundaryDataDone {
            self.currentCompany = APIComm.singletonInstace.currentCompany
            updateUI()
        }
    }
    
    @objc func secundaryDataDone() {
        self.isSecundaryDataDone = true
        if self.isPrimaryDataDone {
            self.currentCompany = APIComm.singletonInstace.currentCompany
            updateUI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: Utilities.PRIMARY_COMPANY_DATA_NOTIFICATION), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: Utilities.SECUNDARY_COMPANY_DATA_NOTIFICATION), object: nil)
        super.viewWillDisappear(animated)
    }
    
    func updateUI(){
        DispatchQueue.main.async {
            if self.currentCompany != nil {
                self.symbolTextField?.text = self.currentCompany?.symbol
                self.nameTextField?.text = self.currentCompany?.name
                self.sectorTextField?.text = self.currentCompany?.sector
                self.valueChangeTable.reloadData()
                if !self.loadingOverlay.isHidden {
                    self.waitingIndicator.stopAnimating()
                    self.loadingOverlay.isHidden = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentCompany == nil {
            return 0
        } else if currentCompany!.weeklyStockValue == nil {
            return 0
        } else{
            return currentCompany!.weeklyStockValue!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "StockValueCell", for: indexPath)
        if currentCompany != nil {
            if currentCompany!.weeklyStockValue != nil {
                if currentCompany!.weeklyStockValue!.count > 0 {
                    cell.textLabel?.text = currentCompany!.weeklyStockValue![indexPath.item].date
                    cell.detailTextLabel?.text = String(currentCompany!.weeklyStockValue![indexPath.item].value)
                }
            }
        }
        return cell
    }
    
    @IBAction func btnDismissTuchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
