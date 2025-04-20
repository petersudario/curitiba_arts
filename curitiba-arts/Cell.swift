//
//  Cell.swift
//  curitiba-arts
//
//  Created by Pedro Henrique Sudario da Silva on 20/04/25.
//
import UIKit

/// Célula que exibe resumo de uma obra de arte com imagem e metadados

/// - aspectFill em imageView: garante cover effect sem distorcer a imagem
/// - cornerRadius e backgroundColor secundário: segue estilo de cards do sistema
/// - prepareForReuse: garante cell reuse sem dados residuais
/// - UILabels configuráveis: separation of concerns, cell apenas recebe model


final class Cell: UICollectionViewCell {
    // reuseIdentifier para otimizar dequeue e reutilização de cells
    static let reuseIdentifier = "Cell"

    // MARK: - UI Components

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.textColor = .label
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let artistLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let yearLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = .secondaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let styleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .italicSystemFont(ofSize: 12)
        lbl.textColor = .tertiaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    /// descriptionLabel com numberOfLines limitado e fonte menor para subtítulo
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 10)
        lbl.textColor = .tertiaryLabel
        lbl.numberOfLines = 3
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        [imageView, titleLabel, artistLabel,
         yearLabel, styleLabel, descriptionLabel].forEach {
            contentView.addSubview($0)
        }

        // MARK: - Layout Constraints
        
        // Posicionamento dos elementos do card, com base em constraints (regras)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),

            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            yearLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 2),
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            styleLabel.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor),
            styleLabel.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor, constant: 8),
            styleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) não implementado")
    }

    // MARK: - Reuse Handling

    override func prepareForReuse() {
        super.prepareForReuse()
        // limpa dados para evitar ghosting de conteúdo
        imageView.image = nil
        titleLabel.text = nil
        artistLabel.text = nil
        yearLabel.text = nil
        styleLabel.text = nil
        descriptionLabel.text = nil
    }

    // MARK: - Configuration
    
    //popular os dados do modelo
    func configure(with model: ArtWorksCuritiba) {
        imageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title
        artistLabel.text = model.artist
        yearLabel.text = model.year > 0 ? "\(model.year)" : "N/D"
        styleLabel.text = model.style
        descriptionLabel.text = model.description
    }
}
