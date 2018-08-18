//
//  Class.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ClassProtocol{
    func getFirebasePathWithoutSchoolYear()->String
    func getFirebasePathWithSchoolYear()->String
    func writeToDatabase(completionHandler: @escaping (_ err:Error?,_ ref:DatabaseReference) -> Void)
}
