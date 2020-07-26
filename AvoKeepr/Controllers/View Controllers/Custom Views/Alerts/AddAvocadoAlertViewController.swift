//
//  AddAvocadoAlertViewController.swift
//  AvoKeeperV1
//
//  Created by David on 5/7/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class AddAvocadoAlertViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var ripeCountLabel: UILabel!
    @IBOutlet weak var almostRipeCountLabel: UILabel!
    @IBOutlet weak var notRipeCountLabel: UILabel!
    @IBOutlet weak var notRipeLabel: UILabel!
    @IBOutlet weak var almostRipeLabel: UILabel!
    @IBOutlet weak var ripeLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var ripeStepper: UIStepper!
    @IBOutlet weak var almostRipeStepper: UIStepper!
    @IBOutlet weak var notRipeStepper: UIStepper!
    @IBOutlet var allSteppers: [UIStepper]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        
        let enabledStepperWeight = UIImage.SymbolWeight.heavy
        let disabledStepperWeight = UIImage.SymbolWeight.ultraLight
        
        for stepper in allSteppers {
            stepper.autorepeat = true
            stepper.maximumValue = 10
            stepper.minimumValue = 0
            stepper.layer.cornerRadius = 10
            stepper.tintColor = Colors.backgroundColor
            stepper.setIncrementImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: enabledStepperWeight)), for: .normal)
            stepper.setIncrementImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: disabledStepperWeight)), for: .disabled)
            stepper.setDecrementImage(UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(weight: enabledStepperWeight)), for: .normal)
            stepper.setDecrementImage(UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(weight: disabledStepperWeight)), for: .disabled)
        }
        
        ripeStepper.backgroundColor = Colors.ripeColor
        almostRipeStepper.backgroundColor = Colors.almostRipeColor
        notRipeStepper.backgroundColor = Colors.notRipeColor
        
        ripeLabel.textColor = Colors.ripeColor
        ripeCountLabel.textColor = Colors.ripeColor
        almostRipeLabel.textColor = Colors.almostRipeColor
        almostRipeCountLabel.textColor = Colors.almostRipeColor
        notRipeLabel.textColor = Colors.notRipeColor
        notRipeCountLabel.textColor = Colors.notRipeColor
        
        alertView.layer.cornerRadius = 11
        
        addButton.backgroundColor = .lightGray
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        addButton.layer.cornerRadius = 11
        addButton.setTitle("ADD", for: .normal)
        addButton.isHidden = true
    }
    
    func updateAddButton() {
        
        let avocadoCount = Int(ripeStepper.value) + Int(almostRipeStepper.value) + Int(notRipeStepper.value)
        
        if avocadoCount == 0 {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
        updateAddButton()
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if sender == ripeStepper {
            ripeCountLabel.text = "\(Int(sender.value).description)"
        } else if sender == almostRipeStepper {
            almostRipeCountLabel.text = "\(Int(sender.value).description)"
        } else {
            notRipeCountLabel.text = "\(Int(sender.value).description)"
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        if Int(ripeStepper.value) == 0 && Int(almostRipeStepper.value) == 0  && Int(notRipeStepper.value) == 0 { return }
        
        AvocadoController.shared.addRipeAvocado(count: Int(ripeStepper.value))
        AvocadoController.shared.addAlmostRipeAvocado(count: Int(almostRipeStepper.value))
        AvocadoController.shared.addNotRipeAvocado(count: Int(notRipeStepper.value))
        
        NotificationCenter.default.post(name: Notification.Name("AvocadosAdded"), object: nil)
        
        dismiss(animated: true)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
