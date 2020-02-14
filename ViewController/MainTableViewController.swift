//
//  MainTableViewController.swift
//  ExchangeR
//
//  Created by Robert Moryson on 11/02/2020.
//  Copyright © 2020 Robert Moryson. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var tableSegmentControl: UISegmentedControl!
    @IBOutlet weak var updatedLabel: UILabel!
    
    var currencyTable: [Table] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        getDataFromTable(type: "A")
    }
    
    @IBAction func didTapSegmentController(_ sender: Any) {
        let index = tableSegmentControl.selectedSegmentIndex
        
        switch index {
        case 0:
            getDataFromTable(type: "A")
        case 1:
            getDataFromTable(type: "B")
        case 2:
            getDataFromTable(type: "C")
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "currencyDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! CurrencyTableViewController
                
                destinationController.navigationBar.tit
            }
        }
    }
    

    // MARK: - Table view

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currencyTable.count == 0 {
            return 0
        } else {
            return currencyTable[0].rates.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        updatedLabel.text = "Last updated: \(currencyTable[0].effectiveDate)"
        
        let rates = currencyTable[0].rates[indexPath.row]
        let index = tableSegmentControl.selectedSegmentIndex
        if index != 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentAB", for: indexPath) as! SegmentABTableViewCell
            cell.name.text = rates.currency.firstUppercased
            cell.code.text = rates.code
            cell.midValue.text = "1 \(rates.code) = \(rates.mid!) zł"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentC", for: indexPath) as! SegmentCTableViewCell
            cell.name.text = rates.currency.firstUppercased
            cell.code.text = rates.code
            cell.bidLabel.text = "Bid: \(rates.bid!) zł"
            cell.askLabel.text = "Ask: \(rates.ask!) zł"
            return cell
        }
        
    }


}

extension MainTableViewController {
    
    func getDataFromTable(type: String) {
        
        let url = URL(string: "http://api.nbp.pl/api/exchangerates/tables/\(type)")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }

            do {
                let decoder = JSONDecoder()
                let table = try decoder.decode([Table].self, from: data)
                print(table)
                
                DispatchQueue.main.async {
                    self.currencyTable = table
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print(error)
            }

        }).resume()
        
    }

}

extension MainTableViewController {
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {

        switch tableSegmentControl.selectedSegmentIndex {
        case 0:
            self.getDataFromTable(type: "A")
        case 1:
            self.getDataFromTable(type: "B")
        case 2:
            self.getDataFromTable(type: "C")
        default:
            break
        }
        
        self.refreshControl?.endRefreshing()
    }
    
}
