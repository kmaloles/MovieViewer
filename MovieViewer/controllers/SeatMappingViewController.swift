//
//  SeatMappingViewController.swift
//  MovieViewer
//
//  Created by Kevin Maloles on 4/18/18.
//  Copyright © 2018 Kevin Maloles. All rights reserved.
//

import Foundation
import UIKit

class SeatMappingViewController: UIViewController {
    
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var cinemaButton: UIButton!
    
    @IBOutlet weak var containerLabel: UIView!
    
    @IBOutlet weak var timeButton: UIButton!
    
    var schedule: MovieSchedule?
    var seatMapping: SeatMap?
    
    @IBOutlet weak var selectedLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var cinemaText = ""
    var dateText = ""
    var timeText = ""
    
    var itemSizePreferred:CGFloat = 0.0
    
    var selectedSeats:Set<(String)> = []
    var selectedIndexPaths:Set<IndexPath> = []
    
    var totalAmount: String? {
        let total = Double(self.selectedSchedule?.price ?? "0")! * Double(self.selectedSeats.count)
        return total.toCurrency()
    }
    
    var scale:CGFloat = 1.0
    
    var selectedDate: MovieDate? {
        didSet{
            self.clearEverything()
            guard let s = selectedDate else {return}
            self.dateButton.setTitle(s.label ?? "", for: .normal)
            self.selectCinemaNumber(fromDate: s)
        }
    }
    var selectedCinema: CinemaNumber? {
        didSet{
            self.clearEverything()
            if let s = selectedCinema {
                self.cinemaButton.setTitle(s.label ?? "", for: .normal)
                self.cinemaButton.isUserInteractionEnabled = true
                self.selectSchedule(fromCinema: s)
            }else{
                self.cinemaButton.setTitle("---", for: .normal)
                self.selectedSchedule = nil
                self.cinemaButton.isUserInteractionEnabled = false
            }
            
        }
    }
    var selectedSchedule: TimeSchedule?{
        didSet{
            self.clearEverything()
            if let s = selectedSchedule {
                self.timeButton.setTitle(s.label ?? "", for: .normal)
                self.timeButton.isUserInteractionEnabled = true
            }else{
                self.timeButton.setTitle("---", for: .normal)
                self.timeButton.isUserInteractionEnabled = false
            }
        }
    }
    
    
    static func storyboardInstance() -> SeatMappingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier:String(describing: SeatMappingViewController.self) ) as! SeatMappingViewController
    }
    
    override func viewDidLoad() {
        initCollectionView()
        super.viewDidLoad()
        getSeatMapping()
        getMovieSchedule()
        
    }
    
    func clearEverything(){
        self.selectedLabel.text = ""
        self.totalLabel.text = ""
        self.selectedSeats.removeAll()
        self.collectionView.reloadItems(at: Array(self.selectedIndexPaths))
        self.selectedIndexPaths.removeAll()
    }
    
    
    func initCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SeatsCollectionViewCell.nib(), forCellWithReuseIdentifier: SeatsCollectionViewCell.reuseIdentifier())
        
        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(self.didDetectPinch(_:)))
        self.collectionView.addGestureRecognizer(pinch)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let size = self.getDeviceWidth() * 0.021
        self.itemSizePreferred = size
        layout.itemSize = CGSize.init(width: size, height: size)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
//        print("DEVICE WIDTH \(self.getDeviceWidth())")
        collectionView.collectionViewLayout = layout
        
        containerLabel.addBorder(color: .lightGray)
        self.view.updateConstraintsIfNeeded()
    }
    
    @objc func didDetectPinch(_ gesture: UIPinchGestureRecognizer){
        var scale:CGFloat = 1.0
        
        if gesture.state == .began {
            scale = self.scale
        }else if gesture.state == .changed {
            self.scale = scale * gesture.scale
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func getMovieSchedule(){
        self.showLoading()
        do {
            try WebRequestManager.sharedInstance.getData(.schedule){ (data:MovieSchedule?) in
                self.hideLoading()
                guard let fetchedData = data else {return}
                self.schedule = fetchedData
                self.selectAvailableDate()
            }
        }catch{
            self.hideLoading()
            print("ViewController:getMovieSchedule `\(error)")
        }
    }
    
    func getSeatMapping(){
        do {
            try WebRequestManager.sharedInstance.getData(.seatmap){ (data:SeatMap?) in
                guard let fetchedData = data else {return}
                self.seatMapping = fetchedData
                self.collectionView.reloadData()
            }
        }catch{
            print("ViewController:getMovieSchedule \(error)")
        }
    }
    
    func selectAvailableDate(forKey key:String? = nil) {
        guard let fetchedSchedule = self.schedule else {return}
        if let k = key {
            let s = fetchedSchedule.dates?.filter{$0.label == k}.first
            self.selectedDate = s
        }else{
            guard let firstDateAvailable = fetchedSchedule.dates?.first else {return}
            self.selectedDate = firstDateAvailable
        }
    }
    
    func selectCinemaNumber(fromDate date: MovieDate, forKey key: String? = nil){
        guard let fetchedSchedule = self.schedule else {return}
        //display first cinema number based from key as default
        let selectedCinema = fetchedSchedule.cinemas?.filter{$0.parent == date.id}
        guard let cinemaForDate = selectedCinema?.first else {self.selectedCinema = nil;return}
        if let k = key {
            self.selectedCinema = cinemaForDate.cinemas?.filter{$0.label == k}.first
        }else{
            self.selectedCinema = cinemaForDate.cinemas?.first
        }
    }
    
    func selectSchedule(fromCinema cinema: CinemaNumber){
        guard let fetchedSchedule = self.schedule else {return}
        //display first schedule from first cinema
        let selectedTimeSlot = fetchedSchedule.schedules?.filter{$0.parent == cinema.id}
        guard let scheduleForCinema = selectedTimeSlot?.first else {self.selectedSchedule = nil; return}
        guard let firstSchedule = scheduleForCinema.times?.first else {return}
        self.selectedSchedule = firstSchedule
    }
    
    
    @IBAction func onDatePressed(_ sender: UIButton) {
        guard let fetchedSchedule = self.schedule else {return}
        guard let dates = fetchedSchedule.dates else {return}
        var dateList:[String] = []
        _ = dates.map{dateList.append($0.label ?? "")}
        self.showPicker(dateList) { (action) in
            self.selectAvailableDate(forKey: action.title ?? "")
        }
    }
    
    @IBAction func onCinemaPressed(_ sender: UIButton) {
        guard let fetchedSchedule = self.schedule else {return}
        guard let sDate = self.selectedDate else {return}
        let cinemas = fetchedSchedule.cinemas?.filter{$0.parent == sDate.id}
        guard let selectedCinema = cinemas?.first else {self.selectedSchedule = nil; return}
        var cinemasList:[String] = []
        guard let c = selectedCinema.cinemas else {return}
        _ = c.map{cinemasList.append($0.label ?? "")}
        self.showPicker(cinemasList) { (action) in
            self.selectCinemaNumber(fromDate: sDate, forKey: action.title ?? "")
        }
    }
    
    @IBAction func onTimePressed(_ sender: UIButton) {
        guard let fetchedSchedule = self.schedule else {return}
        guard let sCinema = self.selectedCinema else {return}
        let schedules = fetchedSchedule.schedules?.filter{$0.parent == sCinema.id}
        guard let selectedSchedule = schedules?.first else {return}
        guard let t = selectedSchedule.times else {return}
        var scheduleList:[String] = []
        _ = t.map{scheduleList.append($0.label ?? "")}
        self.showPicker(scheduleList) { (action) in
            self.selectSchedule(fromCinema: sCinema)
            self.timeButton.setTitle(action.title ?? "", for: .normal)
        }
    }
    
}

extension SeatMappingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.seatMapping?.seats?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.itemSizePreferred * self.scale, height: self.itemSizePreferred * self.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let offset = section == 0 ? 4 : 2
        return (self.seatMapping?.seats?[section].count ?? 0) + offset
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = self.seatMapping?.seats?[indexPath.section]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeatsCollectionViewCell.reuseIdentifier(), for: indexPath) as! SeatsCollectionViewCell
        
        cell.resetCell()
        
        if indexPath.item == 0 || (indexPath.item == 37) {
            cell.bgView.backgroundColor = .white
            let label = section?[0].first ?? " "
            cell.seatLabel.text = "\(label)"
        }
        
        if (indexPath.section) == 0 {
            if (indexPath.item == 1 || indexPath.item == 36) {
                cell.bgView.isHidden = true
            }
            guard indexPath.item > 0 else {return cell}
            if indexPath.item > 36 {
                
                cell.bgView.backgroundColor = indexPath.item < 36 ? .lightGray : .white
                return cell
            }else{
                let item = section?[indexPath.item - 1] ?? ""
                if (item).contains("(") {
                    cell.bgView.isHidden = true
                }
                
                if !(self.seatMapping?.availableSeats?.list?.contains(item) ?? false) {
                    cell.bgView.backgroundColor = .blue
                }
                
                if self.selectedSeats.contains(item){
                    cell.checkImage.isHidden = false
                    cell.bgView.backgroundColor = .red
                }
                
            }
        }else{
            guard indexPath.item > 0 && indexPath.item < 37 else {return cell}
            let item = section?[indexPath.item - 1] ?? ""
            if (item).contains("(") {
                cell.bgView.isHidden = true
            }
            if !((self.seatMapping?.availableSeats?.list?.contains(where: {$0 == item}))!) {
                cell.bgView.backgroundColor = .blue
            }
            
            if self.selectedSeats.contains(item){
                cell.checkImage.isHidden = false
                cell.bgView.backgroundColor = .red
            }
            
        }
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSection = indexPath.section
        let sectionItems = self.seatMapping?.seats?[selectedSection]
        let selectedItem = indexPath.item
        guard selectedItem > 0 && selectedItem < 37 else {return}
        let item = sectionItems?[selectedItem - 1]
        guard ((self.seatMapping?.availableSeats?.list?.contains(where: {$0 == item}))!) else {return}
        guard self.selectedSeats.count < 10 else {return}
        let s = item ?? ""
        if self.selectedSeats.contains(s){
            self.selectedSeats.remove(s)
            self.selectedIndexPaths.remove(indexPath)
        }else{
            self.selectedSeats.insert(s)
            self.selectedIndexPaths.insert(indexPath)
        }
        self.collectionView.reloadItems(at: [indexPath])
        self.buildAttributedString()
    }
    
    
    
    func buildAttributedString(){
        let att1 = [ NSAttributedStringKey.backgroundColor: UIColor.red, NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial", size: 15.0)! ]
        let result = NSMutableAttributedString()
        for s in self.selectedSeats {
            let string = NSMutableAttributedString(string: s, attributes: att1)
            result.append(string)
            result.append(NSMutableAttributedString(string: " "))
        }
        
        self.selectedLabel.attributedText = result
        
        self.totalLabel.text = self.totalAmount ?? ""
    }
    
    func showPicker(_ data: [String], callback: @escaping (UIAlertAction) -> ()){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for i in data {
            alert.addAction(UIAlertAction(title: i, style: .default, handler: callback))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
