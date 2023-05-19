//
//  EmployeeCell.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import UIKit

enum CellAction {
    case didTapEdit
    case didTapDelete
}

class EmployeeViewCell: UITableViewCell {
    // - MARK: Constant

    internal static let identifier = "EmployeeViewCell"

    // - MARK: Callback

    internal var didSendAction: (CellAction) -> Void = { _ in }

    // - MARK: UI View

    @UseAutoLayout
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    @UseAutoLayout
    private var idLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    @UseAutoLayout
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    @UseAutoLayout
    private var salaryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    @UseAutoLayout
    private var ageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    @UseAutoLayout
    private var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    @UseAutoLayout
    private var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.cornerRadius = 6
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    @UseAutoLayout
    private var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.cornerRadius = 6
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupButtonAction()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(stackView)
        contentView.addSubview(buttonStack)

        stackView.addArrangedSubview(idLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(salaryLabel)
        stackView.addArrangedSubview(ageLabel)

        buttonStack.addArrangedSubview(editButton)
        buttonStack.addArrangedSubview(deleteButton)

        let constraints = [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            buttonStack.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            buttonStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            buttonStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            editButton.widthAnchor.constraint(equalToConstant: 100),
            deleteButton.widthAnchor.constraint(equalToConstant: 100)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupButtonAction() {
        editButton.addTarget(self, action: #selector(onTapEditButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(onTapDeleteButton), for: .touchUpInside)
    }

    func setup(with model: Employee, for index: Int) {
        backgroundColor = index % 2 == 0 ? .evenBackgroundColor : .oddBackgroundColor

        idLabel.text = "ID : \(model.id)"
        nameLabel.text = "Name : \(model.name)"
        salaryLabel.text = "Salary : \(model.salary)"
        ageLabel.text = "Age : \(model.age)"
    }

    @objc private func onTapEditButton() {
        didSendAction(.didTapEdit)
    }

    @objc private func onTapDeleteButton() {
        let alertController = UIAlertController(
            title: "Delete Employee",
            message: "Are you sure you want to delete this employee? This action cannot be undone.",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [didSendAction] _ in
            didSendAction(.didTapDelete)
        }

        alertController.addAction(deleteAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.topViewController()?.present(alertController, animated: true)
    }
}
