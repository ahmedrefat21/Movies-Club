//
//  GenreCollectionViewCell.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: GenreCollectionViewCell.self)
    @IBOutlet weak var gernes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
