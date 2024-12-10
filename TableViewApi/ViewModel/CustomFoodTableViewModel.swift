import Foundation
import UIKit

class CustomFoodTableViewModel {
    // MARK: - Properties
    private var data: [FoodGroup] = []
    var updateView: (() -> Void)? // Closure for notifying the view
    var updateProgressBar: ((Float, Bool) -> Void)? // Closure for progress bar updates

    // Data Count for Table View
    func numberOfRows() -> Int {
        return data.count
    }

    // Get FoodGroup at Specific Index
    func foodGroup(at index: Int) -> FoodGroup {
        return data[index]
    }

    // MARK: - Networking
    func fetchData(with gitData: GitData?) {
        guard let gitData = gitData else {
            print("gitData is not set")
            return
        }

        let url = ServerConstants.serverURL
        updateProgressBar?(0.3, false)
        gitData.getdata(url: url) { [weak self] (foodData: FoodData) in
            guard let self = self else { return }
            self.data = foodData.food_groups
            DispatchQueue.main.async {
                self.updateProgressBar?(1.0, false)
                self.updateView?()
            }
        }
    }
}
