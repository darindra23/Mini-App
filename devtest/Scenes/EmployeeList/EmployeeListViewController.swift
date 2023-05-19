//
//  EmployeeListViewController.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import UIKit

class EmployeeListViewController: UIViewController {
    // - MARK: View Model

    let viewModel = EmployeeListViewModel()

    // - MARK: UI View

    @UseAutoLayout
    private var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.allowsSelection = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        viewModel.input.send(.didLoad)
        bind()
    }

    private func bind() {
        viewModel.output.state.bind { [unowned self] state in
            DispatchQueue.main.async {
                switch state {
                case .reloadTable:
                    self.reloadTable()

                case .successRemove:
                    self.reloadTable()
                    self.showAlert(
                        title: "Success",
                        message: "Data removed successfully."
                    )

                case let .error(error):
                    self.showAlert(
                        title: error.title,
                        message: error.message
                    )

                default:
                    break
                }
            }
        }
    }

    private func setupView() {
        title = "Employee List"
        navigationItem.largeTitleDisplayMode = .always

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeeViewCell.self, forCellReuseIdentifier: EmployeeViewCell.identifier)

        view.addSubview(tableView)

        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    private func reloadTable() {
        let isDataEven = (viewModel.employees.count - 1) % 2 == 0

        tableView.backgroundColor = isDataEven ? .evenBackgroundColor : .oddBackgroundColor
        tableView.reloadData()
    }
}

extension EmployeeListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.employees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeViewCell.identifier, for: indexPath) as? EmployeeViewCell else {
            fatalError("GitHubRepoCell dose not exist.")
        }

        let index = indexPath.row
        let employee = viewModel.employees[index]

        cell.setup(with: employee, for: index)
        cell.didSendAction = { [viewModel] action in
            viewModel.input.send(.cellAction(at: indexPath, action: action))
        }

        return cell
    }
}
