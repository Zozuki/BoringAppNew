//
//  ActivityCriteriaPresenter.swift
//  BoredApp
//
//  Created by user on 28.09.2021.
//

import UIKit

protocol DetailViewInput: AnyObject {
    func showErrorCDAlert(error: String?)
    func configurePressedButtons(activity: activities)
    func changeActivityList(activity: activities)
}

protocol DetailViewOutput: AnyObject {
    func didChangeActivityType(activity: activities)
    func didChangeParticipantsOrPrice()
}

class DetailPresenter {
    
    weak var viewInput: (UIViewController & DetailViewInput)?
    private let searchService = Service()
    var alertIsPresented = false
    
    func checkType(activity: activities) {
        viewInput?.configurePressedButtons(activity: activity)
        ActivitySearchCriteria.shared.searchWithTypeCriteria(type: activity, completion: { [weak self] error in
            if error != nil {
                self?.viewInput?.configurePressedButtons(activity: activity)
                if !self!.alertIsPresented {
                    self?.viewInput?.showErrorCDAlert(error: error!.error)
                    self?.alertIsPresented = true
                }
            }
            if error == nil {
                self?.viewInput?.changeActivityList(activity: activity)
            }
        })
        if alertIsPresented {
            alertIsPresented = false
        }
    }
    
    func checkThePossibilityToFindActivity() {
        ViewModelDataStorage.shared.activityModels.removeAll()
        
        for activity in ActivitySearchCriteria.shared.types {
            DispatchQueue.global(qos: .userInitiated).sync {
                ActivitySearchCriteria.shared.searchWithTypeCriteria(type: activity, completion: { [weak self] error in
                    if error != nil {
                        if !self!.alertIsPresented {
                            self?.viewInput?.showErrorCDAlert(error: error!.error)
                            self?.alertIsPresented = true
                        }
                        self?.viewInput?.configurePressedButtons(activity: activity)
                        guard let index = ActivitySearchCriteria.shared.types.lastIndex(of: activity) else { return }
                        ActivitySearchCriteria.shared.types.remove(at: index)
                    }
                })
            }
        }
        if alertIsPresented {
            alertIsPresented = false
        }
    }
    
}

extension DetailPresenter: DetailViewOutput {
    func didChangeActivityType(activity: activities) {
        checkType(activity: activity)
    }
    func didChangeParticipantsOrPrice() {
        checkThePossibilityToFindActivity()
    }
}
