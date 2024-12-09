import UIKit

class CustomTableView: UIView {
    // MARK: - Properties
    private var data: [FoodGroup] = []
    private let gitData: GitData = DataGit.shared
    
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
        fetchData()
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

    // MARK: - Networking
    private func fetchData() {
        let url = ServerConstants.serverURL
        updateProgressBar(progress: 0.3, isHidden: false)
        gitData.getdata(url: url) { [weak self] (foodData: FoodData) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.data = foodData.food_groups
                self.updateProgressBar(progress: 1.0, isHidden: false)
                self.reloadTableView()
            }
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

// MARK: - UITableViewDataSource
extension CustomTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomFoodTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: data[indexPath.row])
        return cell
    }
}
