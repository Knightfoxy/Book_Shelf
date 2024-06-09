//
//  BookDetailViewController.swift
//  BooksApp
//
//  Created by Ayush on 17/04/24.
//

import UIKit
import SDWebImage

class BookDetailViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var bgGradientCoverImg: UIImageView!
    // background View for rounded corners
    @IBOutlet weak var bookCoverImg: UIImageView!
    @IBOutlet weak var rateCountBgView: UIStackView!
    @IBOutlet weak var pagesBgView: UIStackView!
    @IBOutlet weak var languageBgView: UIStackView!
    // data background for background color gray
    @IBOutlet weak var ratingCountBg: UIView!
    @IBOutlet weak var pagesBg: UIView!
    @IBOutlet weak var langBg: UIView!
    // book data to show
    @IBOutlet weak var ratingCount: UILabel!
    @IBOutlet weak var pagesCount: UILabel!
    @IBOutlet weak var langage: UILabel!
    // average Rating Bg View
    @IBOutlet weak var avgRatingBgView: UIStackView!
    // avg rating background view color gray
    @IBOutlet weak var avgRatingBg: UIStackView!
    //stars icons
    @IBOutlet weak var rating1Star: UIImageView!
    @IBOutlet weak var rating2Star: UIImageView!
    @IBOutlet weak var rating3Star: UIImageView!
    @IBOutlet weak var rating4Star: UIImageView!
    @IBOutlet weak var rating5Star: UIImageView!
    // book details
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authorName: UILabel!
    
    private var viewModel: BookDetailProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
        configureViewData()
    }
  
    static func create(with viewModel: BookDetailViewModel) -> BookDetailViewController {
        guard let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookDetailViewController") as? BookDetailViewController else {
                    fatalError("Unable to instantiate view controller from storyboard.")
                }
                view.viewModel = viewModel
                return view
    }

}

private extension BookDetailViewController {
    
    func initialViewSetup() {
        backgroundViewBorderSetup()
        coverImgGradient()
        coverImgBorderRadius()
        backgroundCornerRadius()
        addBlurEffect()
        addGradientLayer()
    }
    
    func backgroundViewBorderSetup() {
        self.rateCountBgView.layer.borderColor = UIColor.gray.cgColor
        self.rateCountBgView.layer.borderWidth = 1.2
        self.pagesBgView.layer.borderColor = UIColor.gray.cgColor
        self.pagesBgView.layer.borderWidth = 1.2
        self.languageBgView.layer.borderColor = UIColor.gray.cgColor
        self.languageBgView.layer.borderWidth = 1.2
        self.avgRatingBgView.layer.borderColor = UIColor.gray.cgColor
        self.avgRatingBgView.layer.borderWidth = 1.2
    }
    
    func backgroundCornerRadius() {
        self.rateCountBgView.layer.cornerRadius = 20
        self.pagesBgView.layer.cornerRadius = 20
        self.languageBgView.layer.cornerRadius = 20
        self.avgRatingBgView.layer.cornerRadius = 20
    }
    
    func coverImgGradient() {
        
    }
    
    func coverImgBorderRadius() {
        self.bookCoverImg.layer.cornerRadius = 20
    }
    
    func configureViewData() {
        guard let coverId = viewModel.bookDetail.coverId else { return }
        guard let ratingCount = viewModel.bookDetail.ratingsCount else { return }
        bookCoverImg.sd_setImage(with: URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"), placeholderImage: UIImage(named: "placeholderImage"))
        bgGradientCoverImg.sd_setImage(with: URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"), placeholderImage: UIImage(named: "placeholderImage"))
        self.bookTitle.text = viewModel.bookDetail.title
        self.authorName.text = viewModel.bookDetail.authorName?[0]
        self.ratingCount.text = "\(ratingCount)"
    }
    
    func addGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bgGradientCoverImg.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.bgGradientCoverImg.layer.addSublayer(gradientLayer)
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bgGradientCoverImg.bounds
        self.bgGradientCoverImg.addSubview(blurEffectView)
    }
}
