//
//  DateFormatHelper.swift
//  MovieViewer
//
//  Created by Kevin Maloles on 4/19/18.
//  Copyright © 2018 Kevin Maloles. All rights reserved.
//

import Foundation
import DateTools

class DateFormatHelper{
    
    let serverFormat = "YYYY-MM-dd"
    let movieFormat = "MMM dd, YYYY"
    let serverFormatter = DateFormatter()
    let movieFormatter = DateFormatter()
    
    static let sharedInstance: DateFormatHelper = DateFormatHelper()
    
    init(){
        serverFormatter.dateFormat = serverFormat
        movieFormatter.dateFormat = movieFormat
    }
    
    func getMovieDateFormat (fromString d: String) -> String {
        let date = serverFormatter.date(from: d) ?? Date()
        return movieFormatter.string(from: date)
    }
    
}
