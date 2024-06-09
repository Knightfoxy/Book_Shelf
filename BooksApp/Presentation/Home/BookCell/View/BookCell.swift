//
//  BookCell.swift
//  BooksApp
//
//  Created by Ayush on 15/04/24.
//

import UIKit
import SDWebImage

class BookCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var coverImgBg: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    
    var bookDetail: Book?
    var isBookLiked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        restoreState()
    }
    
    func configure(with book: Book) {
        self.bookDetail = book
        restoreCellForData()
        guard let coverId = book.coverId else { return }
        coverImg.sd_setImage(with: URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"), placeholderImage: UIImage(named: "placeholderImage"))
        self.bookTitle.text = book.title
        likeBtn.setImage(UIImage(systemName: book.isFav ?? false ? "bookmark.fill" : "bookmark"), for: .normal)
    }
    
    func configureWithSchimmerEffect() {
        likeBtn.isHidden = true
        coverImg.addGradientWithAnimation()
        bookTitle.addGradientWithAnimation()
    }
    
    func restoreCellForData() {
        likeBtn.isHidden = false
        coverImg.removeGradient()
        bookTitle.removeGradient()
    }
    
    func restoreState() {
        if let image = UIImage(systemName: "bookmark") {
            likeBtn.setImage(image, for: .normal)
        }
    }
    
    func configureCellUI() {
        self.coverImgBg.layer.masksToBounds = true
        self.coverImgBg.layer.shadowColor = UIColor.gray.cgColor
        self.coverImgBg.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.coverImgBg.layer.shadowRadius = 20
        self.coverImg.layer.shadowOpacity = 0.5
        self.likeBtn.layer.cornerRadius = 15
    }
    
}
