//
//  ModalViewControllerProtocol.swift
//  BoredApp
//
//  Created by user on 27.09.2021.
//

import Foundation
protocol ModalViewControllerDelegate: AnyObject {
    func modalControllerWillDisapear(_ modal: DetailViewController)
}
