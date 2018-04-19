//
//  SeatsCollectionViewCell.swift
//  MovieViewer
//
//  Created by Kevin Maloles on 4/18/18.
//  Copyright © 2018 Kevin Maloles. All rights reserved.
//

import UIKit

class SeatsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var checkImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
