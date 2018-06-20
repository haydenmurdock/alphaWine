//
//  RandomWineViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/20/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit
class RandomWineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var randomWineButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var wineNameLabel: UILabel!
    @IBOutlet weak var producerNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var wineColorLabel: UILabel!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var findProducerButton: UIButton!
    @IBOutlet weak var addWineToCellarButton: UIButton!
    @IBOutlet weak var openNoteViewButton: UIButton!
    @IBOutlet weak var wineInfoStackView: UIStackView!
    @IBOutlet weak var beginingActivityIndicator: UIActivityIndicatorView!
    
    var beverages: [Beverage] = []
    var wineColorIcon: String = ""
    var beverage: Beverage? {
        didSet {
            tableView.reloadData()
        }
    }
    var overView: [String] = []
    var pairsWith: [String] = []
    var isSection1Open: Bool = true
    var isSection2Open: Bool = true
    var noteOnWine: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        noteView.center.y += 700
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        activityIndicator.isHidden = true
        beginingActivityIndicator.color = Colors.darkGreen
        activityIndicator.color = Colors.darkGreen
        
        
        noteTextView.backgroundColor = UIColor(red: 250/255, green: 250/250, blue: 210/250, alpha: 1)
        noteTextView.layer.cornerRadius = 10
        noteView.backgroundColor = UIColor(red: 220/250, green: 220/250, blue: 220/250, alpha: 0.90)
        noteView.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        addNoteButton.layer.cornerRadius = 10
        randomWineButton.backgroundColor = Colors.darkGreen
       
        
        
        let pageNumber = Int(arc4random_uniform(100) + 1)
        
        BeverageController.shared.fetchRandomBeverage(with: pageNumber) { (beverages) in
            if let beverages = beverages {
                let beverageIndex = Int(arc4random_uniform(4) + 1)
                let beverage = beverages[beverageIndex]
                BeverageController.shared.fetchBeverageImage(with: beverage, completion: { (image) in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.wineNameLabel.text = beverage.name ?? ""
                            self.producerNameLabel.text = beverage.producer_name ?? ""
                            let winePrice = Double(beverage.price_in_cents! / 100) * 0.77
                            self.priceLabel.text = "GrapeFinds estimated Price: \(winePrice)$"
                            let wineColorText = beverage.secondary_category!.replacingOccurrences(of: "Wine", with: "")
                            self.wineColorIcon = wineColorText
                            self.wineColorLabel.text = "Color: \(wineColorText)"
                            self.wineImageView.image = image
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            
                            self.overView.append(beverage.tasting_note ?? "no overview")
                            self.pairsWith.append(beverage.serving_suggestion ?? "no serving suggestion provided")
                            self.beverage = beverage
                            
                            
                            self.findProducerButton.isUserInteractionEnabled = true
                            self.findProducerButton.isHidden = false
                            
                            self.addWineToCellarButton.isUserInteractionEnabled = true
                            self.addWineToCellarButton.isHidden = false
                            
                            self.openNoteViewButton.isUserInteractionEnabled = true
                            self.openNoteViewButton.isHidden = false
                            self.wineInfoStackView.isHidden = false
                            self.tableView.isHidden = false
                            self.randomWineButton.isHidden = false
                            self.beginingActivityIndicator.isHidden = true
                            self.beginingActivityIndicator.stopAnimating()
                            
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
      
    }


    @IBAction func RandomWineButtonTapped(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let pageNumber = Int(arc4random_uniform(100) + 1)
        
        BeverageController.shared.fetchRandomBeverage(with: pageNumber) { (beverages) in
           if let beverages = beverages {
            let beverageIndex = Int(arc4random_uniform(4) + 1)
            let beverage = beverages[beverageIndex]
            BeverageController.shared.fetchBeverageImage(with: beverage, completion: { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.wineNameLabel.text = beverage.name
                        self.producerNameLabel.text = beverage.producer_name ?? ""
                        let winePrice = Double(beverage.price_in_cents! / 100) * 0.77
                        self.priceLabel.text = "GrapeFinds estimated Price: \(winePrice)$"
                        let wineColorText = beverage.secondary_category!.replacingOccurrences(of: "Wine", with: "")
                        self.wineColorIcon = wineColorText
                        self.wineColorLabel.text = "Color: \(wineColorText)"
                        
                        self.wineImageView.image = image
                        self.beverage = beverage
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        
                        self.overView.append(beverage.tasting_note ?? "no overview")
                        self.pairsWith.append(beverage.serving_suggestion ?? "no serving suggestion provided")
                        
                        self.tableView.reloadData()
                }
            }
        })
    }
}
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 36
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverViewCell", for: indexPath) as? RandomWineOverviewCell else {return UITableViewCell()}
            
                let text = beverage?.tasting_note ?? "No information provided"
                cell.summaryTextView.text = text
            
            return cell
        }
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "pairsWith", for: indexPath) as? RandomWinePairsWithCell else {return UITableViewCell()}
        
                let text = self.beverage?.serving_suggestion ?? "No information provided"
                cell.pairsWithTextView.text = text
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    @IBAction func noteButtonTapped(_ sender: Any) {
        noteView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.noteView.center.y -= 700
        }
        tableView.isUserInteractionEnabled = false
    }
    
    @IBAction func pinButtonTapped(_ sender: Any) {
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
    @IBAction func noteViewCancelButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.7) {
            self.noteView.center.y += 700
        }
        tableView.isUserInteractionEnabled = true
       noteTextView.text = ""
    }
    
    
    @IBAction func noteViewAddNoteButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.7) {
            self.noteView.center.y += 700
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapKitVC" {
            let VC = segue.destination as! UINavigationController
            let mapVC = VC.topViewController as! MapViewController
            mapVC.beverage = beverage
            print("")
        }
    }
}
