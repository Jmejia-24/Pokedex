//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/12/22.
//

import UIKit

final class PokemonDetailView: UIView {
    
    init() {
        super.init(frame: .zero)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "PlaceHolderImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var heightDescription: PokemonDetailDescriptionView = {
        return PokemonDetailDescriptionView(title: "Height")
    }()
    
    private lazy var weightDescription: PokemonDetailDescriptionView = {
        return PokemonDetailDescriptionView(title: "Weight")
    }()
    
    private lazy var typesDescription: PokemonDetailDescriptionView = {
        return PokemonDetailDescriptionView(title: "Types")
    }()
    
    private lazy var abilitiesDescription: PokemonDetailDescriptionView = {
        return PokemonDetailDescriptionView(title: "Abilities")
    }()
    
    private lazy var formDescription: PokemonDetailDescriptionView = {
        return PokemonDetailDescriptionView(title: "Forms")
    }()
    
    func configure(detail: PokemonDetailBase?) {
        let types = detail?.types?.compactMap({ $0.type?.name?.capitalized }).joined(separator: ", ") ?? "Loading..."
        let abilities = detail?.abilities?.compactMap({ $0.ability?.name?.capitalized}).joined(separator: ", ") ?? "Loading..."
        let forms = detail?.forms?.compactMap({$0.name?.capitalized}).joined(separator: ", ") ?? "Loading..."
        let weight = String(format: "%.1fkg", Double(detail?.weight ?? 0) / 10.0)
        let height = String(format: "%.1fm", Double(detail?.height ?? 0) / 10.0)
        
        nameLabel.text = detail?.name?.capitalized
        idLabel.text = "# \(String(describing: detail?.identifier ?? 0))"
        heightDescription.setText(height)
        weightDescription.setText(weight)
        typesDescription.setText(types)
        abilitiesDescription.setText(abilities)
        formDescription.setText(forms)
        
        Task {
            imageView.image = await ImageCacheStore.shared.getCacheImage(for: detail?.sprites?.other?.officialArtwork?.frontDefault)
        }
    }
}

extension PokemonDetailView: ViewCodeProtocol {
    
    func setupHierarchy() {
        nameStackView.addArrangedSubview(idLabel)
        nameStackView.addArrangedSubview(nameLabel)
        
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(nameStackView)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(heightDescription)
        containerStackView.addSpacing(9)
        containerStackView.addArrangedSubview(weightDescription)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(typesDescription)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(formDescription)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(abilitiesDescription)
        
        scrollView.addSubview(containerStackView)
        addSubview(scrollView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            containerStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            containerStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func additionalSetup() {
        backgroundColor = .white
    }
}
