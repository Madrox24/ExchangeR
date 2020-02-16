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
    
    @IBOutlet weak var startDatePickerView: UIView!
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var endDatePickerView: UIView!
    @IBOutlet weak var endDateLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = currencyName

        dateFormatter.dateFormat = "yyyy-MM-dd"
        getData(fromDate: "2020-02-07", toDate: "2020-02-14")
        
        startDatePicker.datePickerMode = .date
        
        let startDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDate(_:)))
        startDatePickerView.addGestureRecognizer(startDateTapGesture)
        let endDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDate(_:)))
        endDatePickerView.addGestureRecognizer(endDateTapGesture)
    }
    
    @IBAction func didTapShowResults(_ sender: Any) {
        print("OK")
    }
    
    @objc func didTapDate(_ sender: UITapGestureRecognizer? = nil) {
        
        let dateChooserAlert = UIAlertController(title: "Choose date", message: nil, preferredStyle: .actionSheet)

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
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
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
