//
//  FilterResultsViewController.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 05.10.2022.
//

import UIKit

class FilterResultsViewController: UIViewController {
    // MARK: - Private properties
    @IBOutlet private weak var tableView: UITableView!
    private var keywords: [Keyword]?
    
    //MARK: - Public properties
    var delegate: FilterResultsDelegate?
    
    // MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(type: FilterResultsTableViewCell.self)
    }
    
    func update(withKeywords keywords: [Keyword]?) {
        self.keywords = keywords
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate methods
extension FilterResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(keyword: keywords?[indexPath.row].name ?? "")
    }
}

// MARK: - UITableViewDataSource methods
extension FilterResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: FilterResultsTableViewCell.self) as? FilterResultsTableViewCell else { return UITableViewCell() }
        let keyword = keywords?[indexPath.row].name ?? ""
        cell.update(withKeyword: keyword)
        
        return cell
    }
}
