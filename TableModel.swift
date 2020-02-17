//
//  TableModel.swift
//  ExchangeR
//
//  Created by Robert Moryson on 11/02/2020.
//  Copyright © 2020 Robert Moryson. All rights reserved.
//

import Foundation

// MARK: - Table
struct Table: Codable {
    let table, no, effectiveDate: String
    let tradingDate: String?
    let rates: [Rate]
    
    struct Rate: Codable {
        let currency, code: String
        let mid, bid, ask: Double?
    }
}


// MARK: - CurrencyDetails
struct CurrencyDetails: Codable {
    let table, currency, code: String
    let rates: [Rate]

    struct Rate: Codable {
        let no, effectiveDate: String
        let mid, bid, ask: Double?
    }

}
