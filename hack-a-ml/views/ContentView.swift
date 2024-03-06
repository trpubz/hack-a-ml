//
//  ContentView.swift
//  hack-a-ml
//
//  Created by Taylor Pubins on 2/16/24.
//

import SwiftUI

struct ContentView: View {
    let model = EV50_BR_OZS_PA_2_HR()
    @State private var randomPlayer: Player?
    @State private var showResultText = false
    @State var truth: Int = 0
    @State var hr: Double = 0.0
    @State var bambinoBI: Double = 0.0
    @State var score: Int = 0
    
    var body: some View {
        VStack {
            Text("See if you're smarter than BambinoBI")
                .font(.title)
                .multilineTextAlignment(.center)
            Text("Score: \(score)")
            Spacer()
            Button("Get Random Player") {
                showResultText = false
                randomPlayer = nil  // reset player here
                
                if let path = getCSVPath(), let csvData = readCSV(path: path) {
                    randomPlayer = getRandomRecord(from: csvData)
                    guard let prediction = try? model.prediction(
                        pa: Int64(randomPlayer?["pa"] as! Int),
                        barrel_batted_rate: Double(truncating: randomPlayer?["barrel_batted_rate"] as! NSNumber),
                        avg_best_speed: Double(truncating: randomPlayer?["avg_best_speed"] as! NSNumber),
                        oz_swing_percent: Double(truncating: randomPlayer?["oz_swing_percent"] as! NSNumber))
                    else { fatalError("bad model data") }
                    print(randomPlayer!.name!, prediction.home_run)
                    bambinoBI = prediction.home_run
                }
            }
            // Display randomly sampled record here (if randomRecord is not nil)
            if let player = randomPlayer?.name {
                Text("\(player)")
                Text("PA: \(randomPlayer?["pa"] as! Int)")
                let slgFormatted = String(format: "%.3f",
                                          randomPlayer?["slg_percent"] as! Double)
                Text("SLG: \(slgFormatted)")
                let ev50Formatted = String(format: "%.1f",
                                           randomPlayer?["avg_best_speed"] as! Double)
                let attributedString = try! AttributedString(markdown: "[EV50:](http://tangotiger.com/index.php/site/article/statcast-metric-best-speed) \(ev50Formatted)")

                Text(attributedString)
            } else {
                Text("Nobody Chosen")
            }
            
            Spacer()
            
            if showResultText {
                ResultView(
                    playerName: randomPlayer?.name,
                    hr: Int(hr),
                    truth: truth,
                    bambinoBI: bambinoBI
                )
            }
            
            Spacer()
            
            if !showResultText {
                Text("Guess how many dingers he hit in 2023")
            }
            
            VStack {
                Slider(value: $hr, in: 0.0...72.0, step: 1.0)
                Text("\(Int(hr))")
            }
            .padding(100)
            
            
            Button("Submit Guess") {
                if let player = randomPlayer {
                    truth = player["home_run"] as! Int
                    if (Int(hr) - truth).magnitude <= (Int(bambinoBI) - truth).magnitude {
                        score += 1
                    }
                    showResultText = true
                }
            }
        }
        .padding(26)
    }
}

func getCSVPath() -> String? {
    guard let path = Bundle.main.path(forResource: "statcast", ofType: "csv") else {
        print("CSV file not found")
        return nil
    }
    return path
}

func readCSV(path: String) -> [[Any]]? {
    do {
        let contents = try String(contentsOfFile: path, encoding: .utf8)
        let parsedCSV = contents.components(separatedBy: "\n")
            .map { row in
                row.components(separatedBy: ",").map { field in
                    let cleaned = field.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "")
                    
                    return convertStringToNumber(cleaned)
                }
            }
        
        return parsedCSV
    } catch {
        print("Error reading CSV: \(error)")
        return nil
    }
}

func convertStringToNumber(_ field: String) -> Any {
    if let intValue = Int(field) {
        return intValue
    } else if let floatValue = Double(field) {
        return floatValue
    } else {
        return field // Return original string if not numeric
    }
}

func getRandomRecord(from csvData: [[Any]]) -> Player? {
    guard csvData.count > 1 else { return nil }  // At least one record
    let randomIndex = Int.random(in: 1..<csvData.count) // Skip header row
    let record = csvData[randomIndex]
    let headerRow = csvData[0]
    
    // Create a dictionary of field name to value
    var playerData = [String: Any]()
    
    for (index, field) in headerRow.enumerated() {
        playerData[field as! String] = record[index]
    }

    return Player(kwargs: playerData)
}

#Preview {
    ContentView()
}
