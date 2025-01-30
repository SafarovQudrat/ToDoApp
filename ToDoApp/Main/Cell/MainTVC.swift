import UIKit

class MainTVC: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var tickButton: UIButton!
    
     var onTickButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tickButton.addTarget(self, action: #selector(handleTickButtonTapped), for: .touchUpInside)
    }
    
    @objc func handleTickButtonTapped() {
        onTickButtonTapped?()
    }
    
    

    func setUpCell(_ item: TaskItem) {
        if item.title == "" {
            titleLbl.text = "To-Do"
        }
        titleLbl.attributedText = item.completed ? getStrikethroughText(item.title) : NSAttributedString(string: item.title)
        descLbl.text = item.todo
        dateLbl.text = Formatter.customDateFormatter(date: item.creationDate)
        if item.completed {
            tickButton.layer.borderColor = UIColor.yellow.cgColor
            tickButton.setImage(UIImage(named: "tick"), for: .normal)
            tickButton.tintColor = .yellow
            descLbl.textColor = .gray
        }else {
            tickButton.setImage(UIImage(systemName: " "), for: .normal)
            tickButton.layer.borderColor = UIColor.gray.cgColor
            descLbl.textColor = .label
        }
        tickButton.layer.borderWidth = 1
        tickButton.layer.cornerRadius = 12
    }
    
    
    
    private func getStrikethroughText(_ text: String) -> NSAttributedString {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.gray
            ]
            return NSAttributedString(string: text, attributes: attributes)
        }
    
    
   
}
