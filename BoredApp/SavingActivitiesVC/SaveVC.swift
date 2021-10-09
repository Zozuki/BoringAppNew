//
//  ViewController.swift
//  BoredApp
//
//  Created by user on 28.09.2021.
//

import UIKit

class SaveVC: UIViewController {

    //MARK: - Properties
    var stackContainer: StackContainerView?
    let reloadButton = UIButton()
    let dataStoreManager = DataStoreManager()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        stackContainer?.dataSource = self
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.systemBackground
        configureReloadButton()
        stackContainer = StackContainerView()
        stackContainer?.isMainView = false
        view.addSubview(stackContainer ?? UIView())
        configureStackContainer()
        stackContainer?.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureStackContainer() {
        stackContainer?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackContainer?.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackContainer?.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    func configureReloadButton() {
        view.addSubview(reloadButton)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 100)
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: symbolConfig)
        reloadButton.setImage(image, for: .normal)
        reloadButton.bounds.size = CGSize(width: 400, height: 400)
        reloadButton.tintColor = UIColor.systemGray
        reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reloadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        reloadButton.addTarget(self, action: #selector(reloadButtonAction), for: .touchUpInside)
    }
    // saves
    @objc func reloadButtonAction(sender: UIButton!) {
        UIView.animate(withDuration: 0.2, animations: {
            self.reloadButton.tintColor = UIColor.green
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, animations: {
                self.reloadButton.tintColor = UIColor.systemGray
            }, completion: {_ in
                self.stackContainer?.reloadData()
            })
        })
    }
    
}

extension SaveVC : SwipeCardsDataSource {
    
    func numberOfCardsToShow() -> Int {
        return  dataStoreManager.getActivityFromCoreData().count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource =  dataStoreManager.getActivityFromCoreData()[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }

}
