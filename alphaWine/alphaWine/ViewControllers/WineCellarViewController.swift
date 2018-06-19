//
//  WineCellarViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/6/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit
import CoreData

class WineCellarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    let itemsFRC: NSFetchedResultsController<Wine> = {
        let request: NSFetchRequest<Wine> = Wine.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        print("Items were sorted")
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var cellarCollectionView: UICollectionView!
    
    @IBOutlet weak var minusButton: UIButton!
    
    var isScrolling = false
    
    var wine: Wine?{
        didSet{
           tableView.reloadData()
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
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
            self.tableView.reloadData()
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
        isSection1Open = false
        isSection2Open = false
        tableView.isUserInteractionEnabled = false
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
            self.tableView.reloadData()
            
        }
        alertController.addAction(addActionItem)
        let cancelActionItem = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelActionItem)
        
        
        present(alertController, animated:true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSection1Open == true && section == 0{
            return 1
        }
        if isSection1Open == false && section == 0{
            return 0
        }
        if isSection2Open == true && section == 1 {
            return 1
        }
        if isSection2Open == true && section == 1 {
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as? SummaryCell else {return UITableViewCell()}
        cell.priceLabel.text = self.wine?.price
        cell.producerLabel.text = self.wine?.producer
        cell.summaryTextView.text = self.wine?.summary
        
    return cell
        }
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NotesCell else {return UITableViewCell()}
            cell.notesTextView.text = wine?.note
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
        let superview = UIView()
        
        superview.backgroundColor = Colors.darkGreen
        
        let overviewButton = UIButton(type: .system)
        overviewButton.setTitle("Open", for: .normal)
        overviewButton.setTitleColor(UIColor.black, for: .normal)
        overviewButton.backgroundColor = Colors.darkGreen
        overviewButton.addTarget(self, action: #selector(openCloseCell), for: .touchUpInside)
        overviewButton.contentMode = .bottom
        overviewButton.tag = 1
        
        overviewButton.translatesAutoresizingMaskIntoConstraints = false
        
        superview.addSubview(overviewButton)
        
        let buttonTop = NSLayoutConstraint(item: overviewButton, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
        let buttonCenterX = NSLayoutConstraint(item: overviewButton, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 150)
        let buttonWidth = NSLayoutConstraint(item: overviewButton, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
        let buttonHeight = NSLayoutConstraint(item: overviewButton, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
        
        superview.addConstraints([buttonTop, buttonCenterX, buttonWidth, buttonHeight])
        
            
            let overviewLabel = UILabel()
            overviewLabel.text = "Overview"
            overviewLabel.textColor = .black
            
            superview.addSubview(overviewLabel)
            overviewLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let labelTop = NSLayoutConstraint(item: overviewLabel, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let labelCenterX = NSLayoutConstraint(item: overviewLabel, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: -130)
            let labelWidth = NSLayoutConstraint(item: overviewLabel, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
            let labelHeight = NSLayoutConstraint(item: overviewLabel, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
            
            superview.addConstraints([labelTop, labelCenterX, labelWidth, labelHeight])
           
        return superview
        }
        if section == 1 {
            let superview = UIView()
            superview.backgroundColor = Colors.darkGreen
            
            let overviewButton = UIButton(type: .system)
            overviewButton.setTitle("Open", for: .normal)
            overviewButton.setTitleColor(UIColor.black, for: .normal)
            overviewButton.backgroundColor = Colors.darkGreen
            overviewButton.addTarget(self, action: #selector(openCloseCell), for: .touchUpInside)
            overviewButton.contentMode = .bottom
            overviewButton.tag = 2
            
            overviewButton.translatesAutoresizingMaskIntoConstraints = false
            
            superview.addSubview(overviewButton)
            
            let buttonTop = NSLayoutConstraint(item: overviewButton, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let buttonCenterX = NSLayoutConstraint(item: overviewButton, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 150)
            let buttonWidth = NSLayoutConstraint(item: overviewButton, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
            let buttonHeight = NSLayoutConstraint(item: overviewButton, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
            
            superview.addConstraints([buttonTop, buttonCenterX, buttonWidth, buttonHeight])
            
            
            let noteLabel = UILabel()
            noteLabel.text = "Notes"
            noteLabel.textColor = .black
            
            superview.addSubview(noteLabel)
            noteLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let labelTop = NSLayoutConstraint(item: noteLabel, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let labelCenterX = NSLayoutConstraint(item: noteLabel, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: -130)
            let labelWidth = NSLayoutConstraint(item: noteLabel, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
            let labelHeight = NSLayoutConstraint(item: noteLabel, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
            
            superview.addConstraints([labelTop, labelCenterX, labelWidth, labelHeight])
            
           
            return superview
            
        }
        return UIView()
    }
    
    
  
    @objc func openCloseCell(_ button: UIButton){
        if isSection1Open == true  && button.tag == 1{
            
            isSection1Open = false
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
    
            button.setTitle("Open", for: .normal)
    
            print("close OverViewCell")
            // open Section
        } else if isSection1Open == false && button.tag == 1 {
            
            button.setTitle("Close", for: .normal)
            
            isSection1Open = true
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            print("open OverviewCell")
        }

        if isSection2Open == true  && button.tag == 2{
            
            isSection2Open = false
            let indexPath = IndexPath(row: 0, section: 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            button.setTitle("Open", for: .normal)
    
            
            print("close OverViewCell")
            // open Section
        } else if isSection2Open == false && button.tag == 2 {
            
            button.setTitle("Close", for: .normal)
            
            isSection2Open = true
            let indexPath = IndexPath(row: 0, section: 1)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            print("open OverviewCell")
        }
}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wine = itemsFRC.object(at: indexPath)
        self.wine = wine
        tableView.isUserInteractionEnabled = true
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

extension WineCellarViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
            
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type{
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
            
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
            
        default:
            return
        }
    }
}
