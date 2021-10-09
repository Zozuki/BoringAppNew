//
//  DetailView.swift
//  BoredApp
//
//  Created by user on 21.09.2021.
//

import UIKit

class DetailView : UIView {
   
    //MARK: - Properties
    @IBOutlet weak var priceSwitcher: UISwitch?
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var educationButton: UIButton!
    @IBOutlet weak var recreationalButton: UIButton!
    @IBOutlet weak var DIYButton: UIButton!
    @IBOutlet weak var charityButton: UIButton!
    @IBOutlet weak var cookingButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var busyworkButton: UIButton!
    @IBOutlet weak var relaxationButton: UIButton!
    @IBOutlet weak var participantsTextField: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configurateLoadingScreenWithCriteria()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configurateLoadingScreenWithCriteria()
    }
    
    
    //MARK: - Configuration
    func configurateLoadingScreenWithCriteria() {
        let buttons = [allButton, educationButton, recreationalButton, DIYButton, charityButton, cookingButton, socialButton, musicButton, busyworkButton, relaxationButton]
        confugureButtons(buttons: buttons)
        
        if ActivitySearchCriteria.shared.types.isEmpty {
            changeButtonColour(button: allButton)
        } else {
            for activity in ActivitySearchCriteria.shared.types {
                configurePressedButtons(activity: activity)
            }
        }

        participantsTextField?.text = "\(ActivitySearchCriteria.shared.participants)"

        if ActivitySearchCriteria.shared.price > 0 {
            priceSwitcher?.isOn = true
        } else {
            priceSwitcher?.isOn = false
        }
    }
    
    func configurePressedButtons(activity: activities) {
        switch activity {
        case .busywork:
            changeButtonColour(button: busyworkButton)
        case .charity:
            changeButtonColour(button: charityButton)
        case .cooking:
            changeButtonColour(button: cookingButton)
        case .diy:
            changeButtonColour(button: DIYButton)
        case .education:
            changeButtonColour(button: educationButton)
        case .music:
            changeButtonColour(button: musicButton)
        case .recreational:
            changeButtonColour(button: recreationalButton)
        case .relaxation:
            changeButtonColour(button: relaxationButton)
        case .social:
            changeButtonColour(button: socialButton)
        }
    }
    
    func confugureButtons(buttons: [UIButton?]) {
        for button in buttons {
            button?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
            button?.layer.cornerRadius = 15
            button?.layer.shadowColor = UIColor.black.cgColor
            button?.layer.shadowOffset = CGSize(width: -2, height: 3)
            button?.layer.shadowOpacity = 1
            button?.layer.shadowRadius = 2
        }
    }
    
    
    func changeButtonColour(button: UIButton?) {
        UIView.animate(withDuration: 0.3, animations: {
            button?.isUserInteractionEnabled = false
            if button?.layer.borderColor == #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1) {
                button?.layer.borderWidth = 0
                button?.layer.borderColor = .none
                button?.layer.shadowOpacity = 1
                button?.isUserInteractionEnabled = true
            } else {
                button?.layer.borderWidth = 4
                button?.layer.borderColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
                button?.layer.shadowOpacity = 0
                button?.isUserInteractionEnabled = true
            }
        })
    }
    
    func changeActivityList(activity: activities) {
        if !ActivitySearchCriteria.shared.types.contains(activity) {
            ActivitySearchCriteria.shared.types.append(activity)
        } else {
            guard let index = ActivitySearchCriteria.shared.types.lastIndex(of: activity) else { return }
            ActivitySearchCriteria.shared.types.remove(at: index)
        }
    }
    
}
