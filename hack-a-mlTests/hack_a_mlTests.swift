//
//  hack_a_mlTests.swift
//  hack-a-mlTests
//
//  Created by Taylor Pubins on 2/16/24.
//

import XCTest
@testable import hack_a_ml

final class hack_a_mlCSV2PlayerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPlayerCreation() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        var randomRecord: Player?
        if let path = getCSVPath(), let csvData = readCSV(path: path) {
            randomRecord = getRandomRecord(from: csvData)
        }
        
        XCTAssert(randomRecord != nil)
        XCTAssert(randomRecord!.name.count > 0)
    }
    
    
    func testModelPrediction() throws {
        let model = EV50_BR_OZS_PA_2_HR()
        var randomPlayer: Player?
        if let path = getCSVPath(), let csvData = readCSV(path: path) {
            randomPlayer = getRandomRecord(from: csvData)
        }
        guard let prediction = try? model.prediction(pa: Int64(randomPlayer?["pa"] as! Int), barrel_batted_rate: randomPlayer?["barrel_batted_rate"] as! Double, avg_best_speed: randomPlayer?["avg_best_speed"] as! Double, oz_swing_percent: randomPlayer?["oz_swing_percent"] as! Double) else { throw PlayerError.statsOutOfBounds }
        print(prediction.home_run)
        XCTAssert(prediction.home_run > 0.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
