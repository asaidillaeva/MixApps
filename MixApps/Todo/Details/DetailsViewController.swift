//
//  DetailsViewController.swift
//  MixApps
//
//  Created by Aliia Saidillaeva  on 25/6/22.

import UIKit


protocol DetailViewControllerDelegate: AnyObject {
    func detailViewController(added item: Todo)
    func detailViewController(edited item: Todo)
}

class DetailsViewController: UIViewController {

    public weak var itemToEdit: Todo?
    public weak var delegate: DetailViewControllerDelegate?
    
    private var viewModel: ITodoViewModel
    
    init(vm: ITodoViewModel = TodoViewModel()) {
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                                                       action: #selector(didTapButton(_:)))
        
        self.navigationItem.leftBarButtonItem = .init(title: "Отмена",
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(didTapButton(_:)))
        
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
    
    @objc func didTapButton(_ sender: UIBarButtonItem) {
        if sender == self.navigationItem.rightBarButtonItem {
            save()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func save(){
        if titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            titleTextField.text = "Без названия"
        }
        
        if descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            descriptionTextField.text = "Без описания"
        }
        
        if let itemToEdit = itemToEdit {
            itemToEdit.title = titleTextField.text!
            itemToEdit.desc = descriptionTextField.text!
            delegate?.detailViewController(edited: itemToEdit)
        } else {
            let todo: Todo = .init(
                titleTextField.text! ,
                descriptionTextField.text!,
                false)
            viewModel.save(todo: todo)
            delegate?.detailViewController(added: todo)
            navigationController?.popViewController(animated: true)
        }
    }
    
}
