//
//  AddWineViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/6/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit

class AddWineViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var addWineButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var producerNameField: UITextField!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var priceNameField: UITextField!
    @IBOutlet weak var addWineView: UIView!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var sparklingButton: UIButton!
    

    
    var wineColor = ""
    
    var wine: Wine?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        summaryTextView.delegate = self
        
        view.backgroundColor = UIColor(red: 220/250, green: 220/250, blue: 220/250, alpha: 0.90)
        
        nameTextField.backgroundColor = UIColor(red: 250/255, green: 250/250, blue: 210/250, alpha: 1)
        nameTextField.addDoneButtonOnKeyboard()
        producerNameField.backgroundColor = UIColor(red: 250/255, green: 250/250, blue: 210/250, alpha: 1)
        producerNameField.addDoneButtonOnKeyboard()
        priceNameField.backgroundColor = UIColor(red: 250/255, green: 250/250, blue: 210/250, alpha: 1)
        priceNameField.addDoneButtonOnKeyboard()
        priceNameField.keyboardType = .decimalPad
        summaryTextView.layer.cornerRadius = 10
        summaryTextView.backgroundColor = UIColor(red: 250/255, green: 250/250, blue: 210/250, alpha: 1)
        summaryTextView.addDoneButtonOnKeyboard()
        summaryTextView.tag = 1
        noteTextView.layer.cornerRadius = 10
        noteTextView.tag = 2
        
        noteTextView.backgroundColor = UIColor(red: 250/255, green: 250/250, blue: 210/250, alpha: 1)
        noteTextView.addDoneButtonOnKeyboard()
        backButton.layer.cornerRadius = 10
        
        redButton.backgroundColor = Colors.lightBrown
        redButton.layer.cornerRadius = 10
        whiteButton.backgroundColor = Colors.lightBrown
        whiteButton.layer.cornerRadius = 10
        sparklingButton.backgroundColor = Colors.lightBrown
        
        sparklingButton.layer.cornerRadius = 10
        
        
        addWineView.backgroundColor = Colors.darkGreen

    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.tag == 1 {
            self.view.frame.origin.y -= 125
            noteTextView.isUserInteractionEnabled = false
            priceNameField.isUserInteractionEnabled = false
            redButton.isUserInteractionEnabled = false
            whiteButton.isUserInteractionEnabled = false
        }
        if textView.tag == 2 {
            self.view.frame.origin.y -= 250
            summaryTextView.isUserInteractionEnabled = false
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 1 {
            self.view.frame.origin.y += 125
            noteTextView.isUserInteractionEnabled = true
            priceNameField.isUserInteractionEnabled = true
            redButton.isUserInteractionEnabled = true
            whiteButton.isUserInteractionEnabled = true
            
        }
        if textView.tag == 2 {
            self.view.frame.origin.y += 250
            summaryTextView.isUserInteractionEnabled = true
        }
    }

    @IBAction func whiteButtonTapped(_ sender: Any) {
        wineColor = "White"
        redButton.isEnabled = false
        redButton.backgroundColor = UIColor.gray
        sparklingButton.isEnabled = false
        sparklingButton.backgroundColor = UIColor.gray
    }
    
    
    @IBAction func redButtonTapped(_ sender: Any) {
        wineColor = "Red"
        whiteButton.isEnabled = false
        whiteButton.backgroundColor = UIColor.gray
        sparklingButton.isEnabled = false
        sparklingButton.backgroundColor = UIColor.gray
    }
    
    @IBAction func sparklingButtonTapped(_ sender: Any) {
        wineColor = "Sparkling"
        whiteButton.isEnabled = false
        whiteButton.backgroundColor = UIColor.gray
        redButton.isEnabled = false
        redButton.backgroundColor = UIColor.gray
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        
        guard let name = nameTextField.text, name.count > 0 else { return }
        guard let producer = producerNameField.text else {return}
        guard let price = priceNameField.text else {return}
        guard let summary = summaryTextView.text else { return }
        guard let note = noteTextView.text else { return }
    
        if wineColor == "Red" {
        
            WineController.shared.addWine(name: name, color: wineColor, producer: producer, price: price, summary: summary, note: note)
        }
        if wineColor == "White" {
            WineController.shared.addWine(name: name, color: wineColor, producer: producer, price: price, summary: summary, note: note)
        }
        if wineColor == "Sparkling" {
            WineController.shared.addWine(name: name, color: wineColor, producer: producer, price: price, summary: summary, note: note)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "tabeBarController")
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "tabeBarController")
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    
}

