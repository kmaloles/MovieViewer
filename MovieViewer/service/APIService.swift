//
//  APIService.swift
//  MovieViewer
//
//  Created by Kevin Maloles on 4/18/18.
//  Copyright © 2018 Kevin Maloles. All rights reserved.
//

import Foundation
import Alamofire
import Gloss



class WebRequestManager {
    
    static let sharedInstance = WebRequestManager()
    let baseUrl = "http://ec2-52-76-75-52.ap-southeast-1.compute.amazonaws.com/"
    
    enum Data:String {
        case movie = "movie.json"
        case schedule = "schedule.json"
        case seatmap = "seatmap.json"
        
        func getUrl() -> String {
            return self.rawValue
        }
        
        func getData<T>(fromJson json: JSON) -> T? {
            switch self {
            case .movie: return Movie(json: json) as? T
            case .schedule: return MovieSchedule(json: json) as? T
            case .seatmap: return SeatMap(json: json) as? T
            }
        }
    }
    
    func getData<T>(_ data: Data, callback: @escaping (_ data:T?) -> Void) throws {
        let url = baseUrl + data.getUrl()
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default)
            .responseJSON { response in
                if let statusCode = response.response?.statusCode {
                    guard statusCode == 200 else {callback(nil);return}
                    if let result = response.result.value,
                        let json = result as? JSON
                    {
                        callback(data.getData(fromJson: json))
                    }else{
                        callback(nil)
                    }
                }else{
                    callback(nil)
                }
        }
    }

}
