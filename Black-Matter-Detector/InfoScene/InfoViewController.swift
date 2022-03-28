//
//  InfoViewController.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import UIKit

protocol InfoDisplayLogic {
    func displayInfo(_ info: [PresentedInfoModel])
}

class InfoViewController: UIViewController {
    private let tableView = UITableView()
    private var page: [PresentedInfoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
    }

}

// MARK: - UITableViewDelegate & DataSource implementation.
extension InfoViewController: UITableViewDelegate { }

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

// MARK: - InfoDisplayLogic implementation.
extension InfoViewController: InfoDisplayLogic {
    func displayInfo(_ info: [PresentedInfoModel]) {
        page = info
        tableView.reloadData()
    }
}
