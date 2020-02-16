//
//  StringProtocol+Extension.swift
//  ExchangeR
//
//  Created by Robert Moryson on 16/02/2020.
//  Copyright © 2020 Robert Moryson. All rights reserved.
//

import UIKit

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
}
