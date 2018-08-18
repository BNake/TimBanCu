//
//  ClassDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Lottie

class ClassDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var addYourselfBtn: UIButton!
    
    @IBOutlet weak var chatBtn: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func unwindToClassDetailViewController(segue:UIStoryboardSegue) { }
    
<<<<<<< HEAD:TimBanCu/Controller/Class Detail/ClassDetailViewController.swift
    // segue from previous class
    var classDetail:ClassProtocol!
=======
    var finishedLoadingInitialTableCells = false
>>>>>>> UI-Design:TimBanCu/Controller/ClassDetailViewController.swift
    
    // backend
    var students = [Student]()
    var searchStudents = [Student]()
    var selectedStudent:Student!
    
    //no result
    var noResultLabel = NoResultLabel(type: Type.Student)
    
    //ui
    let customSelectionColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0, alpha: 0.2)
        return view
    }()
    
    let animatedEmoticon: LOTAnimationView = {
        let animation = LOTAnimationView(name: "empty_list")
        animation.contentMode = .scaleAspectFill
        animation.loopAnimation = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    var searchTFUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0).withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var searchUnderlineHeightAnchor: NSLayoutConstraint?
    
    // firebase
    var classEnrollRef:DatabaseReference!
    
    override func viewDidLoad() {
        customizeSearchTF()
        setUpAnimatedEmoticon()
        tableview.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        
        classEnrollRef = Database.database().reference().child("students").child(classDetail.getFirebasePathWithSchoolYear())
        
        updateTableviewVisibilityBasedOnSearchResult()
        
        noResultLabel.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
<<<<<<< HEAD:TimBanCu/Controller/Class Detail/ClassDetailViewController.swift
        students.removeAll()
        searchStudents.removeAll()
=======
        noResultLabel.isHidden = true
        animatedEmoticon.isHidden = true
>>>>>>> UI-Design:TimBanCu/Controller/ClassDetailViewController.swift
        
        startLoading()
        fetchData {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    func showAddYourInfoBtnIfYouAreNotInTheClass(){
        chatBtn.isEnabled = false
        addYourselfBtn.isHidden = false
        
        for student in students{
            if(student.uid == CurrentUserHelper.getUid()){
                addYourselfBtn.isHidden = true
                chatBtn.isEnabled = true
            }
        }
    }    
    
    func fetchData(completionHandler: @escaping () -> Void){
        students.removeAll()
        searchStudents.removeAll()
        
        classEnrollRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let uid = (snap as! DataSnapshot).key 
                
                AllUserHelper.getAnyStudentFromDatabase(uid: uid, completionHandler: { (student) in
                    self.students.append(student)
                    self.searchStudents.append(student)
                    
                    if(self.students.count == snapshot.children.allObjects.count){
                        completionHandler()
                    }
                })
            }
            
            if(snapshot.children.allObjects.count == 0){
                completionHandler()
            }
        }
    }
    
    func reloadData(){
        self.searchStudents = self.students
        self.tableview.reloadData()
        self.stopLoading()
        self.updateTableviewVisibilityBasedOnSearchResult()
        self.showAddYourInfoBtnIfYouAreNotInTheClass()
    }
    
    
<<<<<<< HEAD:TimBanCu/Controller/Class Detail/ClassDetailViewController.swift
=======
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailTableViewCell") as? ClassDetailTableViewCell
        
        let student = searchStudents[indexPath.row]
        
        cell?.nameLabel.text = student.fullName
        cell?.selectedBackgroundView = customSelectionColorView
        
        cell?.nameLabel!.hero.id = "\(student.fullName)"
        cell?.imageview!.hero.id = "\(student.fullName)image"
        cell?.nameLabel!.hero.modifiers = [.arc]
        cell?.imageview!.hero.modifiers = [.arc]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStudent = searchStudents[indexPath.row]
        performSegue(withIdentifier: "ClassDetailToStudentDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var lastInitialDisplayableCell = false
        
        if searchStudents.count > 0 && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }
        
        if !finishedLoadingInitialTableCells {
            
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            cell.transform = CGAffineTransform(translationX: 0, y: tableview.rowHeight / 2)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
        
    }
>>>>>>> UI-Design:TimBanCu/Controller/ClassDetailViewController.swift

    @IBAction func addYourselfBtnPressed(_ sender: Any) {
        if(!CurrentUserHelper.hasEnoughDataInFireBase()){
            performSegue(withIdentifier: "ClassDetailToAddYourInfoSegue", sender: self)
        }
        else{
            enrollUserToClass()
        }
    }
    
    func enrollUserToClass(){
        classEnrollRef.child(CurrentUserHelper.getUid()).setValue(CurrentUserHelper.getFullname()) { (error, ref) in
            if(error == nil){
                DispatchQueue.main.async {
                    self.students.append(CurrentUserHelper.getStudent())
                    self.reloadData()
                }
            }
        }
        
        CurrentUserHelper.addEnrollment(classD: classDetail)
    }
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "ClassDetailToChatSegue", sender: self)
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchStudents.count == 0){
            noResultLabel.isHidden = false
            tableview.isHidden = true
            animatedEmoticon.isHidden = false
            animatedEmoticon.play()
        }
        else{
            noResultLabel.isHidden = true
            tableview.isHidden = false
            animatedEmoticon.isHidden = true
            animatedEmoticon.stop()
        }
    }
    
    func startLoading(){
        tableview.isHidden = true
        searchTF.isHidden = true
        addYourselfBtn.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading(){
        UIView.animate(withDuration: 1) {
            self.tableview.isHidden = false
            self.searchTF.isHidden = false
            self.activityIndicator.isHidden = true
        }
        activityIndicator.stopAnimating()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            destination.classDetail = classDetail as! ClassDetail
        }
        if let destination = segue.destination as? StudentDetailViewController{
            destination.student = selectedStudent
        }
        
        if let destination = segue.destination as? ChatViewController{
            destination.classDetail = classDetail as! ClassDetail
        }
        
    }

}