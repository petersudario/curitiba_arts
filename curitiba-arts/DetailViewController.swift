//
//  DetailViewController.swift
//  curitiba-arts
//
//  Created by Pedro Henrique Sudario da Silva on 20/04/25.
//

import UIKit

final class DetailViewController: UIViewController {
    private let item: ArtWorksCuritiba

    private let backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textColor = .label
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let artistLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .secondaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let yearLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .tertiaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let styleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .italicSystemFont(ofSize: 14)
        lbl.textColor = .tertiaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let descriptionScroll: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .label
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let closeButton: UIButton = {
        let btn = UIButton(type: .close)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let shareButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Compartilhar", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    init(item: ArtWorksCuritiba) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) não implementado")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundView)
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
        ])

        backgroundView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        )

        setupContent()
        configureContent()
    }

    private func setupContent() {
        [closeButton, imageView, titleLabel, artistLabel, yearLabel,
         styleLabel, descriptionScroll, shareButton]
            .forEach { containerView.addSubview($0) }
        descriptionScroll.addSubview(descriptionLabel)

        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            imageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.35),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            yearLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 4),
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            styleLabel.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor),
            styleLabel.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor, constant: 8),
            styleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            descriptionScroll.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 8),
            descriptionScroll.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionScroll.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            descriptionScroll.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.2),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionScroll.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionScroll.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionScroll.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionScroll.bottomAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: descriptionScroll.widthAnchor),

            shareButton.topAnchor.constraint(equalTo: descriptionScroll.bottomAnchor, constant: 12),
            shareButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }

    private func configureContent() {
        imageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        artistLabel.text = item.artist
        yearLabel.text = item.year > 0 ? "\(item.year)" : "N/D"
        styleLabel.text = item.style
        descriptionLabel.text = item.description
    }

    @objc private func shareTapped() {
        let text = "Descubra a obra de arte “\(item.title)” de \(item.artist)!\n\n" +
                   "Venha conhecer mais artistas incríveis de Curitiba e enriquecer seu olhar sobre a arte local."
        let ac = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(ac, animated: true)
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}
