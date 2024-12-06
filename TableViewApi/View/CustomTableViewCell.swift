import UIKit

class CustomTableViewCell: UITableViewCell {
    let label: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        contentView.addSubview(articleImageView)
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            articleImageView.widthAnchor.constraint(equalToConstant: 100),
            articleImageView.heightAnchor.constraint(equalToConstant: 100),

            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with foodGroup: FoodGroup) {
        var formattedText = """
        Name: \(foodGroup.name ?? "Unknown")
        Description: \(foodGroup.description ?? "No description available")
        \n
        """

        for (index, item) in foodGroup.food_items.enumerated() {
            formattedText += """

            Item \(index + 1):
            Name: \(item.name ?? "Unknown")
            Weight: \(item.weight ?? 0) grams
            Price: $\(item.price ?? 0)
            Description: \(item.description ?? "No description available")

            \n
            """
        }

        label.text = formattedText
        if let imageUrl = foodGroup.image_url {
            DataGit.shared.getImage(url: imageUrl) { [weak self] image in
                self?.articleImageView.image = image ?? UIImage(named: "placeholder")
            }
        } else {
            articleImageView.image = UIImage(named: "placeholder")
        }
    }
}
