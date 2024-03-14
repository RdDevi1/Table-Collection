//
//  HorizontalItemCell.swift
//  Table&Collection
//
//  Created by Vitaly Anpilov on 13.03.2024.
//

import UIKit

class HorizontalItemCell: UICollectionViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = Constants.Cell.borderWidth
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = CGFloat(Constants.Cell.cornerRadius)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     private lazy var numberLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(numberLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            numberLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func updateCellNumber(to number: Int) {
        numberLabel.text = "\(number)"
    }
    
    func setupCell(with item: HorizontalItem) {
        numberLabel.text = "\(item.number)"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopAnimation()
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: Constants.Cell.animationDiration) {
            self.containerView.transform = CGAffineTransform(scaleX: Constants.Cell.amountScale, y: Constants.Cell.amountScale)
        }
    }
    
    private func stopAnimation() {
        UIView.animate(withDuration: Constants.Cell.animationDiration) {
            self.containerView.transform = .identity
        }
    }
}
