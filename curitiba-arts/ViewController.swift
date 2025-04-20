//
//  ViewController.swift
//  curitiba-arts
//
//  Created by Pedro Henrique Sudario da Silva on 20/04/25.
//

import UIKit

/// Exibe uma coleção de obras de arte com search/filter integrado
/// 
/// - UISearchBar no topo: posicionamento padrão em apps
/// - UICollectionViewFlowLayout responsivo: garante layout adaptativo em iPhones e iPads
/// - separation of concerns: DataSource e Delegate isolam lógica de apresentação

final class ViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let searchBar = UISearchBar()

    /// Full dataset, source of truth
    private let allItems: [ArtWorksCuritiba] = [
        ArtWorksCuritiba(
            title: "Instalação da Província do Paraná",
            artist: "Theodoro de Bona",
            year: 1853,
            style: "Painel",
            imageName: "provincia_de_curitiba",
            description: """
            Painel histórico instalado no Salão Nobre do Palácio Iguaçu, retratando a formação da Província do Paraná a partir de cenas representativas e elementos simbólicos.
            """
        ),
        ArtWorksCuritiba(
            title: "Fundação da Cidade de Curitiba",
            artist: "Theodoro de Bona",
            year: 1947,
            style: "Painel",
            imageName: "fundacao_de_curitiba",
            description: """
            Painel localizado na Pinacoteca do Colégio Estadual do Paraná, narrando episódios da fundação de Curitiba com traços figurativos e cores sóbrias.
            """
        ),
        ArtWorksCuritiba(
            title: "A Comunicação",
            artist: "Poty Lazzarotto",
            year: 0,
            style: "Madeira",
            imageName: "a_comunicacao_1",
            description: """
            Instalação em madeira montada no hall de entrada de um edifício público, composta por formas abstratas que evocam fios, ondas e sinais, simbolizando o fluxo de informações e a troca constante entre as pessoas.
            """
        ),
        ArtWorksCuritiba(
            title: "Desenvolvimento de Curitiba",
            artist: "Poty Lazzarotto",
            year: 1967,
            style: "Concreto",
            imageName: "desenvolvimento_de_curitiba_1",
            description: """
            Painel em concreto armado localizado em espaço urbano, que representa o crescimento econômico e social da cidade através de traços figurativos e geométricos. Detalhes de fábricas, trens e edificações refletem o processo de industrialização e modernização.
            """
        ),
        ArtWorksCuritiba(
            title: "História do Paraná",
            artist: "Poty Lazzarotto",
            year: 0,
            style: "Cerâmica",
            imageName: "historia_do_parana_badep",
            description: """
            Série de relevos cerâmicos distribuídos ao longo de um muro, narrando episódios da formação política e cultural do estado. Elementos indígenas, colonizadores e símbolos da agricultura aparecem em fragmentos sequenciais.
            """
        ),
        ArtWorksCuritiba(
            title: "O Bom Samaritano",
            artist: "Poty Lazzarotto",
            year: 1961,
            style: "Cerâmica",
            imageName: "o_bom_samaritano_2_0",
            description: """
            Mural em lajota cerâmica que ilustra a parábola bíblica do Bom Samaritano, enfatizando gestos de solidariedade e compaixão. As figuras estilizadas e o uso de contrastes de cor valorizam a ação humanitária.
            """
        ),
        ArtWorksCuritiba(
            title: "O Trabalho Humano e a Evolução Tecnológica",
            artist: "Poty Lazzarotto",
            year: 1965,
            style: "Cerâmica",
            imageName: "o_trabalho_humano_evolucao_tecnologica",
            description: """
            Painel cerâmico composto por módulos que exploram, de forma figurativa e abstrata, a relação entre o esforço humano e as máquinas. Engrenagens, ferramentas e trabalhadores são combinados para celebrar o progresso industrial.
            """
        ),
        ArtWorksCuritiba(
            title: "Painel na fachada do Teatro Guaíra",
            artist: "Poty Lazzarotto",
            year: 0,
            style: "Cerâmica",
            imageName: "painelguaira",
            description: """
            Painel cerâmico monumental que adorna a fachada do Teatro Guaíra, reunindo formas estilizadas de máscaras, instrumentos musicais e notas, em homenagem ao universo das artes cênicas e performáticas.
            """
        ),
        ArtWorksCuritiba(
            title: "Pinheiro, Café e Erva‑mate",
            artist: "Poty Lazzarotto",
            year: 0,
            style: "Madeira",
            imageName: "pinheiro_cafe_e_erva_mate",
            description: """
            Composição em madeira que celebra as principais riquezas naturais e econômicas do Paraná: o pinheiro-do-paraná, o cultivo de café e a produção de erva-mate. Cada elemento é gravado de forma estilizada e integrado em um único painel.
            """
        ),
        ArtWorksCuritiba(
            title: "Plenário da Assembleia Legislativa do Paraná",
            artist: "Poty Lazzarotto",
            year: 0,
            style: "Madeira",
            imageName: "plenario_assembleia_legislativa_parana_1",
            description: """
            Painel de madeira instalado no plenário da Assembleia Legislativa, formado por relevos abstratos que evocam símbolos de poder, justiça e representatividade. A obra reflete a importância do legislativo na história estadual.
            """
        )
    ]    private var filteredItems: [ArtWorksCuritiba] = []

    /// Computed property para definir filter state
    private var isFiltering: Bool {
        let text = searchBar.text ?? ""
        return !text.isEmpty
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Artes de Curitiba"
        view.backgroundColor = .systemBackground

        // Setup UISearchBar como header view
        configureSearchBar()

        // Setup UICollectionView responsivo
        setupCollectionView()

        // Activate layout constraints
        activateConstraints()
    }

    // MARK: - Setup UI Components

    private func configureSearchBar() {
        searchBar.placeholder = "Buscar título ou artista"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
    }

    private func setupCollectionView() {
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        flow.minimumInteritemSpacing = 12
        flow.minimumLineSpacing = 20

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)

        // MVC pattern: view delegates para ViewController
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            // SearchBar top anchor no safe area para evitar notch
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // CollectionView ocupa resto da tela
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Layout Updates

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Invalidate layout para adaptive resizing on rotations
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? filteredItems.count : allItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = isFiltering ? filteredItems[indexPath.item] : allItems[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        cell.configure(with: model)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 150, height: 200)
        }
        // Adaptive columns: 2 on compact width, 4 on regular width
        let columns: CGFloat = traitCollection.horizontalSizeClass == .regular ? 4 : 2
        let totalSpacing = flow.sectionInset.left + flow.sectionInset.right + (columns - 1) * flow.minimumInteritemSpacing
        let width = floor((collectionView.bounds.width - totalSpacing) / columns)
        return CGSize(width: width, height: width * 1.25)
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Deselection para feedback tátil
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = isFiltering ? filteredItems[indexPath.item] : allItems[indexPath.item]
        let detail = DetailViewController(item: model)
        detail.modalPresentationStyle = .overFullScreen
        detail.modalTransitionStyle = .crossDissolve
        present(detail, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        // Subtle highlight animation for touch feedback
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) { cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97) }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) { cell.transform = .identity }
        }
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Real-time filtering com case-insensitive search
        filteredItems = allItems.filter { item in
            item.title.lowercased().contains(searchText.lowercased()) ||
            item.artist.lowercased().contains(searchText.lowercased())
        }
        collectionView.reloadData()
    }
}
