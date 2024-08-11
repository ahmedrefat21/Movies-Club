//
//  DatabaseManager.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//


import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    
    static let sharedMovieDB = DatabaseManager()
    var arrayOfMovies: Array<LocalMovie> = []
    var nsManagedMovies : [NSManagedObject] = []
    let manager : NSManagedObjectContext!
    let entity: NSEntityDescription!
    
    private init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manager = appDelegate.persistentContainer.viewContext
        
        entity = NSEntityDescription.entity(forEntityName: "FavouriteMovie", in: manager)
    }
    
    
    func insertMovie(movie: LocalMovie){
      
        let favMovie = NSManagedObject(entity: entity!, insertInto: manager)
      
        favMovie.setValue(movie.id, forKey: "id")
        favMovie.setValue(movie.title, forKey: "title")
        favMovie.setValue(movie.image, forKey: "image")
        favMovie.setValue(movie.rating, forKey: "rating")
        favMovie.setValue(movie.releaseDate, forKey: "releaseDate")
        do {
            try manager.save()
            print("saved")
        } catch let error as NSError{
            print(error)
        }
    }
    
    func fetchAllMovies() -> Array<LocalMovie>? {
        arrayOfMovies = []
      
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteMovie")
        do{
            nsManagedMovies = try manager.fetch(fetchRequest)
            
            for movie in nsManagedMovies{
                var movieObj = LocalMovie(id: 0, title: "", rating: 0.0, releaseDate: "", image: "")
                movieObj.id = movie.value(forKey: "id") as! Int
                movieObj.title = movie.value(forKey: "title") as! String
                movieObj.rating = movie.value(forKey: "rating") as! Double
                movieObj.image = movie.value(forKey: "image") as! String
                movieObj.releaseDate = movie.value(forKey: "releaseDate") as! String
                arrayOfMovies.append(movieObj)
            }
            return  arrayOfMovies
            
        } catch let error as NSError{
              print(error)
              return []
          }
    }
    
    

    func delete(id: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteMovie")
        do {
            nsManagedMovies = try manager.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
            return
        }
        
        for element in nsManagedMovies {
            if let deletedID = element.value(forKey: "id") as? Int, deletedID == id {
                manager.delete(element)
            }
        }
        
        do {
            try manager.save()
            print("Deleted!")
            arrayOfMovies = arrayOfMovies.filter { $0.id != id } // Update arrayOfProducts
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func isFavorite(productId: Int, customerId: Int) -> Bool {
        let allMoviesList = fetchAllMovies()
        for movie in allMoviesList! {
            if(movie.id == productId) {
                return true
            }
        }
        return false
    }
    

    
}

