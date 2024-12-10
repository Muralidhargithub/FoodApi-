import UIKit

class CustomFoodTableViewCell: UITableViewCell {
    // MARK: - UI Components
    private let label: UILabel = {
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
    
    private let foodItemStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var viewModel: CustomFoodTableViewModel?

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setUp() {
        contentView.addSubview(articleImageView)
        contentView.addSubview(label)
        contentView.addSubview(foodItemStack)

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            articleImageView.widthAnchor.constraint(equalToConstant: 100),
            articleImageView.heightAnchor.constraint(equalToConstant: 100),

            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            foodItemStack.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            foodItemStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            foodItemStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            foodItemStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configuration
    func configure(with foodGroup: FoodGroup, viewModel: CustomFoodTableViewModel) {
        self.viewModel = viewModel
        
        // Configure main group details
        label.text = """
        Name: \(foodGroup.name ?? "Unknown")
        Description: \(foodGroup.description ?? "No description available")
        \n
        """

        // Fetch and set group image
        viewModel.fetchImage(for: foodGroup.image_url) { [weak self] image in
            self?.articleImageView.image = image
        }

        // Configure food items
        foodItemStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for item in foodGroup.food_items {
            let itemView = createFoodItemView(item: item)
            foodItemStack.addArrangedSubview(itemView)
        }
    }

    private func createFoodItemView(item: FoodItem) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center

        let itemImageView = UIImageView()
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 8
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        viewModel?.fetchImage(for: item.image_url) { image in
            itemImageView.image = image
        }

        let itemLabel = UILabel()
        itemLabel.numberOfLines = 0
        itemLabel.font = .systemFont(ofSize: 16)
        itemLabel.textColor = .darkGray
        itemLabel.text = """
        Name: \(item.name ?? "Unknown")
        Weight: \(item.weight ?? 0)g
        Price: $\(item.price ?? 0)
        """

        stack.addArrangedSubview(itemImageView)
        stack.addArrangedSubview(itemLabel)
        return stack
    }

    // MARK: - Prepare for Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        articleImageView.image = UIImage(named: "placeholder")
        foodItemStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
