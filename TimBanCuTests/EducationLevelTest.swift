//
//  EducationLevel.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 10/29/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import XCTest
@testable import TimBanCu

class EducationLevelTest: XCTestCase {
    var elementary:EducationLevel! = .Elementary
    var middleSchool:EducationLevel! = .MiddleSchool
    var highSchool:EducationLevel! = .HighSchool
    var university:EducationLevel! = .University
    
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        elementary = nil
        middleSchool = nil
        highSchool = nil
        university = nil
    }
    
    func testGetString(){
        XCTAssertTrue(elementary.getString() == Constants.elementaryString)
        XCTAssertTrue(middleSchool.getString() == Constants.middleSchoolString)
        XCTAssertTrue(highSchool.getString() == Constants.highschoolString)
        XCTAssertTrue(university.getString() == Constants.universityString)
    }
}
