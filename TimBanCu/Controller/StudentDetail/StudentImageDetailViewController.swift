//
//  ImageDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/28/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class StudentImageDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageview: UIImageView!
    var image:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageview.image = image

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
