//
//  TodoCell.swift
//  MixApps
//
//  Created by Aliia Saidillaeva  on 25/6/22.

import Foundation
import UIKit

protocol TodoCellDelegate: AnyObject{
    func didTapCheckMark(index: Int)
}

class TodoCell: UITableViewCell{
     
    weak var delegate: TodoCellDelegate?
    var tappedIndex: Int?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var doneButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        view.tintColor = .orange
        view.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        accessoryType = .detailDisclosureButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSelected(isSelected: Bool) {
        doneButton.setBackgroundImage(UIImage(
            systemName: isSelected ? "checkmark.circle.fill" : "circle" ),
            for: .normal)
    }
  
    private func setup(){
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        contentView.addSubview(doneButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        let constraints = [
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            doneButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            doneButton.heightAnchor.constraint(equalToConstant: 25),
            doneButton.widthAnchor.constraint(equalToConstant: 25),
            
            titleLabel.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 15),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func tapped() {
        delegate?.didTapCheckMark(index: tappedIndex ?? 0)
    }
    
    func setTodo(_ todo: Todo){
        titleLabel.text = todo.title
        descriptionLabel.text = todo.desc
        let image = UIImage(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
        doneButton.setBackgroundImage(image, for: .normal)
    }
}

extension UITableViewCell {
    
    var identifier: String {
        .init(describing: self)
    }
    
    static var identifier: String {
        .init(describing: self)
    }
}
