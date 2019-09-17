//
//  TopGainViewController.swift
//  StocksApp
//
//  Created by Nahir Gamaliel Haro Sanchez on 9/16/19.
//  Copyright © 2019 Nahir Gamaliel Haro Sanchez. All rights reserved.
//

import UIKit

class TopGainViewController: UITableViewController {
    
    private let MAX_COMPENIES_SIZE = 10
    private var topGainCompanies: [Company]?
    private var refreshControlOverride = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIComm.singletonInstace.updateTopGainers(withLimit: MAX_COMPENIES_SIZE)
        
        tableView.refreshControl = refreshControlOverride
        self.navigationItem.title = "Top Gainers"
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(dataUpdated), name: NSNotification.Name.init(rawValue: Utilities.DATA_UPDATE_NOTIFICATION), object: nil)
        refreshControlOverride.addTarget(self, action: #selector(pullNewDataFromAPI), for: .valueChanged)
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if topGainCompanies != nil {
            return topGainCompanies!.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCellItem", for: indexPath)
        if topGainCompanies != nil {
            cell.textLabel?.text = topGainCompanies![indexPath.item].symbol
            cell.detailTextLabel?.text = topGainCompanies![indexPath.item].name
        }
        // Configure the cell...

        return cell
    }
    
    @objc func dataUpdated(){
        topGainCompanies = APIComm.singletonInstace.getTopGainers(withLimit: MAX_COMPENIES_SIZE)
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @objc func pullNewDataFromAPI(){
        APIComm.singletonInstace.updateTopGainers(withLimit: MAX_COMPENIES_SIZE)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: Utilities.DATA_UPDATE_NOTIFICATION), object: nil)
        refreshControlOverride.removeTarget(self, action: #selector(pullNewDataFromAPI), for: .valueChanged)
        super.viewWillDisappear(animated)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "popUp") as! PopUpViewController
        viewController.symbol = self.topGainCompanies?[indexPath.item].symbol
        self.present(viewController, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
