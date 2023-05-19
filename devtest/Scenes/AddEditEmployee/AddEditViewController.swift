//
//  AddEditViewController.swift
//  devtest
//
//  Created by darindra.khadifa on 18/05/23.
//

import UIKit

class AddEditViewController: UIViewController {
    // - MARK: View Model

    let viewModel: AddEditViewModel

    // - MARK: UI View

    @UseAutoLayout
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.borderStyle = .line
        textField.backgroundColor = .white
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.placeholder = "Name"
        return textField
    }()

    @UseAutoLayout
    private var salaryTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.borderStyle = .line
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        textField.placeholder = "Salary"
        return textField
    }()

    @UseAutoLayout
    private var ageTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.borderStyle = .line
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        textField.placeholder = "Age"
        return textField
    }()

    @UseAutoLayout
    private var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.cornerRadius = 6
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    @UseAutoLayout
    private var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .baseBlue
        button.layer.borderWidth = 1
        button.setTitle("Show All Employees", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    @UseAutoLayout
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()

    internal init(viewModel: AddEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTapGesture()
        setupButtonAction()

        bind()
    }

    private func bind() {
        viewModel.output.state.bind { [unowned self] state in
            DispatchQueue.main.async {
                switch state {
                case .successSubmit:
                    self.nameTextField.text = nil
                    self.salaryTextField.text = nil
                    self.ageTextField.text = nil

                    self.showAlert(
                        title: "Success",
                        message: "Data submitted successfully."
                    )

                case let .needInput(type):
                    self.showAlert(
                        title: "Missing \(type.rawValue.capitalized)",
                        message: "Please input employee \(type.rawValue) in the field provided."
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
        view.backgroundColor = .mainColor
        navigationItem.largeTitleDisplayMode = .never
        seeAllButton.contentEdgeInsets = UIEdgeInsets(
            top: 16,
            left: 0,
            bottom: view.safeAreaInsets.bottom + 24,
            right: 0
        )

        view.addSubview(stackView)
        view.addSubview(submitButton)
        view.addSubview(seeAllButton)

        nameTextField.text = viewModel.requestBody?.name
        salaryTextField.text = viewModel.requestBody?.salary
        ageTextField.text = viewModel.requestBody?.age

        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(salaryTextField)
        stackView.addArrangedSubview(ageTextField)

        let constraints = [
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            salaryTextField.heightAnchor.constraint(equalToConstant: 40),
            ageTextField.heightAnchor.constraint(equalToConstant: 40),
            submitButton.heightAnchor.constraint(equalToConstant: 40),

            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -72),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),

            submitButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            submitButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            submitButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 24),
            submitButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -24),

            seeAllButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            seeAllButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupButtonAction() {
        submitButton.addTarget(self, action: #selector(onTapSubmitButton), for: .touchUpInside)
        seeAllButton.addTarget(self, action: #selector(OnTapSeeAllButton), for: .touchUpInside)
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

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapOutside))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func onTapOutside() {
        view.endEditing(true)
    }

    @objc private func onTapSubmitButton() {
        let data = EmployeeRequest(
            name: nameTextField.text ?? "",
            salary: salaryTextField.text ?? "",
            age: ageTextField.text ?? ""
        )

        viewModel.input.send(.didTapSubmitButton(data: data))
    }

    @objc private func OnTapSeeAllButton() {
        viewModel.input.send(.didTapSeeAllButton)
    }
}
