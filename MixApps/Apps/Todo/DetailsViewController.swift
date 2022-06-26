//
//  DetailsViewController.swift
//  MixApps
//
//  Created by Aliia Saidillaeva  on 25/6/22.

import UIKit


protocol DetailViewControllerDelegate: AnyObject {
    func detailViewController(_ controller: DetailsViewController, added item: Todo)
    func detailViewController(_ controller: DetailsViewController, edited item: Todo)
}

class DetailsViewController: UIViewController {
    let defaults = TodoDefaults()

    public weak var itemToEdit: Todo?
    public weak var delegate: DetailViewControllerDelegate?
    
    
    private let titleTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Название"
        text.font = .systemFont(ofSize: 20)
        text.backgroundColor = UIColor.white
        text.borderStyle = .roundedRect
        text.textAlignment = .left
        text.contentVerticalAlignment = .top
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let descriptionTextField: UITextField = {
        let text = UITextField()
        text.font = .systemFont(ofSize: 20)
        text.placeholder = "Описание"
        text.textAlignment = .left
        text.contentVerticalAlignment = .top
        text.backgroundColor = UIColor.white
        text.borderStyle = .roundedRect
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = .init(title: "Сохранить",
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(save))
        
        self.navigationItem.leftBarButtonItem = .init(title: "Отмена",
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(cancel))
        
        if let itemToEdit = itemToEdit {
            navigationItem.title = "Редактирование"
            titleTextField.text = itemToEdit.title
            descriptionTextField.text = itemToEdit.desc
        } else {
            navigationItem.title = "Новая Запись"

        }
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        titleTextField.becomeFirstResponder()
    }
    
    private func setupConstraints() {
        let constraints = [
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleTextField.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.topAnchor, constant: 95),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            titleTextField.heightAnchor.constraint(equalToConstant: 70),
            
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            descriptionTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func save(){
        if titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            titleTextField.text = "Без названия"
        }
        
        if descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            descriptionTextField.text = "Без описания"
        }
        
        
        if let itemToEdit = itemToEdit {
            itemToEdit.title = titleTextField.text!
            itemToEdit.desc = descriptionTextField.text!
            delegate?.detailViewController(self, edited: itemToEdit)
        } else {
            let todo: Todo = .init(
                titleTextField.text! ,
                descriptionTextField.text!,
                false)
            defaults.save(todo: todo)
            defaults.updateList()
            delegate?.detailViewController(self, added: todo)
            navigationController?.popViewController(animated: true)
        }
    }
    
}
