//
//  InfoViewController.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import UIKit

protocol InfoDisplayLogic: AnyObject {
    func displayInfo(_ info: [PresentedInfoModel])
}

class InfoViewController: UIViewController {
    public var interactor: InfoBusinessLogic!
    private let tableView = UITableView()
    private var page: [PresentedInfoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        interactor.fetchInfo(startIndex: 0)
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
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = configureLoadingCell()
        tableView.register(InfoTableViewCell.self,
                           forCellReuseIdentifier: InfoTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
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
        var firstCell: Int? = nil
        if tableView.indexPathsForVisibleRows?.count != 0 {
            firstCell = tableView.indexPathsForVisibleRows?.sorted(by: { $0.row < $1.row })[0].row
        }
        var firstCellId: Int? = nil
        if let firstCell = firstCell {
            firstCellId = page[firstCell].id
        }
        page = info
        tableView.reloadData()
        if let firstCellId = firstCellId {
            for i in 0..<page.count {
                if page[i].id == firstCellId {
                    tableView.scrollToRow(
                        at: IndexPath(row: i, section: 0),
                        at: .top,
                        animated: false
                    )
                }
            }
        }
        if !page.isEmpty && page[0].id != 0 {
            tableView.tableHeaderView = configureLoadingCell()
        } else {
            tableView.tableHeaderView = UIView()
        }
    }
}
