//
//  ViewController.swift
//  MovieViewer
//
//  Created by Kevin Maloles on 4/18/18.
//  Copyright © 2018 Kevin Maloles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var landscapeImageView: UIImageView!
    
    @IBOutlet weak var portraitImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var advisoryRatingLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    
    @IBOutlet weak var theaterLabel: UILabel!
    
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovie()
    }
    
    func getMovie(){
        do {
            try WebRequestManager.sharedInstance.getData(.movie){ (data:Movie?) in
                guard let fetchedData = data else {return}
                self.movie = fetchedData
                self.initSubViews()
            }
        }catch{
            print("ViewController:getMovie \(error)")
        }
    }
    
    func initSubViews(){
        landscapeImageView.downloadImageFromUrl(movie?.posterImageLandscape ?? "")
        portraitImageView.downloadImageFromUrl(movie?.posterImage ?? "")
        nameLabel.text = movie?.canonical_title ?? ""
        genreLabel.text = movie?.genre ?? ""
        advisoryRatingLabel.text = movie?.advisoryRating ?? ""
        let hoursText = Double(movie?.runtimeMins ?? "0.0")?.toHours() ?? ""
        durationLabel.text = hoursText
        releaseDateLabel.text = DateFormatHelper.sharedInstance.getMovieDateFormat(fromString: movie?.releaseDate ?? "")
        synopsisLabel.text = movie?.synopsis ?? ""
        theaterLabel.text = movie?.theater ?? ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onViewSeatMapTapped(_ sender: UIButton) {
        let vc = SeatMappingViewController.storyboardInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

