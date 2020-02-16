//
//  MainTableViewController.swift
//  ExchangeR
//
//  Created by Robert Moryson on 11/02/2020.
//  Copyright © 2020 Robert Moryson. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var tableSegmentControl: UISegmentedControl! //przejście pomiędzy tablicami A, B, C
    @IBOutlet weak var whenUpdatedLabel: UILabel! //wyświetla informację kiedy pobrano dane
    
    var currencyTable: [Table] = [] //lista wszystkich pobranych walut z serwera
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        getDataFromTable(type: "A")
    }
    
    //pobranie odpowiednich danych z serwera w zależności od wybranego segmentu.
    //3 możliwe tablice - A, B, C
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

        //przekazanie nazwy oraz kodu waluty wraz z rodzajem tablicy, z której pochodzi waluta do następnego VC
        if segue.identifier == "currencyDetailsTableAB" || segue.identifier == "currencyDetailsTableC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! CurrencyTableViewController
                
                destinationController.currencyCode = currencyTable[0].rates[indexPath.row].code
                destinationController.currencyName = currencyTable[0].rates[indexPath.row].currency.firstUppercased
                destinationController.tableLetter = currencyTable[0].table
            }
        }
    }
    

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //początkowo tablica jest pusta, dopiero po pobraniu elementów możemy skorzystać z currencyTable[0].rates.count
        if currencyTable.count == 0 {
            return 0
        } else {
            return currencyTable[0].rates.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        whenUpdatedLabel.text = "Last updated: \(currencyTable[0].effectiveDate)"
        
        let rates = currencyTable[0].rates[indexPath.row]
        let index = tableSegmentControl.selectedSegmentIndex
        
        //index 0 i 1 odpowiada tablicy A oraz B
        //index 2 odpowiada tablicy C
        if index != 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentAB", for: indexPath) as! SegmentABTableViewCell
            cell.name.text = rates.currency.firstUppercased
            cell.code.text = rates.code
            cell.midValue.text = "1 \(rates.code) = \(rates.mid!) PLN"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentC", for: indexPath) as! SegmentCTableViewCell
            cell.name.text = rates.currency.firstUppercased
            cell.code.text = rates.code
            cell.bidLabel.text = "Bid: \(rates.bid!) PLN"
            cell.askLabel.text = "Ask: \(rates.ask!) PLN"
            return cell
        }
        
    }
    
    // MARK: - Downloading from server
    
    func getDataFromTable(type: String) {
        
        let url = URL(string: "http://api.nbp.pl/api/exchangerates/tables/\(type)")
        
        showLoadingSpinner()
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }

            do {
                let decoder = JSONDecoder()
                let table = try decoder.decode([Table].self, from: data)
                print(table)
                
                DispatchQueue.main.async {
                    //odświeżenie tablicy nastąpi dopiero po całkowitym pobraniu danych z serwera
                    self.currencyTable = table
                    self.tableView.reloadData()
                    
                    //zamknięcie okna ładowania
                    if let vc = self.presentedViewController, vc is UIAlertController { self.dismiss(animated: false, completion: nil) }
                }
            } catch let error {
                print(error)
            }
        }).resume()
    }
    
    // MARK: - Refresh Control
    
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
