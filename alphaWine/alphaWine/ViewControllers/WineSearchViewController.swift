//
//  WineSearchViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/4/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit

class WineSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
 
    var beverages: [Beverage] = []
    var pageNumber: Int = 1

    @IBOutlet weak var wineSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextPageButton: UIBarButtonItem!
    
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        wineSearchBar.delegate = self
        tableView.delegate = self
        wineSearchBar.resignFirstResponder()
        wineSearchBar.barStyle = .default
        wineSearchBar.keyboardAppearance = .alert
        tableView.dataSource = self
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = wineSearchBar.text, searchTerm.count > 0 else {return}
        nextPageButton.isEnabled = true
        wineSearchBar.resignFirstResponder()
        pageNumber = 1
        
        BeverageController.shared.fetchBeverage(with: searchTerm, with: pageNumber) { (beverages) in
            if let beverages = beverages {
                DispatchQueue.main.async {
                    self.beverages = beverages
                    if beverages.count == 0 {
                        let alertController = UIAlertController(title: "No items found", message: "GrapeFind's search didn't find \(searchTerm) in our 8,700 + wine list, we recommend to double check spelling", preferredStyle: .alert)
                        let cancelActionItem = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelActionItem)
                        
                        self.present(alertController, animated: true)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beverages.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        UIView.animate(withDuration: (1.5)) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
    }
}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "wineCell", for: indexPath) as? WineCell else {return UITableViewCell()}
        let beverage = beverages[indexPath.row]
        BeverageController.shared.fetchBeverageImage(with: beverage) { (image) in
            if let image = image {
        DispatchQueue.main.async {
            cell.wineNameLabel.text = beverage.name
            cell.tastingNotesTextView.text = beverage.tasting_note ?? "No description provided"
            cell.wineImageView.image = image
        }
    }
}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
  

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let destinationVC = segue.destination as? DetailBeverageViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let beverage = beverages[indexPath.row]
            destinationVC.beverage = beverage
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let scrollViewHeight = scrollView.frame.size.height
       let  scrollContentSizeHeight = scrollView.contentSize.height
       let  scrollOffset = scrollView.contentOffset.y
        
        if (scrollOffset == 0)
        {
            // then we are at the top
        }
        else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
        {
            print("bottom of scroll view")
            
            UIView.animate(withDuration: 0.5) {
               
            }
        }
    }
  
    @IBAction func nextPageButtonTapped(_ sender: Any) {
        
        guard let searchTerm = wineSearchBar.text, searchTerm.count > 0 else {return}
        tableView.scrollsToTop = true
        self.pageNumber += 1
        print(self.pageNumber)

        BeverageController.shared.fetchBeverage(with: searchTerm, with: pageNumber) { (beverages) in
            if let beverages = beverages {
                DispatchQueue.main.async {
                    if beverages.count == 0 {
                        let alertController = UIAlertController(title: "No items found", message: "There are no more pages of this item", preferredStyle: .alert)
                        let cancelActionItem = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelActionItem)
                        
                        self.present(alertController, animated: true)
                        self.nextPageButton.isEnabled = false
                        self.pageNumber = 1
                        print("new page number = \(self.pageNumber)")
                    }
                    if beverages.count > 0 {
                        DispatchQueue.main.async {
                    self.beverages = beverages
                    self.tableView.reloadData()
                    
                }
                      
                    }
                }
            }
        }
    }
}

extension UIScrollView {
    func scrollToTop(animated: Bool) {
    let topOffset = CGPoint(x: 0, y: -contentInset.top)
    setContentOffset(topOffset, animated: animated)
    }
}



