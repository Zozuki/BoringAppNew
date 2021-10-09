//
//  DetailViewController.swift
//  BoredApp
//
//  Created by user on 21.09.2021.
//

import UIKit
import CDAlertView

final class DetailViewController: UIViewController {
    
    //MARK: - Properties
    
//    private let presenter: DetailViewOutput
    private let presenter = DetailPresenter()
    weak var delegate: ModalViewControllerDelegate?
    
    private var detailView: DetailView {
        return self.view as! DetailView
    }
   
    
    // MARK: - Lifecycle
    
//    required init(presenter: DetailViewOutput) {
//        self.presenter = presenter
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func loadView() {
        super.loadView()
        self.view = detailView
        presenter.viewInput = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.modalControllerWillDisapear(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        detailView.participantsTextField?.delegate = self
        detailView.configurateLoadingScreenWithCriteria()
    }
    
    //MARK: - Handlers
    @IBAction func changePriceCriteria(_ sender: Any) {
        if detailView.priceSwitcher!.isOn {
            ActivitySearchCriteria.shared.price = 0.1
            presenter.didChangeParticipantsOrPrice()
        } else {
            ActivitySearchCriteria.shared.price = 0
            presenter.didChangeParticipantsOrPrice()
        }
    }
    

    @IBAction func startEditingText(_ sender: Any) {
        guard let text = detailView.participantsTextField?.text, let intFromText = Int(text) else { return }
        if intFromText > 4 || intFromText == 0  {
            detailView.participantsTextField?.text = "4"
            ActivitySearchCriteria.shared.participants = 4
            presenter.didChangeParticipantsOrPrice()
        } else {
            ActivitySearchCriteria.shared.participants = intFromText
            presenter.didChangeParticipantsOrPrice()
        }
    }
    
    @IBAction func allButtonTapped(_ sender: Any) {
        for activity in ActivitySearchCriteria.shared.types {
            detailView.configurePressedButtons(activity: activity)
        }
        ActivitySearchCriteria.shared.types.removeAll()
        detailView.changeButtonColour(button: detailView.allButton)
    }
    
    @IBAction func educationButtonTapped(_ sender: Any) {
        presenter.didChangeActivityType(activity: .education)
    }
    
    
    @IBAction func recreationalButtonTapped(_ sender: Any) {
        presenter.didChangeActivityType(activity: .recreational)
    }
    
    @IBAction func DIYButtonTapped(_ sender: Any) {
        presenter.didChangeActivityType(activity: .diy)
    }
    
    @IBAction func charityButtonTapped(_ sender: Any) {
        presenter.didChangeActivityType(activity: .charity)
    }
    
    @IBAction func cookingButtonTapped(_ sender: Any) {
        presenter.didChangeActivityType(activity: .cooking)
    }
    
    @IBAction func socialButtonTapped(_ sender: Any) {
        presenter.didChangeActivityType(activity: .social)
    }
    
    @IBAction func musicButtonTapped(_ sender: Any) {
        presenter.didChangeActivityType(activity: .music)
    }
    
    @IBAction func busyworkButtonTapped(_ sender: Any) {
        presenter.didChangeActivityType(activity: .busywork)
    }
    
    @IBAction func relaxationButtonTapped(_ sender: Any) {
        presenter.didChangeActivityType(activity: .relaxation)
    }
}


// MARK: UITextFieldDelegate
extension DetailViewController: UITextFieldDelegate  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        detailView.participantsTextField?.resignFirstResponder()
        return true
    }
}

// MARK: SearchViewInput
extension DetailViewController: DetailViewInput {
    
    func configurePressedButtons(activity: activities) {
        detailView.configurePressedButtons(activity: activity)
    }
    
    func changeActivityList(activity: activities) {
       detailView.changeActivityList(activity: activity)
    }
    
    func showErrorCDAlert(error: String?) {
        let ac = CDAlertView(title: error, message: "", type: .notification)
        ac.add(action: CDAlertViewAction(title: "Ok"))
        ac.show()
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        detailView.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        textFieldShouldReturn(detailView.participantsTextField!)
    }
}
