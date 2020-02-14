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
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()

    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = currencyName

        getData(fromDate: "2020-02-07", toDate: "2020-02-14")
        
        startDatePicker.maximumDate = Date()
        startDatePicker.datePickerMode = .date
        endDatePicker.maximumDate = Date()
        endDatePicker.datePickerMode = .date
    }
    
    @IBAction func didTapStartDate(_ sender: UIButton) {

        let dateChooserAlert = UIAlertController(title: "Choose date", message: nil, preferredStyle: .actionSheet)
        
        switch sender.tag {
        case 1:
            dateChooserAlert.view.addSubview(startDatePicker)
            dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
                self.startDateButton.titleLabel?.text = "From: \(self.startDatePicker.date)"
            }))
        case 2:
            dateChooserAlert.view.addSubview(endDatePicker)
            endDatePicker.minimumDate = startDatePicker.date
            dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
                self.endDateButton.titleLabel?.text = "To: \(self.endDatePicker.date)"
            }))
        default:
            break
        }
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateChooserAlert.view.addConstraint(height)
        self.present(dateChooserAlert, animated: true, completion: nil)
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
