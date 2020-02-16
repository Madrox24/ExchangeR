//
//  CurrencyTableViewController.swift
//  ExchangeR
//
//  Created by Robert Moryson on 12/02/2020.
//  Copyright © 2020 Robert Moryson. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
    
    var currencyCode: String!
    var currencyName: String!
    var tableLetter: String!
    var currencyTable: CurrencyDetails? = nil //lista z całą historią waluty, pobrana z serwera
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
    @IBOutlet weak var startDatePickerView: UIView!
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var endDatePickerView: UIView!
    @IBOutlet weak var endDateLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = currencyName

        prepareDatePickers()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Reload", style: .done, target: self, action: #selector(self.didTapShowResults(_:)))
    }
    
    
    func prepareDatePickers() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        startDatePicker.datePickerMode = .date
        endDatePicker.datePickerMode = .date
        
        startDatePicker.maximumDate = Date()
        endDatePicker.maximumDate = Date()
        
        let startDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDate(_:)))
        startDatePickerView.addGestureRecognizer(startDateTapGesture)
        let endDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDate(_:)))
        endDatePickerView.addGestureRecognizer(endDateTapGesture)
    }
    
    @IBAction func didTapShowResults(_ sender: Any) {

        if startDateLabel.text == "Select date" || endDateLabel.text == "Select date" {
            //gdy nie wybrano żadnej daty
            alert(message: "Please, select dates!")
        } else if startDatePicker.date > endDatePicker.date {
            //gdy data startowa jest późniejsza od końcowej
            alert(message: "Please, correct end date!")
        } else if startDatePicker.date <= endDatePicker.date {

            let startDateString = self.dateFormatter.string(from: self.startDatePicker.date)
            let endDateString = self.dateFormatter.string(from: self.endDatePicker.date)
        
            getData(fromDate: startDateString, toDate: endDateString)
        }
        
    }
    
    @objc func didTapDate(_ sender: UITapGestureRecognizer? = nil) {
        
        let dateChooserAlert = UIAlertController(title: "Choose date", message: nil, preferredStyle: .actionSheet)

        
        //tag 1 - data początkowa, tag 2 - data końcowa
        switch sender?.view?.tag {
        case 1:
            dateChooserAlert.view.addSubview(startDatePicker)
            dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
                
                let dateString = self.dateFormatter.string(from: self.startDatePicker.date)
                self.startDateLabel.text = "From: \(dateString)"
                
            }))
        case 2:
            dateChooserAlert.view.addSubview(endDatePicker)
            dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
                
                let dateString = self.dateFormatter.string(from: self.endDatePicker.date)
                self.endDateLabel.text = "To: \(dateString)"
                
            }))
        default:
            break
        }
        
        //dostosowanie wysokości alertu do rozmiaru urządzenia
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateChooserAlert.view.addConstraint(height)
        
        self.present(dateChooserAlert, animated: true, completion: nil)
        
    }
    
    //pobranie danych z serwera dla określonego przedziału
    func getData(fromDate: String, toDate: String) {
        
        let url = URL(string: "http://api.nbp.pl/api/exchangerates/rates/\(tableLetter!)/\(currencyCode!)/\(fromDate)/\(toDate)")
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
                if let httpResponse = response as? HTTPURLResponse {
                    var resp = ""
                    if httpResponse.statusCode == 404 {
                        resp = "No data found"
                    } else if httpResponse.statusCode == 400 {
                        resp = "Invalid date range"
                    } else {
                        resp = "Unknown error"
                    }
                    self.alert(message: resp)
                }
            }
        }).resume()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        if let rateDetails = currencyTable?.rates[indexPath.row] {
            if tableLetter == "C" {
                cell.textLabel?.text = rateDetails.effectiveDate
                cell.detailTextLabel?.text = "1 \(currencyCode!) = BID: \(rateDetails.bid!) PLN, ASK: \(rateDetails.ask!) PLN"
            } else {
                cell.detailTextLabel?.text = "1 \(currencyCode!) = \(rateDetails.mid!) PLN"
                cell.textLabel?.text = rateDetails.effectiveDate
            }
            
            cell.detailTextLabel?.textColor = .gray
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
