//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/12/22.
//

import UIKit
import Combine

class PokemonDetailViewController: UIViewController {
    private var subscription: AnyCancellable?
    private let viewModel: PokemonDetailViewModel
    private var contentView: PokemonDetailView?

    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        self.contentView = PokemonDetailView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view = contentView
        viewModel.loadData()
        bindUI()
    }
    
    private func bindUI() {
        subscription = viewModel.pokemonDetailSubject.sink { [unowned self] completion in
            switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
            }
        } receiveValue: { [unowned self] pokemonDetail in
            contentView?.configure(detail: pokemonDetail)
        }
    }
}

