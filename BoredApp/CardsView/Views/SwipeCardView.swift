//
//  SwipeCardView.swift
//  BoredApp
//
//  Created by user on 20.09.2021.
//

import UIKit

class SwipeCardView : UIView {
   
    //MARK: - Properties
    var swipeView : UIView?
    var shadowMainView : UIView?
    var shadowTypeLableView: UIView?
    var activityTextLabel = UILabel()
    var activityTypeLabel = UILabel()
    var activityParticipantsLabel = UILabel()
    var activityPriceLabel = UILabel()
    var starButton = UIButton()
    var delegate: SwipeCardsDelegate?
    var divisor: CGFloat = 0
    let baseView = UIView()
    let symbolConfig = UIImage.SymbolConfiguration(textStyle: .title1)
    
    private let dataStoreManager = DataStoreManager()
    
    var dataSource : ActivityCardsDataModel? {
        didSet {
            guard let dataSource = dataSource else { return }
            swipeView?.backgroundColor = .white
            activityTextLabel.text = dataSource.activityText
            activityTypeLabel.text = dataSource.activityType
            activityTypeLabel.backgroundColor = dataSource.bgTypeColor
            configureParticipantsText(with: dataSource.activityParticipants)
            configurePriceText(with: dataSource.activityPrice)
        }
    }
    
    //MARK: - Init
     override init(frame: CGRect) {
        super.init(frame: .zero)
        configureShadowView()
        configureSwipeView()
        configureActivityTextLabelView()

        configureTypeLabelWithShadowView()
        
        configureActivityParticipantsLabellView()
        configureActivityPriceLabellView()
        configureStarButton()
        addPanGestureOnCards()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    
    func configureParticipantsText(with count: Int?) {
        let participantsLabelAttachment = NSTextAttachment()
        participantsLabelAttachment.image = UIImage(systemName: "person.fill", withConfiguration: symbolConfig)
        let participantsImageString = NSMutableAttributedString(attachment: participantsLabelAttachment)
        let participantsTextString = NSAttributedString(string: " " + String(describing: count ?? 1))
        participantsImageString.append(participantsTextString)
        activityParticipantsLabel.attributedText = participantsImageString
    }
    
    func configurePriceText(with price: Double?) {
        let priceAttachment = NSTextAttachment()
        priceAttachment.image = UIImage(systemName: "dollarsign.circle", withConfiguration: symbolConfig)
        let priceImageString = NSMutableAttributedString(attachment: priceAttachment)
        if price ?? 0 <= 0 {
            let priceTextString = NSAttributedString(string: " free")
            priceImageString.append(priceTextString)
            activityPriceLabel.attributedText = priceImageString
        } else {
            let priceTextString = NSAttributedString(string: " paid")
            priceImageString.append(priceTextString)
            activityPriceLabel.attributedText = priceImageString
            
        }
    }
    
    func configureShadowView() {
        shadowMainView = UIView()
        shadowMainView?.backgroundColor = .clear
        shadowMainView?.layer.shadowColor = UIColor.black.cgColor
        shadowMainView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowMainView?.layer.shadowOpacity = 0.8
        shadowMainView?.layer.shadowRadius = 4.0
        
        addSubview(shadowMainView ?? UIView())
        
        shadowMainView?.translatesAutoresizingMaskIntoConstraints = false
        shadowMainView?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shadowMainView?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shadowMainView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shadowMainView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func configureSwipeView() {
        swipeView = UIView()
        swipeView?.layer.cornerRadius = 15
        swipeView?.clipsToBounds = true
        shadowMainView?.addSubview(swipeView ?? UIView())
        guard let guardShadow = shadowMainView else { return }
        swipeView?.translatesAutoresizingMaskIntoConstraints = false
        swipeView?.leftAnchor.constraint(equalTo: guardShadow.leftAnchor).isActive = true
        swipeView?.rightAnchor.constraint(equalTo: guardShadow.rightAnchor).isActive = true
        swipeView?.bottomAnchor.constraint(equalTo: guardShadow.bottomAnchor).isActive = true
        swipeView?.topAnchor.constraint(equalTo: guardShadow.topAnchor).isActive = true
    }
    
    func configureActivityPriceLabellView() {
        swipeView?.addSubview(activityPriceLabel)
        activityPriceLabel.backgroundColor = .white
        activityPriceLabel.textColor = .gray
        activityPriceLabel.numberOfLines = 0
        activityPriceLabel.textAlignment = .left
        activityPriceLabel.font = UIFont.systemFont(ofSize: 25)
        activityPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        guard let guardSwipe = swipeView else { return }
        activityPriceLabel.rightAnchor.constraint(equalTo: guardSwipe.rightAnchor, constant: -20).isActive = true
        activityPriceLabel.bottomAnchor.constraint(equalTo: guardSwipe.bottomAnchor, constant: -10).isActive = true
        activityPriceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureActivityParticipantsLabellView() {
        swipeView?.addSubview(activityParticipantsLabel)
        activityParticipantsLabel.backgroundColor = .white
        activityParticipantsLabel.textColor = .gray
        activityParticipantsLabel.numberOfLines = 0
        activityParticipantsLabel.textAlignment = .left
        activityParticipantsLabel.font = UIFont.systemFont(ofSize: 25)
        activityParticipantsLabel.translatesAutoresizingMaskIntoConstraints = false
        guard let guardSwipe = swipeView else { return }
        activityParticipantsLabel.leftAnchor.constraint(equalTo: guardSwipe.leftAnchor, constant: 20).isActive = true
        activityParticipantsLabel.bottomAnchor.constraint(equalTo: guardSwipe.bottomAnchor, constant: -10).isActive = true
        activityParticipantsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureActivityTextLabelView() {
        swipeView?.addSubview(activityTextLabel)
        activityTextLabel.backgroundColor = .white
        activityTextLabel.textColor = .black
        activityTextLabel.numberOfLines = 0
        activityTextLabel.textAlignment = .left
        activityTextLabel.font = UIFont.systemFont(ofSize: 35)
        activityTextLabel.translatesAutoresizingMaskIntoConstraints = false
        guard let swipeView = swipeView else { return }
        activityTextLabel.leftAnchor.constraint(equalTo: swipeView.leftAnchor, constant: 20).isActive = true
        activityTextLabel.rightAnchor.constraint(equalTo: swipeView.rightAnchor, constant: -20).isActive = true
        activityTextLabel.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: -100).isActive = true
        activityTextLabel.heightAnchor.constraint(equalToConstant: 260).isActive = true
    }
    
    func configureActivityTypeLabelView() {
        swipeView?.addSubview(activityTypeLabel)
        activityTypeLabel.textColor = .white
        activityTypeLabel.layer.masksToBounds = true
        activityTypeLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        activityTypeLabel.layer.cornerRadius = 15
        activityTypeLabel.textAlignment = .center
        activityTypeLabel.font = UIFont.systemFont(ofSize: 18)
        activityTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        guard let swipeView = swipeView else { return }
        activityTypeLabel.leftAnchor.constraint(equalTo: swipeView.leftAnchor).isActive = true
        activityTypeLabel.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: -360).isActive = true
        activityTypeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureTypeLabelWithShadowView() {
        
        shadowTypeLableView = UIView()
        shadowTypeLableView?.backgroundColor = .white
        shadowTypeLableView?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        shadowTypeLableView?.layer.cornerRadius = 15
        shadowTypeLableView?.layer.shadowColor = UIColor.black.cgColor
        shadowTypeLableView?.layer.shadowOffset = CGSize(width: -2, height: 3)
        shadowTypeLableView?.layer.shadowOpacity = 1
        shadowTypeLableView?.layer.shadowRadius = 4
        swipeView?.addSubview(shadowTypeLableView ?? UIView())
        configureActivityTypeLabelView()
        shadowTypeLableView?.translatesAutoresizingMaskIntoConstraints = false
        shadowTypeLableView?.leftAnchor.constraint(equalTo: activityTypeLabel.leftAnchor).isActive = true
        shadowTypeLableView?.rightAnchor.constraint(equalTo: activityTypeLabel.rightAnchor).isActive = true
        shadowTypeLableView?.bottomAnchor.constraint(equalTo: activityTypeLabel.bottomAnchor).isActive = true
        shadowTypeLableView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureStarButton() {
        addSubview(starButton)
        starButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "star", withConfiguration: symbolConfig)
        starButton.setImage(image, for: .normal)
        starButton.bounds.size = CGSize(width: 100, height: 100)
        starButton.tintColor = UIColor.black
        guard let swipeView = swipeView else { return }
        starButton.rightAnchor.constraint(equalTo: swipeView.rightAnchor, constant: -10).isActive = true
        starButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        starButton.topAnchor.constraint(equalTo: swipeView.topAnchor, constant: 10).isActive = true
        starButton.addTarget(self, action: #selector(starButtonAction), for: .touchUpInside)
    }
    
    @objc func starButtonAction(sender: UIButton!) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.starButton.tintColor = UIColor.green
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2, animations: {
                self.starButton.tintColor = UIColor.black
            }, completion: {_ in
                guard let dataSource = self.dataSource else { return }
                var price = true
                if dataSource.activityPrice == 0 {
                    price = false
                }
                self.dataStoreManager.obtainActivity(type: dataSource.activityType, text: dataSource.activityText, participants: String(dataSource.activityParticipants), price: price)
            })
        })
    }

   
    
    
    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    
    
    //MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        let card = sender.view as! SwipeCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
        switch sender.state {
        case .ended:
            if (card.center.x) > 400 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            } else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
    
    
  
}
