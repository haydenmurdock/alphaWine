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
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var wineNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var producerNameLabel: UILabel!
    @IBOutlet weak var wineColorLabel: UILabel!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var openNoteViewButton: UIButton!
    @IBOutlet weak var addWineButton: UIButton!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var cancelNoteButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var pinButton: UIButton!
    var wineColorIcon: String = ""
    var beverage: Beverage?
    var overView: [String] = []
    var pairsWith: [String] = []
    var isSection1Open: Bool = true
    var isSection2Open: Bool = true
    var noteOnWine: String = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        noteView.center.y += 700
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
      return 36
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView1.dataSource = self
        tableView1.delegate = self
        backButton.backgroundColor = Colors.darkGreen
        addNoteButton.layer.cornerRadius = 10
        cancelNoteButton.layer.cornerRadius = 10
        
        guard let beverage = beverage else {return}
        BeverageController.shared.fetchBeverageImage(with: beverage) { (image) in
            if let image = image {

                DispatchQueue.main.async {
                    self.wineImageView.image = image
                    self.wineNameLabel.text =  "\(beverage.name!)"
                let winePrice = Double(beverage.price_in_cents! / 100) * 0.77
                self.priceLabel.text = "GrapeFinds estimated Price: \(winePrice)$"
                    self.overView.append(beverage.tasting_note ?? "no overview")
                    self.pairsWith.append(beverage.serving_suggestion ?? "no serving suggestion provided")
                    self.producerNameLabel.text = "Producer: \(beverage.producer_name ?? "no producer provided" )"
                    
                let wineColorText = beverage.secondary_category!.replacingOccurrences(of: "Wine", with: "")
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
        UIView.animate(withDuration: 0.7) {
            self.noteView.center.y += 700
        }
        openNoteViewButton.isUserInteractionEnabled = true
        addWineButton.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
        
    }
    
    
    @IBAction func cancelNoteButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.7) {
            self.noteView.center.y += 700
        }
        openNoteViewButton.isUserInteractionEnabled = true
        addWineButton.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
        noteTextView.text = ""
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
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
        
        if section == 1 {
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
    
    @IBAction func pinButtonPressed(_ sender: Any) {
    }
    
   @objc func openCloseCell(_ button: UIButton){
    if isSection1Open == true  && button.tag == 1{
    
    isSection1Open = false
    let indexPath = IndexPath(row: 0, section: 0)
    tableView1.deleteRows(at: [indexPath], with: .fade)
    
    button.setTitle("Open", for: .normal)
    
    print("close OverViewCell")
    // open Section
    } else if isSection1Open == false && button.tag == 1 {
    
    button.setTitle("Close", for: .normal)
    
    isSection1Open = true
    let indexPath = IndexPath(row: 0, section: 0)
    tableView1.insertRows(at: [indexPath], with: .automatic)
    
    print("open OverviewCell")
    }
    
    if isSection2Open == true  && button.tag == 2{
    
    isSection2Open = false
    let indexPath = IndexPath(row: 0, section: 1)
    tableView1.deleteRows(at: [indexPath], with: .fade)
    
    button.setTitle("Open", for: .normal)
    
    
    print("close OverViewCell")
    // open Section
    } else if isSection2Open == false && button.tag == 2 {
    
    button.setTitle("Close", for: .normal)
    
    isSection2Open = true
    let indexPath = IndexPath(row: 0, section: 1)
    tableView1.insertRows(at: [indexPath], with: .automatic)
    
    print("open OverviewCell")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as? OverviewTableViewCell else {return UITableViewCell()}
        DispatchQueue.main.async {
            let text = self.overView[indexPath.row]
            cell.overviewTextView.text = text
       
        }
        return cell
        }
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "pairsWellWith", for: indexPath) as? PairsWellCell else {return UITableViewCell()}
        DispatchQueue.main.async {
            let text = self.pairsWith[indexPath.row]
            cell.servingSuggestionTextView.text = text
        }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 175
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}


    
    
    
    
    
    
    
    
    
    



