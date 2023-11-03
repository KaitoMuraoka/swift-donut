import Foundation

let screenWidth = Int(80 * 0.75) // 適切な値に変更してください
let screenHight = Int(24 * 0.75) // 適切な値に変更してください
let thetaSpacing = 0.07
let phiSpacing = 0.02
let donutRadius = 0.5
let donutThickness = 1.0
let distanceToDonuts = 50.0
let observerToScreen = Double(screenWidth) * distanceToDonuts * 1.5 / (8 * (donutRadius + donutThickness))

while true {
    for _ in 0..<screenHight {
        print()
    }
    let A = Double(Date().timeIntervalSince1970) * 0.3
    let B = Double(Date().timeIntervalSince1970) * 0.2
    Calculation().renderFrame(A, B)
    usleep(30000)
}
