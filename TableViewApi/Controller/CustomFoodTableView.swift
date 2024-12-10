import UIKit

class CustomFoodTableView: UIView {
    
    // MARK: - Properties
    private let viewModel = CustomFoodTableViewModel()
    var gitData: GitData? {
        didSet {
            viewModel.fetchData(with: gitData)
        }
    }
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.0
        progressView.tintColor = .systemBlue
        return progressView
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setup() {
        addSubview(progressBar)
        addSubview(tableView)
        tableView.dataSource = self
        tableView.register(CustomFoodTableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            tableView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.updateView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        // MARK: - Helper Functions
        func updateProgressBar(progress: Float, isHidden: Bool) {
            progressBar.setProgress(progress, animated: true)
            progressBar.isHidden = isHidden
        }
        
        func reloadTableView() {
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension CustomFoodTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomFoodTableViewCell else {
            return UITableViewCell()
        }
        
        // Get the food group for the current index
        let foodGroup = viewModel.foodGroup(at: indexPath.row)
        
        // Configure the cell with the food group
        // Pass ViewModel if needed for fetching
        cell.configure(with: foodGroup, viewModel: viewModel)
        
        return cell
    }
}
