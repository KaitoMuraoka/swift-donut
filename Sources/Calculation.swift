//
//  Calculation.swift
//  
//　Creating a theory of donut math
//  Created by 村岡海人 on 2023/11/03.
//

import Foundation

struct Calculation {
    func renderFrame(_ A: Double, _ B: Double) -> [[String]] {
        var output = Array(repeating: Array(repeating: " ", count: screenWidth), count: screenHight)
        var zbuffer = Array(repeating: Array(repeating: 0.0, count: screenWidth), count: screenHight)
        
        // precompute sines and cosines of A and B
        let cosA = cos(A)
        let sinA = sin(A)
        let cosB = cos(B)
        let sinB = sin(B)
        
        // theta goes around the cross-sectional circle of a torus
        for theta in stride(from: 0, to: 2 * Double.pi, by: thetaSpacing) {
            // precompute sines and cosines of theta
            let costheta = cos(theta)
            let sintheta = sin(theta)
            
            // phi goes around the center of revolution of a torus
            for phi in stride(from: 0, to: 2 * Double.pi, by: phiSpacing) {
                // precompute sines and cosines of phi
                let cosphi = cos(phi)
                let sinphi = sin(phi)
                
                // the x,y coordinate of the circle, before revolving (factored
                // out of the above equations)
                let circlex = donutThickness + donutRadius * costheta
                let circley = donutRadius * sintheta
                
                // final 3D (x,y,z) coordinate after rotations, directly from
                let x = circlex * (cosB * cosphi + sinA * sinB * sinphi) - circley * cosA * sinB
                let y = circlex * (sinB * cosphi - sinA * cosB * sinphi) + circley * cosA * cosB
                let z = distanceToDonuts + cosA * circlex * sinphi + circley * sinA
                let ooz = 1 / z
                
                let xOffset = screenWidth / 2
                let yOffset = screenHight / 2
                
                let xProjection = observerToScreen * ooz * x
                let yProjection = observerToScreen * ooz * y
                
                // x and y projection.  note that y is negated here, because y goes up in 3D space but down on 2D displays.
                let xp = xOffset + Int(xProjection)
                let yp = yOffset - Int(yProjection)
                
                /**
                 Change the letters according to the brightness of the object to create a threedimensional effect.
                 */
                let L = cosphi * costheta * sinB - cosA * costheta * sinphi - sinA * sintheta + cosB * (cosA * sintheta - costheta * sinA * sinphi)
                if L > 0 {
                    if xp >= 0 && xp < screenWidth && yp >= 0 && yp < screenHight {
                        if ooz > zbuffer[yp][xp] {
                            zbuffer[yp][xp] = ooz
                            let luminance_chars = ".,-~:;=!*#$@"
                            let luminance_index = min(Int(L * 8), luminance_chars.count - 1)
                            output[yp][xp] = String(luminance_chars[luminance_chars.index(luminance_chars.startIndex, offsetBy: luminance_index)])
                        }
                    }
                }
            }
        }
        return output
    }
    
    func printFrame(_ output: [[String]]) {
        print("\u{001B}[H")
        for row in output {
            for char in row {
                print(char, terminator: "")
            }
            print()
        }
    }
}
