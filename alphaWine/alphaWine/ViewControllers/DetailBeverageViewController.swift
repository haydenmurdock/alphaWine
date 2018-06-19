//
//  DetailBeverageViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/4/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit
import CoreImage

class DetailBeverageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var wineNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var producerNameLabel: UILabel!
    @IBOutlet weak var wineColorLabel: UILabel!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var openNoteViewButton: UIButton!
    @IBOutlet weak var addWineButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    var wineColorIcon: String = ""
    var beverage: Beverage?
    var overView: [String] = []
    var pairsWith: [String] = []
    var tableView1Expanded: Bool = true
    var tableView2Expanded: Bool = true
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        noteView.center.y += 700
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView1.dataSource = self
        tableView1.delegate = self
        tableView2.dataSource = self
        tableView2.delegate = self
        backButton.backgroundColor = Colors.darkGreen
        
        print(tableView2.center.y)
        
        guard let beverage = beverage else {return}
        BeverageController.shared.fetchBeverageImage(with: beverage) { (image) in
            if let image = image {

                DispatchQueue.main.async {
                    self.wineImageView.image = image
                    self.wineNameLabel.text =  "\(beverage.name)"
                let winePrice = Double(beverage.price_in_cents / 100) * 0.77
                self.priceLabel.text = "GrapeFinds estimated Price: \(winePrice)$"
                    self.overView.append(beverage.tasting_note)
                    self.pairsWith.append(beverage.serving_suggestion)
                    self.producerNameLabel.text = "Producer: \(beverage.producer_name)"
                    
                let wineColorText = beverage.secondary_category.replacingOccurrences(of: "Wine", with: "")
                    self.wineColorIcon = wineColorText
                    self.wineColorLabel.text = "Color: \(wineColorText)"
                }
            }
        }
    }

    @IBAction func addWineButtonTapped(_ sender: Any) {
        guard let name = wineNameLabel.text  else { return }
        guard let producer = producerNameLabel.text else { return }
        guard let price = priceLabel.text else {return}
        guard let note = noteTextView.text else {return}
        guard let summary = overView.first else {return}
        
        let trimmedString = wineColorIcon.trimmingCharacters(in: .whitespaces)
       WineController.shared.addWine(name: name, color: trimmedString, producer: producer, price: price, summary: summary, note: note)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "tabeBarController")
        self.present(destinationVC, animated: true, completion: nil)

        
    }
    
    
    @IBAction func addNote(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.noteView.center.y -= 700
        }
    openNoteViewButton.isUserInteractionEnabled = false
    addWineButton.isUserInteractionEnabled = false
    backButton.isUserInteractionEnabled = false
    
    noteView.isHidden = false
    noteView.isUserInteractionEnabled = true
    noteView.layer.cornerRadius = 10

    noteView.backgroundColor = UIColor(red: 220/250, green: 220/250, blue: 220/250, alpha: 0.90)
    
    noteTextView.backgroundColor = UIColor(red: 250/255, green: 250/250, blue: 210/250, alpha: 1)
    
    }
    
    
    @IBAction func addNoteToWine(_ sender: Any) {
        
    }
    
    
    @IBAction func cancelNoteButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.7) {
            self.noteView.center.y += 700
        }
        openNoteViewButton.isUserInteractionEnabled = true
        addWineButton.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == tableView1 {
        let superview = UIView()
        superview.backgroundColor = Colors.darkGreen
        
        let overviewButton = UIButton(type: .system)
        overviewButton.setTitle("Close", for: .normal)
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
        
        if tableView == tableView2 {
            let superview = UIView()
            superview.backgroundColor = Colors.darkGreen
            
            let pairsWithButton = UIButton(type: .system)
            pairsWithButton.setTitle("Close", for: .normal)
            pairsWithButton.setTitleColor(UIColor.black, for: .normal)
            pairsWithButton.backgroundColor = Colors.darkGreen
            pairsWithButton.addTarget(self, action: #selector(openCloseCell), for: .touchUpInside)
            pairsWithButton.contentMode = .bottom
            pairsWithButton.tag = 2
            
            
            
            pairsWithButton.translatesAutoresizingMaskIntoConstraints = false
            
            superview.addSubview(pairsWithButton)
            
            let buttonTop = NSLayoutConstraint(item: pairsWithButton, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let buttonCenterX = NSLayoutConstraint(item: pairsWithButton, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 150)
            let buttonWidth = NSLayoutConstraint(item: pairsWithButton, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
            let buttonHeight = NSLayoutConstraint(item:pairsWithButton, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
            
            superview.addConstraints([buttonTop, buttonCenterX, buttonWidth, buttonHeight])
            
            
            let pairsWithLabel = UILabel()
            pairsWithLabel.text = "Pairs With:"
            pairsWithLabel.textColor = .black
            
            superview.addSubview(pairsWithLabel)
            pairsWithLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let labelTop = NSLayoutConstraint(item: pairsWithLabel, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let labelCenterX = NSLayoutConstraint(item: pairsWithLabel, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: -130)
            let labelWidth = NSLayoutConstraint(item: pairsWithLabel, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
            let labelHeight = NSLayoutConstraint(item: pairsWithLabel, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
            
            superview.addConstraints([labelTop, labelCenterX, labelWidth, labelHeight])
            
            
            return superview
        }
    return UIView()
}
    
    @objc func openCloseCell(_ button: UIButton) {
        //close Section
        
        if tableView1Expanded == true  && button.tag == 1{
            
        tableView1Expanded = false
        let indexPath = IndexPath(row: 0, section: 0)
       tableView1.deleteRows(at: [indexPath], with: .fade)
     //   overView.removeAll()
        
       
        button.setTitle("Open", for: .normal)
          
            tableView1.frame.size.height = 36
            tableView2.center.y = tableView1.center.y + 80

            
                        print("close OverViewCell")
        // open Section
        } else if tableView1Expanded == false && button.tag == 1 {
            //let overview = beverage?.tasting_note
            button.setTitle("Close", for: .normal)
           // overView.append(overview!)
            tableView1Expanded = true
            tableView1.frame.size.height = 175
            tableView2.center.y = 512
            let indexPath = IndexPath(row: 0, section: 0)
            tableView1.insertRows(at: [indexPath], with: .automatic)
            
            print("open OverviewCell")
        }
         // close section
        if tableView2Expanded == true && button.tag == 2{
            tableView2Expanded = false
            let indexPath = IndexPath(row: 0, section: 0)
            tableView2.deleteRows(at: [indexPath], with: .automatic)
            
            button.setTitle("Open", for: .normal)
           
            tableView2.frame.size.height = 36
            print("close PairsWithCell")
            // open section
        } else if tableView2Expanded == false && button.tag == 2{
            
            button.setTitle("Close", for: .normal)
            tableView2Expanded = true
            tableView2.frame.size.height = 175
            let indexPath = IndexPath(row: 0, section: 0)
            tableView2.insertRows(at: [indexPath], with: .automatic)
            
            print("open PairWithCell")
        }
    
        
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 && tableView1Expanded == false {
            return 0
        }
        if tableView == tableView1 && tableView1Expanded == true {
            return overView.count
        }
        if tableView == tableView2 && tableView2Expanded == false {
            return 0
        }
        if tableView == tableView2 && tableView2Expanded == true {
            return pairsWith.count
        }
        
    return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as? OverviewTableViewCell else {return UITableViewCell()}
        DispatchQueue.main.async {
            let text = self.overView[indexPath.row]
            cell.overviewTextView.text = text
       
        }
        return cell
        }
        if tableView == tableView2 {
            
            guard let cell = tableView2.dequeueReusableCell(withIdentifier: "pairsWithCell", for: indexPath) as? PairsWellCell
                else {return UITableViewCell()}
            DispatchQueue.main.async {
                let text = self.pairsWith[indexPath.row]
                cell.servingSuggestionTextView.text = text
            }
        return cell
        }
        let newCell = UITableViewCell()
        newCell.frame.size = CGSize(width: 0, height: 0)
        return newCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 175
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}


    
    
    
    
    
    
    
    
    
    



