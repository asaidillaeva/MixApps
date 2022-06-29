//
//  TodoViewController.swift
//  MixApps
//
//  Created by Aliia Saidillaeva  on 25/6/22.
//

import UIKit

class TodoViewController: UIViewController {
    
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        view.tintColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        view.tintColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return view
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isEmptySearchBar: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var viewModel: ITodoViewModel
    
    init(vm: ITodoViewModel = TodoViewModel()) {
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.isFiltering = searchController.isActive && !isEmptySearchBar
        tableView.delegate = self
        tableView.dataSource = self
        setup()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Найти задачу"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.data.count == 0 {
            animate()
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if sender === addButton {
            add()
        } else if sender === editButton {
            edit()
        }
    }
    
    func add() {
        let detailsViewController = DetailsViewController()
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func edit() {
        tableView.isEditing.toggle()
        if tableView.isEditing {
            addButton.isHidden = true
            editButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            editButton.tintColor = .systemBlue
        } else {
            addButton.isHidden = false
            editButton.setBackgroundImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
            editButton.tintColor = .systemGreen
        }
    }
    
    private func setup(){
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(editButton)
        
        navigationItem.title = "Список задач"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private lazy var addButtonTrailingConstraint: NSLayoutConstraint = {
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
    }()
    
    private func setupConstraints() {
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            editButton.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant:  -15),
            editButton.widthAnchor.constraint(equalToConstant: 50),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            addButtonTrailingConstraint,
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -25),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func animate() {
        let width = view.frame.width
        addButton.transform = .init(translationX: -width , y: 0)
        addButton.alpha = 0
        UIView.animateKeyframes(withDuration: 1, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2) {
                var transform = self.addButton.transform
                transform = transform.translatedBy(x: width/2, y: 0)
                self.addButton.transform = transform
                self.addButton.alpha = 1/2
            }
            UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
                var transform = self.addButton.transform
                transform = transform.translatedBy(x: width/2, y: 0)
                self.addButton.transform = transform
                self.addButton.alpha = 1
            }
        }
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as! TodoCell
        cell.setTodo( viewModel.data[indexPath.row] )
        cell.delegate = self
        cell.tappedIndex = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TodoCell{
            cell.cellSelected(isSelected: viewModel.update(index: indexPath.row).isDone)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.changeOrder(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        } else if editingStyle == .insert {
            let rowIndex = viewModel.data.count - 1
            let indexPath = IndexPath(row: rowIndex, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at:  [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        let detailsViewController = DetailsViewController()
        let item = viewModel.data[indexPath.row]
        detailsViewController.itemToEdit = item
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
}

extension TodoViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.isFiltering = true
        [addButton, editButton].forEach { button in
            button.isHidden = true
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.isFiltering = false
        [addButton, editButton].forEach { button in
            button.isHidden = false
        }
    }
}

extension TodoViewController: DetailViewControllerDelegate {
    
    func detailViewController(edited item: Todo) {
        if let index = viewModel.data.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? TodoCell {
                cell.setTodo(item)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func detailViewController(added item: Todo) {
        viewModel.updateDefaultsList()
        let rowIndex = viewModel.data.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at:  [indexPath], with: .left)
        tableView.endUpdates()
    }
}

extension TodoViewController: TodoCellDelegate {
    func didTapCheckMark(index: Int) {
        if let cell: TodoCell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TodoCell {
            cell.cellSelected(isSelected: viewModel.update(index: index).isDone)
        }
    }
}

extension TodoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        viewModel.updateDataByTitle(title: searchController.searchBar.text?.lowercased() ?? "" )
        tableView.reloadData()
    }
}
