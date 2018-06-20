//
//  WineCellarViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/6/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit
import CoreData

class WineCellarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, NSFetchedResultsControllerDelegate {
    
    let itemsFRC: NSFetchedResultsController<Wine> = {
        let request: NSFetchRequest<Wine> = Wine.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        print("Items were sorted")
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
   
    @IBOutlet weak var cellarCollectionView: UICollectionView!
    @IBOutlet weak var minusButton: UIButton!
    
    var isScrolling = false
    
    var wine: Wine?{
        didSet{
           
        }
    }
    var isSection1Open: Bool = false
    var isSection2Open: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cellarCollectionView.center.x -= 500
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsFRC.delegate = self
        do {
            try itemsFRC.performFetch()
        } catch  {
            print("\(error.localizedDescription)")
        }
      
        
        cellarCollectionView.reloadData()
        displayMinusButton()
        cellarCollectionView.delegate = self
        cellarCollectionView.dataSource = self

        UIView.animate(withDuration: 0.5) {
            self.cellarCollectionView.center.x += 500
        }
        cellarCollectionView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsFRC.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineCellarCell", for: indexPath) as? CellarCollectionViewCell else {return UICollectionViewCell()}
            let wine = itemsFRC.object(at: indexPath)
        DispatchQueue.main.async {
            cell.updateCell(with: wine)
          
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
        isSection1Open = false
        isSection2Open = false
        
        print("scrolling")
    }

    
    @IBAction func addWineButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to add a Wine?", preferredStyle: .alert)
        let addActionItem = UIAlertAction(title: "Add", style: .default) { (_) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "addWine")
            self.present(destinationVC, animated: true, completion: nil)
            
        }
        alertController.addAction(addActionItem)
        let cancelActionItem = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        alertController.addAction(cancelActionItem)
      
        
        present(alertController, animated:true)
    }
    
    
    @IBAction func removeWineButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to Delete?", preferredStyle: .alert)
        let addActionItem = UIAlertAction(title: "Delete", style: .default) { (_) in
            guard let wine = self.wine else {return}
            WineController.shared.removeWinefromCoreData(with: wine)
            self.wine = nil
            self.cellarCollectionView.reloadData()
            
            
        }
        alertController.addAction(addActionItem)
        let cancelActionItem = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelActionItem)
        
        
        present(alertController, animated:true)
    }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wine = itemsFRC.object(at: indexPath)
        self.wine = wine
    }
    func displayMinusButton () {
        if (itemsFRC.fetchedObjects?.count)! > 0 {
            minusButton.isHidden = false
            minusButton.isUserInteractionEnabled = true
        } else {
            minusButton.isHidden = true
            minusButton.isUserInteractionEnabled = false
        }
    }

}

