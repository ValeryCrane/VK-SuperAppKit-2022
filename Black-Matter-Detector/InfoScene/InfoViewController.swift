//
//  InfoViewController.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import UIKit

protocol InfoDisplayLogic: AnyObject {
    // Displays new information at front.
    func displayFrontInfo(_ info: [PresentedInfoModel], topCellRow: Int)
    // Displays new information at back.
    func displayBackInfo(_ info: [PresentedInfoModel], bottomCellRow: Int)
    // func displaySearchedInfo(_ info:  [PresentedInfoModel], topCellRow: Int)
}

class InfoViewController: UIViewController {
    public var interactor: InfoBusinessLogic!
    private let tableView = UITableView()
    private let searchField = UITextField()
    private var page: [PresentedInfoModel] = []

    // MARK: - ViewController's life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let searchFieldView = configureSearchField()
        configureTableView(searchFieldView: searchFieldView)
        interactor.fetchInfo(startIndex: 0)
    }
    
    // MARK: - config functions.
    private func configureTableView(searchFieldView: UIView) {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchFieldView.bottomAnchor),
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
            indicator.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        indicator.startAnimating()
        return cell
    }
    
    private func configureSearchField() -> UIView {
        let wrapper = UIView()
        wrapper.backgroundColor = .white
        view.addSubview(wrapper)
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        
        let searchTitle = UILabel()
        searchTitle.text = "Go to:"
        wrapper.addSubview(searchTitle)
        searchTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let goButton = UIButton()
        goButton.backgroundColor = .systemBlue
        goButton.setTitle("Go", for: .normal)
        goButton.setTitleColor(.white, for: .normal)
        wrapper.addSubview(goButton)
        goButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchField.placeholder = "index..."
        searchField.delegate = self
        wrapper.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wrapper.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            wrapper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            wrapper.heightAnchor.constraint(equalToConstant: 64),
            
            searchTitle.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor),
            searchTitle.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 8),
            searchTitle.widthAnchor.constraint(equalToConstant: 64),
            
            searchField.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor),
            searchField.leadingAnchor.constraint(equalTo: searchTitle.trailingAnchor, constant: 8),
            
            goButton.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor),
            goButton.leadingAnchor.constraint(equalTo: searchField.trailingAnchor, constant: 8),
            goButton.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -8),
            goButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        goButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        return wrapper
    }
    
    
    // MARK: - actions.
    @objc private func search() {
        guard let index = searchField.text else { return }
        searchField.text = ""
        page = []
        tableView.tableHeaderView = UIView()
        tableView.reloadData()
        interactor.fetchSearchedInfo(startIndex: index)
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
    func displayFrontInfo(_ info: [PresentedInfoModel], topCellRow: Int) {
        // Updating data.
        page = info
        tableView.reloadData()
        
        // Adjusting scroll.
        if topCellRow >= 0, topCellRow < page.count {
            tableView.scrollToRow(at: IndexPath(row: topCellRow, section: 0),
                                  at: .top, animated: false)
        }
        
        // Adjusting loading animation.
        if !page.isEmpty && page[0].id != 0 {
            tableView.tableHeaderView = configureLoadingCell()
        } else {
            tableView.tableHeaderView = UIView()
        }
    }
    func displayBackInfo(_ info: [PresentedInfoModel], bottomCellRow: Int) {
        // Updating data.
        page = info
        tableView.reloadData()
        
        // Adjusting scroll.
        if bottomCellRow >= 0, bottomCellRow < page.count {
            tableView.scrollToRow(at: IndexPath(row: bottomCellRow, section: 0),
                                  at: .bottom, animated: false)
        }
        
        // Adjusting loading animation.
        if !page.isEmpty && page[0].id != 0 {
            tableView.tableHeaderView = configureLoadingCell()
        } else {
            tableView.tableHeaderView = UIView()
        }
    }
}

// MARK: - UITextViewDelegate implementation.
extension InfoViewController: UITextFieldDelegate {
    
    // So to make only digits in searchField.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let digits = CharacterSet.decimalDigits
        let textCharacters = CharacterSet(charactersIn: string)
        return digits.isSuperset(of: textCharacters)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}
