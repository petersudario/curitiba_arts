//
//  DetailViewController.swift
//  curitiba-arts
//
//  Created by Pedro Henrique Sudario da Silva on 20/04/25.
//

import UIKit

/// Por que este design?
/// - **Modal OverFullScreen**: cria foco total na obra, alinhado ao padrão de modais de detalhe no iOS, sem distrações do fundo.
/// - **Fundo semitransparente**: mantém o contexto visual do app visível, reforçando que é uma sobreposição temporária.
/// - **Container arredondado**: segue o estilo de cards do sistema, transmitindo familiaridade e leveza.
/// - **Descrição rolável com altura fixa**: garante consistência visual e evita truncar textos longos, mantendo layout previsível.

final class DetailViewController: UIViewController {
    private let item: ArtWorksCuritiba

    /// Overlay para modal e para permitir close ao tocar fora da região
    private let backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    /// Card central para reforçar a hierarquia e acessibilidade
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    /// Botão de fechar nativo (.close). Mantém consistência com o HIG da Apple
    private let closeButton: UIButton = {
        let btn = UIButton(type: .close)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    /// Imagem da obra, aspectFit oferece equilíbrio entre detalhe e espaço
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    /// Título em fonte bold para destacá‑lo como elemento principal
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textColor = .label
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    /// Artista em estilo secundário para hierarquia tipográfica
    private let artistLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .secondaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    /// Metadata em texto terciário para não competir com o conteúdo principal
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

    /// ScrollView para descrição: altura fixa dá previsibilidade, scrollable evita truncate
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

    private let shareButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Compartilhar", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Inicialização

    init(item: ArtWorksCuritiba) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) não implementado")
    }

    // MARK: - Ciclo de Vida

    override func viewDidLoad() {
        super.viewDidLoad()

        // Adiciona overlay da visualização do card
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

        // Fechar qualquer card se clicar fora dele
        backgroundView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        )

        setupContent()    // Monta hierarquia de UI e constraints
        configureContent()// Preenche com dados da obra
    }

    // MARK: - Configuração de UI

    private func setupContent() {
        [closeButton, imageView, titleLabel, artistLabel,
         yearLabel, styleLabel, descriptionScroll, shareButton]
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

    /// Abre a activity de compartilhamento da obra de arte
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
