//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/8/22.
//

import UIKit
import Combine

final class PokemonListViewController: UICollectionViewController {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Pokemon>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>
    
    private var subscription: AnyCancellable?
    private let viewModel: PokemonListViewModelRepresentable
    private var searchController = UISearchController(searchResultsController: nil)
    
    init(viewModel: PokemonListViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: PokemonListViewController.generateLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindUI()
    }
    
    static private func generateLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }
    
    // MARK: - Private methods
    
    private func setUI() {
        view.backgroundColor = .white
        title = "Pokemons"
        viewModel.loadData(0)
        configureSearchController()
        collectionView.prefetchDataSource = self
    }
    
    private func bindUI() {
        subscription = viewModel.pokemonListSubject.sink { [unowned self] completion in
            switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
            }
        } receiveValue: { [unowned self] pokemons in
            applySnapshot(pokemons: pokemons)
        }
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = localizedString(.searchField)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: Diffable data source
    
    private let registerPokemonCell = UICollectionView.CellRegistration<UICollectionViewListCell, Pokemon> { cell, indexPath, pokemon in
        var configuration = cell.defaultContentConfiguration()
        configuration.text = pokemon.name.capitalized
        
        cell.contentConfiguration = configuration
    }
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            let configType = self.registerPokemonCell
            return collectionView.dequeueConfiguredReusableCell(using: configType, for: indexPath, item: item)
        }
        return dataSource
    }()
    
    private func applySnapshot(pokemons: [Pokemon]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(pokemons, toSection: $0) }
        dataSource.apply(snapshot)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokemon = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didTapItem(model: pokemon)
    }
}

extension PokemonListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.prefetchData(for: indexPaths)
    }
}

extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchPokemon(with: searchController.searchBar.text)
    }
}

extension PokemonListViewController: Localization {
    
    func localizedString(_ key: LocalizationPropertiesKey) -> String {
        return key.localizedString
    }
    
    enum LocalizationPropertiesKey {
        case searchField
        
        var localizedString: String {
            switch self {
            case .searchField: return NSLocalizedString("Search Pokemon", comment: "Placeholder text in searchbar homescreen")
            }
        }
    }
}
