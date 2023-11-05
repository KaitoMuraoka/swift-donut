import Foundation

let screenWidth = 80 // 適切な値に変更してください
let screenHight = 40 // 適切な値に変更してください
let thetaSpacing = 0.07
let phiSpacing = 0.02
let donutRadius = 0.5
let donutThickness = 1.0
let distanceToDonuts = 50.0
let observerToScreen = Double(screenWidth) * distanceToDonuts * 1.5 / (8 * (donutRadius + donutThickness))

while true {
    let A = Double(Date().timeIntervalSince1970) * 0.3
    let B = Double(Date().timeIntervalSince1970) * 0.2
    let output = Calculation().renderFrame(A, B)
    Calculation().printFrame(output)
    usleep(30000)
}
