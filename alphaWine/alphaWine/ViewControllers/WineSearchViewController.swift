//
//  WineSearchViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/4/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit

class WineSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate{
 
    var beverages: [Beverage] = []


    @IBOutlet weak var wineSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
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
        
        BeverageController.shared.fetchBeverage(with: searchTerm) { (beverages) in
            if let beverages = beverages {
                DispatchQueue.main.async {
                    self.beverages = beverages
                    if beverages.count == 0 {
                        let alertController = UIAlertController(title: "No items found", message: "GrapeFind's search didn't find \(searchTerm) in our 500,000+ wine list, we recommend to double check spelling", preferredStyle: .alert)
                        let cancelActionItem = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelActionItem)
                        
                        self.present(alertController, animated: true)
                    }
                    self.tableView.reloadData()
                    self.wineSearchBar.text = ""
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
            cell.tastingNotesTextView.text = beverage.tasting_note
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

}
