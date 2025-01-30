import UIKit

class MainVC: UIViewController {
    
    private var tableView =  UITableView()
    private var searchController = UISearchController(searchResultsController: nil)
    private var bottomView = UIView()
    private var tasksLbl = UILabel()
    private var createBtn = UIButton()
    var viewModel = MainViewModel()
    var tasks: [TaskItem] = []
    var filteredTasks: [TaskItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContstraints()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !(UserDefaults.standard.bool(forKey: "isFetch")) {
            UserDefaults.standard.set(true, forKey: "isFetch")
            viewModel.getTasks()
            tasks = viewModel.fetchTasks()
        } else {
            tasks = viewModel.fetchTasks()
        }
        
        self.tableView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск задач"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    func setUpContstraints() {
        view.backgroundColor = .systemBackground
        title = "Задачи"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "MainTVC", bundle: nil), forCellReuseIdentifier: "MainTVC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        bottomView.backgroundColor = #colorLiteral(red: 0.1529409289, green: 0.1529413164, blue: 0.1615334749, alpha: 1)
        
        tasksLbl.translatesAutoresizingMaskIntoConstraints = false
        tasksLbl.font = .systemFont(ofSize: 11)
        tasksLbl.text = "\(viewModel.fetchTasks().count) задач"
        bottomView.addSubview(tasksLbl)
        
        createBtn.translatesAutoresizingMaskIntoConstraints = false
        createBtn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        createBtn.tintColor = .yellow
        createBtn.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        bottomView.addSubview(createBtn)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.heightAnchor.constraint(equalToConstant: 70),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tasksLbl.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: -10),
            tasksLbl.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            
            createBtn.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: -10),
            createBtn.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -24),
            createBtn.heightAnchor.constraint(equalToConstant: 40),
            createBtn.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func addTask() {
        let vc = AdditionalVC()
        vc.isCreate = true
        self.navigationItem.backButtonTitle = "Назад"
        self.navigationItem.backBarButtonItem?.tintColor = .yellow
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AdditionalVC()
        vc.isCreate = false
        
        let task = isFiltering() ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        vc.titleLbl.text = task.title
        vc.dateLbl.text = Formatter.customDateFormatter(task.creationDate)
        vc.complated = task.completed
        vc.editTaskID = task.id
        vc.descriptionLbl.text = task.todo
        
        self.navigationItem.backButtonTitle = "Назад"
        self.navigationItem.backBarButtonItem?.tintColor = .yellow
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredTasks.count : tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTVC", for: indexPath) as? MainTVC else {
            return UITableViewCell()
        }
        
        let task = isFiltering() ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        cell.setUpCell(task)
        cell.onTickButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.tasks = self.viewModel.uncheckTasks(indexPath)
            tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { _ in
            self.setUpContextMenu(indexPath)
        })
    }
    
    func setUpContextMenu(_ indexPath: IndexPath) -> UIMenu {
        let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { [self] _ in
            let vc = AdditionalVC()
            vc.isCreate = false
            
            let task = isFiltering() ? filteredTasks[indexPath.row] : tasks[indexPath.row]
            vc.titleLbl.text = task.title
            vc.dateLbl.text = Formatter.customDateFormatter(task.creationDate)
            vc.descriptionLbl.text = task.todo
            
            self.navigationItem.backButtonTitle = "Назад"
            self.navigationItem.backBarButtonItem?.tintColor = .yellow
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            print("Share tapped for \(indexPath.row)")
        }
        let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [self] _ in
            CoreDataManager.shared.deleteTask(item: tasks[indexPath.row])
            tasks = viewModel.fetchTasks()
            tableView.reloadData()
        }
        
        return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
    }
}

// MARK: - UISearchResultsUpdating
extension MainVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredTasks = tasks.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}
