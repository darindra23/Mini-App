//
//  ToasterView.swift
//  devtest
//
//  Created by darindra.khadifa on 18/05/23.
//

import UIKit

class ToastView: UIView {
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()

    private let backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.backgroundColor = .red
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        return view
    }()

    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        setupSubviews()
        setText(text)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    private func setupSubviews() {
        addSubview(backgroundView)
        backgroundView.contentView.addSubview(textLabel)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0),

            textLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10.0),
            textLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10.0),
            textLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10.0),
            textLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10.0)
        ])
    }

    func setText(_ text: String) {
        textLabel.text = text
    }
}
