//
//  ViewController.swift
//  Table&Collection
//
//  Created by Vitaly Anpilov on 13.03.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(VerticalItemCell.self, forCellReuseIdentifier: "VerticalItemCell")
        tableView.rowHeight = Constants.Table.rowHeight
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        return tableView
    }()
    
    var viewModel: MainViewModelProtocol
    
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bind()
    }
    
    private func bind() {
        self.viewModel.updateTableView = { [weak self] in
            self?.tableView.reloadData()
        }
        self.viewModel.updateRandomCell = { [weak self] updateIndices in
            self?.updateRandomItemInEachCell(updateIndices: updateIndices)
        }
        viewModel.getData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Table.inset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Table.inset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Table.inset),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Table.inset)
        ])
    }
    
    func updateRandomItemInEachCell(updateIndices: [Int]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let visibleCells = self.tableView.visibleCells as? [VerticalItemCell] else { return }
            
            for cell in visibleCells {
                guard let indexPath = self.tableView.indexPath(for: cell) else { continue }
                let verticalItemIndex = indexPath.row
                
                guard verticalItemIndex < updateIndices.count else { continue }
                let updateIndex = updateIndices[verticalItemIndex]
                
                guard updateIndex >= 0, updateIndex < self.viewModel.verticalItems[verticalItemIndex].horizontalItems.count else {
                    continue
                }
                
                let updatedNumber = self.viewModel.verticalItems[verticalItemIndex].horizontalItems[updateIndex].number
                cell.updateItem(updatedIndex: updateIndex, updatedNumber: updatedNumber)
            }
        }
    }

    
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.verticalItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VerticalItemCell", for: indexPath) as! VerticalItemCell
        cell.setupCell(verticalItemModel: viewModel.verticalItems[indexPath.row])
        return cell
    }
}
