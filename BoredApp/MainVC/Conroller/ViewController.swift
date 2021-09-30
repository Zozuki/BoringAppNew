//
//  ViewController.swift
//  BoredApp
//
//  Created by user on 20.09.2021.
//

import UIKit
import CDAlertView
class ViewController: UIViewController {
    
    //MARK: - Properties
    var stackContainer: StackContainerView?
    let reloadButton = UIButton()
    
    //MARK: - Init
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.systemBackground
        configureReloadButton()
        stackContainer = StackContainerView()
        view.addSubview(stackContainer ?? UIView())
        configureStackContainer()
        stackContainer?.translatesAutoresizingMaskIntoConstraints = false
        configureNavigationBarButtonItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkConnection()
        stackContainer?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stackContainer?.isMainView = true
    }
 
    //MARK: - Configurations
    func checkConnection() {
        ActivitySearchCriteria.shared.search { [weak self] error in
            if error != nil {
                DispatchQueue.main.async {
                    self?.showErrorAlert(error: error?.error)
                }
            } else {
                self?.loadActivity()
            }
            self?.stackContainer?.reloadData()
        }
    }
    
    func loadActivity() {
        for _ in 1...2 {
            ActivitySearchCriteria.shared.search { [weak self] error in
                self?.stackContainer?.reloadData()
            }
        }
    }
    
    func showErrorAlert(error: String?) {
        let ac = CDAlertView(title: error, message: "", type: .notification)
        ac.add(action: CDAlertViewAction(title: "Ok"))
        ac.show()
    }
    
    func configureStackContainer() {
        stackContainer?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackContainer?.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackContainer?.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    func configureNavigationBarButtonItem() {
        let rightBarImage = configureImageForNavButtonImage(systemName: "slider.horizontal.3")
        navigationController?.navigationBar.tintColor = UIColor.systemGray
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: rightBarImage.image, style: .plain, target: self, action: #selector(showDetailTapped))
        
        let leftBarImage = configureImageForNavButtonImage(systemName: "star")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: leftBarImage.image, style: .plain, target: self, action: #selector(showSavingVCTapped))
    }
    
    func configureImageForNavButtonImage(systemName: String) -> UIImageView {
        let symbolConfig = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        let imageView = UIImageView(image: UIImage(systemName: systemName, withConfiguration: symbolConfig))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
        return imageView
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
    
    @objc func reloadButtonAction(sender: UIButton!) {
        UIView.animate(withDuration: 0.2, animations: {
            self.reloadButton.tintColor = UIColor.green
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, animations: {
                self.reloadButton.tintColor = UIColor.systemGray
            }, completion: {_ in
                ViewModelDataStorage.shared.activityModels.removeAll()
                self.checkConnection()
            })
        })
    }
    
    //MARK: - Handlers
    @objc func showDetailTapped() {
        let detailVC = storyboard?.instantiateViewController(identifier: "DetailVC") as! DetailViewController
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .automatic
        present(detailVC, animated: true)

//        guard let rootVC = DetailBuilder.build() as? DetailViewController else {return}
//        rootVC.modalPresentationStyle = .automatic
//        rootVC.delegate = self
//        present(rootVC, animated: true)
    }
    
    @objc func showSavingVCTapped() {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "SaveVC") as! SaveVC
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

//MARK: - SwipeCardsDataSource
extension ViewController : SwipeCardsDataSource {
    
    func numberOfCardsToShow() -> Int {
        return ViewModelDataStorage.shared.activityModels.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = ViewModelDataStorage.shared.activityModels[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }

}

//MARK: - ModalViewControllerDelegate
extension ViewController: ModalViewControllerDelegate {
    func modalControllerWillDisapear(_ modal: DetailViewController) {
        ViewModelDataStorage.shared.activityModels.removeAll()
        self.checkConnection()
    }
}

