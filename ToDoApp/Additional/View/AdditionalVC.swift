
import UIKit

class AdditionalVC: UIViewController {
    
     var titleLbl = UITextField()
     var dateLbl = UILabel()
     var descriptionLbl = UITextView()
     var tapGesture = UITapGestureRecognizer()
     var isCreate: Bool = false
    var editTaskID = Int()
    var complated: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        if isCreate{
            dateLbl.text = Formatter.customDateFormatter(Date())
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backTapped))
        backButton.tintColor = .yellow
        navigationItem.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .yellow
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func setUpUI(){
        
        view.backgroundColor = .systemBackground
        
        titleLbl.font = .boldSystemFont(ofSize: 20)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        dateLbl.font = .systemFont(ofSize: 12)
        dateLbl.textColor = .gray
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLbl.font = .systemFont(ofSize: 14)
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        
        tapGesture.addTarget(self, action: #selector(endEditing))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(titleLbl)
        view.addSubview(dateLbl)
        view.addSubview(descriptionLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            titleLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            titleLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            titleLbl.heightAnchor.constraint(equalToConstant: 40),
            
            dateLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 8),
            dateLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            
            descriptionLbl.topAnchor.constraint(equalTo: dateLbl.bottomAnchor, constant: 8),
            descriptionLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            descriptionLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            descriptionLbl.heightAnchor.constraint(equalToConstant: 150)
            
        ])
    }
    
    
    @objc func backTapped() {
        if isCreate {
            CoreDataManager.shared.createTask(TaskItem(id: UserDefaults.standard.integer(forKey: "lastID"), title: titleLbl.text!, todo: descriptionLbl.text!, creationDate: Formatter.stringToDate(dateLbl.text!)!, completed: false))
        }else {
            CoreDataManager.shared.updateTask(editTaskID, complated, Formatter.stringToDate(dateLbl.text!)!, titleLbl.text!, descriptionLbl.text!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    
    
}
