//
//  ViewController.swift
//  BooksApp
//
//  Created by Ayush on 03/04/24.
//

import UIKit

class ViewController: UIViewController, StoryboardInstantiable {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var searchBTn: UIButton!
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var searchBgView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gradientView: UIView!
    
    // MARK: - Stored Properties
    
    private var viewModel: BookListViewModelProtocol!
    private var isExpanded = false
    private var searchBarOriginX: CGFloat?
    private var newOrigin:  CGFloat?
    private var isLoading: Bool = false
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        searchBarSetup()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bindToVMViewDidLoad()
    }
    
    static func create(
        with viewModel: BookListViewModelProtocol) -> ViewController {
            let view = ViewController.instantiateViewController()
            view.viewModel = viewModel
            return view
        }
    
    // MARK: - Ib Actions
    
    @IBAction func tapSearch(_ sender: Any) {
        isLoading = true
        guard let searchText = searchTf.text?.replaceSpacesWithPlus() else {return}
        self.viewModel.didSearch(query: searchText)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        let currentSelection = "\(self.viewModel.booksArray[sender.tag].coverId ?? 0)"
        let isPresent = self.viewModel.savedBookDict.contains(currentSelection)
        if !isPresent {
            self.viewModel.savedBookDict.insert(currentSelection)
        } else {
            self.viewModel.savedBookDict.remove(currentSelection)
        }
        self.viewModel.togleBookInFavorites(book: self.viewModel.booksArray[sender.tag])
        self.reload()
    }
    
}

// MARK: - ViewController Extension for Custom Methods

private extension ViewController {
    
    func bindToViewModel() {
        viewModel.dataAppendedHandler = { [weak self] in
            DispatchQueue.main.async {
                guard let isEmpty = self?.viewModel.booksArray.isEmpty else {return}
                if !isEmpty {
                    self?.isLoading = false
                }
                self?.collectionView.reloadData()
            }
        }
    }
    
    func bindToVMViewDidLoad() {
        self.viewModel.viewDidLoad()
    }
    
    func searchBarSetup() {
        self.searchTf.delegate = self
        gradientViewSetup()
        searchIconTapGesture()
        checkForSearchBarOriginX()
        addBorderToSearchBar()
        setupSearchBarAnimation()
    }
    
    func searchIconTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchIconTapped))
        searchIcon.addGestureRecognizer(tapGestureRecognizer)
        searchIcon.isUserInteractionEnabled = true
    }
    
    func checkForSearchBarOriginX() {
        searchBarOriginX = self.searchBgView.layer.position.x
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "BookCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "BookCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func updateSearch() {
        viewModel.didCancelSearch()
        self.reload()
    }
    
    func reload() {
        self.collectionView.reloadData()
    }
    
    func setupSearchBarAnimation() {
        isExpanded.toggle()
        if self.isExpanded {
            self.expandedView()
        } else {
            self.collapsedView()
        }
        self.searchTf.alpha = self.isExpanded ? 1.0 : 0.0
        self.searchBTn.alpha = self.isExpanded ? 1.0 : 0.0
        self.searchTf.isHidden = !self.isExpanded
        self.searchBTn.isHidden = !self.isExpanded
    }
    
    func gradientViewSetup() {
        let colors = [UIColor.white, UIColor.clear]
        gradientView.layer.cornerRadius = 20
        gradientView.addGradientMask(colors: colors, startPoint: CGPoint(x: 0.5, y: 1.0), endPoint: CGPoint(x: 0.5, y: 0.0))
    }
    
    func addBorderToSearchBar() {
        self.searchBgView.layer.borderWidth = 1.4
        self.searchBgView.layer.borderColor = UIColor.gray.cgColor
        self.searchBgView.layer.cornerRadius = 21
    }
    
}

// MARK: - ViewController Extension for Obj-c Methods

@objc extension ViewController {
    
    func searchIconTapped() {
        
    }
    
    func shadowToSearchBar() {
        self.searchBgView.layer.shadowColor = UIColor.red.cgColor
        self.searchBgView.layer.shadowOpacity = 1
        self.searchBgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.searchBgView.layer.shadowRadius = 21
    }
    
    private func expandedView() {
        let screenWidth = UIScreen.main.bounds.width
        let newWidth = screenWidth - 50
        let newXOrigin = 25
        newOrigin = CGFloat(newXOrigin) + newWidth / 2
        
        let widthAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        widthAnimation.fromValue = self.searchBgView.bounds.width
        widthAnimation.toValue = newWidth
        widthAnimation.duration = 0.3
        
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        positionAnimation.fromValue = self.searchBgView.layer.position.x
        positionAnimation.toValue = CGFloat(newXOrigin) + newWidth / 2
        positionAnimation.duration = 0.3
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [widthAnimation, positionAnimation]
        groupAnimation.duration = 0.3
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.searchBgView.layer.bounds.size.width = newWidth
            self.searchBgView.layer.position.x = CGFloat(newXOrigin) + newWidth / 2
            self.searchBgView.clipsToBounds = true
        }
        self.searchBgView.layer.add(groupAnimation, forKey: "animations")
        CATransaction.commit()
    }
    
    private func collapsedView() {
        let newWidth = 42
        
        let widthAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        widthAnimation.fromValue = self.searchBgView.bounds.width
        widthAnimation.toValue = newWidth
        widthAnimation.duration = 0.3
        
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        positionAnimation.fromValue = UIScreen.main.bounds.width - 50
        positionAnimation.toValue = self.searchBarOriginX
        positionAnimation.duration = 0.3
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [widthAnimation, positionAnimation]
        groupAnimation.duration = 0.3
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.searchBgView.layer.position.x = UIScreen.main.bounds.width - 42
            self.searchBgView.layer.bounds.size.width = CGFloat(newWidth)
            
        }
        self.searchBgView.layer.add(groupAnimation, forKey: "animations")
        CATransaction.commit()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isLoading ? 5 : viewModel.booksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        if self.isLoading {
            cell.configureWithSchimmerEffect()
        } else {
            self.viewModel.booksArray[indexPath.item].isFav = self.viewModel.savedBookDict.contains("\(viewModel.booksArray[indexPath.item].coverId ?? 0)")
            cell.configure(with: viewModel.booksArray[indexPath.item])
            cell.configureCellUI()
        }
        cell.likeBtn.tag = indexPath.item
        cell.likeBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let cellWidth = (collectionView.bounds.width - (numberOfColumns - 1) * 10 - 2 * 25) / numberOfColumns
        let cellHeight = cellWidth * 1.6
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 25, bottom: 20, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.booksArray.count - 1 {
            viewModel.didLoadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.didSelectItem(at: indexPath.item)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isEmpty {
            self.updateSearch()
        }
        return true
    }
}
