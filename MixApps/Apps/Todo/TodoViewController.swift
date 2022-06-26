//
//  TodoViewController.swift
//  MixApps
//
//  Created by Aliia Saidillaeva  on 25/6/22.
//

import UIKit

class TodoViewController: UIViewController {
    
    var defaults: TodoDefaults = .init()
    
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
        view.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        view.tintColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(edit), for: .touchUpInside)
        
        return view
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var filteredTodo: [Todo] = []
    
    private var tableData: [Todo]{
        isFiltering ? filteredTodo : defaults.data
    }
    
    private var isEmptySearchBar: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isEmptySearchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if tableData.count == 0 {
            animate()
        }
    }
    
    @objc
    func add(){
        let detailsViewController = DetailsViewController()
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    @objc
    func edit(){
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
    
    //    let width = view.frame.width
    //    addButton.transform = .init(translationX: -width , y: 0)
    //    addButton.alpha = 0
    //    UIView.animateKeyframes(withDuration: 1, delay: 0) {
    //        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2) {
    //            var transform = self.addButton.transform
    //            transform = transform.translatedBy(x: width/2, y: 0)
    //            self.addButton.transform = transform
    //            self.addButton.alpha = 1/2
    //        }
    //        UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
    //            var transform = self.addButton.transform
    //            transform = transform.translatedBy(x: width/2, y: 0)
    //            self.addButton.transform = transform
    //            self.addButton.alpha = 1
    //        }
    //    } completion: { _ in
    //        self.addButton.transform = .identity
    //        self.addButton.alpha = 1
    //    }
    //
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
        cell.setTodo(tableData[indexPath.row])
        cell.delegate = self
        cell.tappedIndex = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TodoCell{
            let item = tableData[indexPath.row]
            item.isDone.toggle()
            defaults.update(todo: item)
            cell.cellSelected(isSelected: item.isDone)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = defaults.remove(index: sourceIndexPath.row)
        defaults.insert(todo: item, index: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo: Todo = tableData[indexPath.row]
            defaults.remove(todo: todo)
            if let index = filteredTodo.firstIndex(of: todo) {
                filteredTodo.remove(at: index)
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        } else if editingStyle == .insert {
            let rowIndex = tableData.count - 1
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
        let item = tableData[indexPath.row]
        detailsViewController.itemToEdit = item
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
}

extension TodoViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        [addButton, editButton].forEach { button in
            button.isHidden = true
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        [addButton, editButton].forEach { button in
            button.isHidden = false
        }
    }
}

extension TodoViewController: DetailViewControllerDelegate {
    
    func detailViewController(_ controller: DetailsViewController, edited item: Todo) {
        if let index = tableData.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? TodoCell{
                cell.setTodo(item)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func detailViewController(_ controller: DetailsViewController, added item: Todo) {
        defaults.updateList()
        let rowIndex = tableData.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at:  [indexPath], with: .left)
        tableView.endUpdates()
    }
}

extension TodoViewController: TodoCellDelegate{
    func didTapCheckMark(index: Int) {
        if let cell: TodoCell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TodoCell{
            let item = tableData[index]
            item.isDone.toggle()
            defaults.update(todo: item)
            cell.cellSelected(isSelected: item.isDone)
        }
    }
}

extension TodoViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredTodo = defaults.data.filter({ (todo: Todo) -> Bool in
            return  todo.title.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "")})
        tableView.reloadData()
    }
}
