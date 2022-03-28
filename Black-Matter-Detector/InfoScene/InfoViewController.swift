//
//  InfoViewController.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import UIKit

protocol InfoDisplayLogic: AnyObject {
    func displayInfo(_ info: [PresentedInfoModel])  // Displays new information.
}

class InfoViewController: UIViewController {
    public var interactor: InfoBusinessLogic!
    private let tableView = UITableView()
    private var page: [PresentedInfoModel] = []

    // MARK: - ViewController's life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        interactor.fetchInfo(startIndex: 0)
    }
    
    // MARK: - config functions.
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = configureLoadingCell()
        tableView.register(InfoTableViewCell.self,
                           forCellReuseIdentifier: InfoTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Creates UIView with UIActivityIndicatorView.
    private func configureLoadingCell() -> UIView {
        let cell = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let indicator = UIActivityIndicatorView()
        cell.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])
        indicator.startAnimating()
        return cell
    }

}

// MARK: - UITableViewDelegate & DataSource implementation.
extension InfoViewController: UITableViewDelegate { }

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        page.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetching info if necessary.
        if indexPath.row == page.count - 1 {
            interactor.fetchInfo(startIndex: page[indexPath.row].id + 1)
        }
        if indexPath.row == 0 {
            interactor.fetchInfo(endIndex: page[0].id)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? InfoTableViewCell
        cell?.setup(info: page[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

// MARK: - InfoDisplayLogic implementation.
extension InfoViewController: InfoDisplayLogic {
    func displayInfo(_ info: [PresentedInfoModel]) {
        // Getting top cell's id.
        var topCellId: Int? = nil
        let topCellrow = tableView.indexPathsForVisibleRows?.sorted(by: { $0.row < $1.row }).first?.row
        if let topCellrow = topCellrow {
            topCellId = page[topCellrow].id
        }

        // Updating data
        page = info
        tableView.reloadData()
        
        // Adjusting scroll
        if let topCellId = topCellId {
            for i in 0..<page.count {
                if page[i].id == topCellId {
                    tableView.scrollToRow(
                        at: IndexPath(row: i, section: 0),
                        at: .top,
                        animated: false
                    )
                }
            }
        }
        
        // Adjusting loading animation.
        if !page.isEmpty && page[0].id != 0 {
            tableView.tableHeaderView = configureLoadingCell()
        } else {
            tableView.tableHeaderView = UIView()
        }
    }
}
