import Foundation

let screen_width = Int(80 * 0.75) // 適切な値に変更してください
let screen_height = Int(24 * 0.75) // 適切な値に変更してください
let theta_spacing = 0.07
let phi_spacing = 0.02
let R1 = 0.5
let R2 = 1.0
let K2 = 50.0
let K1 = Double(screen_width) * K2 * 1.5 / (8 * (R1 + R2))

func render_frame(A: Double, B: Double) {
    var output = Array(repeating: Array(repeating: " ", count: screen_width), count: screen_height)
    var zbuffer = Array(repeating: Array(repeating: 0.0, count: screen_width), count: screen_height)
    
    let cosA = cos(A)
    let sinA = sin(A)
    let cosB = cos(B)
    let sinB = sin(B)
    
    for theta in stride(from: 0, to: 2 * Double.pi, by: theta_spacing) {
        let costheta = cos(theta)
        let sintheta = sin(theta)
        
        for phi in stride(from: 0, to: 2 * Double.pi, by: phi_spacing) {
            let cosphi = cos(phi)
            let sinphi = sin(phi)
            
            let circlex = R2 + R1 * costheta
            let circley = R1 * sintheta
            
            let x = circlex * (cosB * cosphi + sinA * sinB * sinphi) - circley * cosA * sinB
            let y = circlex * (sinB * cosphi - sinA * cosB * sinphi) + circley * cosA * cosB
            let z = K2 + cosA * circlex * sinphi + circley * sinA
            let ooz = 1 / z
            
            let xOffset = screen_width / 2
            let yOffset = screen_height / 2
            
            let xProjection = K1 * ooz * x
            let yProjection = K1 * ooz * y
            
            let xp = xOffset + Int(xProjection)
            let yp = yOffset - Int(yProjection)
            
            let L = cosphi * costheta * sinB - cosA * costheta * sinphi - sinA * sintheta + cosB * (cosA * sintheta - costheta * sinA * sinphi)
            if L > 0 {
                if xp >= 0 && xp < screen_width && yp >= 0 && yp < screen_height {
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
    
    print("\u{001B}[H")
    for row in output {
        for char in row {
            print(char, terminator: "")
        }
        print()
    }
}

while true {
    for _ in 0..<screen_height {
        print()
    }
    let A = Double(Date().timeIntervalSince1970) * 0.3
    let B = Double(Date().timeIntervalSince1970) * 0.2
    render_frame(A: A, B: B)
    usleep(30000)
}
