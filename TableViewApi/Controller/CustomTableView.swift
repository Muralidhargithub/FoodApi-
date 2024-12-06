import UIKit

class CustomTableView: UIView {
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        fetchData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(progressBar)
        addSubview(tableView)
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
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

    private func fetchData() {
        let url = ServerConstants.serverURL
            progressBar.isHidden = false
            progressBar.setProgress(0.3, animated: true)
            
            gitData.getdata(url: url) { [weak self] (foodData: FoodData) in
                DispatchQueue.main.async {
                    self?.progressBar.setProgress(0.7, animated: true)
                }
                self?.data = foodData.food_groups
                DispatchQueue.main.async {
                    self?.progressBar.setProgress(1.0, animated: true)
                    self?.progressBar.isHidden = false
                    self?.tableView.reloadData()
                }
            }
    }
}

extension CustomTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: data[indexPath.row])
        return cell
    }
}

