//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/8/22.
//

import UIKit
import Combine

final class PokemonListViewController: UITableViewController {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Pokemon>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>
    
    private var subscription: AnyCancellable?
    private let viewModel: PokemonListViewModel
    private var searchController = UISearchController(searchResultsController: nil)
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
    
    // MARK: - Private methods
    
    private func setUI() {
        view.backgroundColor = .white
        title = "Pokemons"
        tableView.rowHeight = 40
        viewModel.loadData()
        tableView.prefetchDataSource = self
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
    
    // MARK: Diffable data source
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(tableView: tableView) { [unowned self] _, _, pokemon -> UITableViewCell in
            
            let cell = UITableViewCell()
            var configuration = cell.defaultContentConfiguration()
            
            configuration.text = pokemon.name.capitalized
            cell.contentConfiguration = configuration
            
            return cell
        }
        return dataSource
    }()
    
    private func applySnapshot(pokemons: [Pokemon]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(pokemons, toSection: $0) }
        dataSource.apply(snapshot)
    }
}

extension PokemonListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.prefetchData(for: indexPaths)
    }
}
