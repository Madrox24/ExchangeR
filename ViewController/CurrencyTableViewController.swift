//
//  CurrencyTableViewController.swift
//  ExchangeR
//
//  Created by Robert Moryson on 12/02/2020.
//  Copyright © 2020 Robert Moryson. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
    
    var code: String!
    var currencyName: String!
    var table: String!
    var currencyTable: CurrencyDetails? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = currencyName

        getData(fromDate: "2020-01-20", toDate: "2020-01-25")
    }
    
    func getData(fromDate: String, toDate: String) {
        
        let url = URL(string: "http://api.nbp.pl/api/exchangerates/rates/\(table!)/\(code!)/\(fromDate)/\(toDate)")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }

            do {
                let decoder = JSONDecoder()
                let table = try decoder.decode(CurrencyDetails.self, from: data)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        if let rateDetails = currencyTable?.rates[indexPath.row] {
            cell.textLabel?.text = "1 \(code!) = \(rateDetails.mid) PLN"
            cell.detailTextLabel?.text = rateDetails.effectiveDate
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currency = currencyTable {
            return currency.rates.count
        } else {
            return 0
        }
    }
}
