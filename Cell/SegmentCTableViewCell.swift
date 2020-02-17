//
//  SegmentCTableViewCell.swift
//  ExchangeR
//
//  Created by Robert Moryson on 12/02/2020.
//  Copyright © 2020 Robert Moryson. All rights reserved.
//

import UIKit

class SegmentCTableViewCell: SegmentTableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var codeBG: UIView!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCellShadow()
        roundCorner(view: roundedView)
        roundCorner(view: codeBG)
        makeGradient(thisView: codeBG)
    }
}
