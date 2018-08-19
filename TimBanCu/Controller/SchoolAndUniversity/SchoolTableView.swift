//
//  SchoolTableView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension SchoolViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSchoolModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolTableViewCell") as? SchoolTableViewCell

        cell?.schoolViewModel = SchoolViewModel(school: searchSchoolModels[indexPath.row])
        return cell!
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! SchoolTableViewCell
        
        cell.schoolViewModel = SchoolViewModel(school: searchSchoolModels[indexPath.row])
        
        let lastInitialDisplayableCell = tableview.animateOnlyBeginingCells(tableView: tableView, indexPath: indexPath, model: searchSchoolModels, finishLoading: finishedLoadingInitialTableCells)
        
        if !finishedLoadingInitialTableCells {
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            tableview.animateCells(cell: cell, tableView: tableview, indexPath: indexPath)
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSchool = searchSchoolModels[indexPath.row]
        
        if(selectedSchoolType == "dh"){
            performSegue(withIdentifier: "SchoolToMajorSegue", sender: self)
        }
        else{
            performSegue(withIdentifier: "schoolToClassSegue", sender: self)
        }
    }
}
