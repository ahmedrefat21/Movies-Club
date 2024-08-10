//
//  MovieDetailsViewController.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import UIKit

import UIKit
import ProgressHUD
import Cosmos

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieTotalRating: UILabel!
    @IBOutlet weak var movieRatinginStars: CosmosView!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    var movie : MovieDetail!
    var movieID : Int = 0
    var genres: [Genre] = []
    private let appearance = UINavigationBarAppearance()
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show()
        registerCell()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    private func fetchData(){
        NetworkService.shared.fetchMovieDetails(id: movieID) { [weak self] (result) in
            switch result {
            case .success(let movies):
                ProgressHUD.dismiss()
                
                self?.movie = movies
                self?.populateView()
                self?.genresCollectionView.reloadData()
            case .failure(let error):
                print("error")
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(named: "Background")
        navigationItem.standardAppearance = appearance
    }
    
    private func registerCell() {
        genresCollectionView.register(UINib(nibName: GenreCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
    }
    
    private func populateView (){
        
        posterImageView.kf.setImage(with: URL(string: Route.imageBaseUrl + (movie.posterPath ?? "")))
        movieImageView.kf.setImage(with: URL(string: Route.imageBaseUrl + (movie.backdropPath ?? "")))
        movieTitleLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        movieReleaseDateLabel.text = movie.releaseDate
        movieTotalRating.text = String(format: "%.1f", movie.voteAverage ?? 0)
        movieRatinginStars.rating = Double((movie.voteAverage ?? 0) / 2)
        genres = movie.genres ?? []
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
       
    }
}


extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genresCollectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
        cell.gernes.text = genres[indexPath.row].name
        return cell
    }
    
}


