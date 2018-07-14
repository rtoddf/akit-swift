import UIKit

extension Int {
    var degreesToRadians:Double { return Double(self) * .pi/180}
    
    // radius is radius in (miles * 0.00001) * 2
    var getPlanetRadius:Double { return (Double(self) * 0.00001) * 2}
    
    // distanceToSun is the million mile * 0.01
    var distanceToSun:Double { return 0.86882 + (Double(self) * 0.01) }
    
    // rotation round the sun is the earth days / 36.5 (365 earth days in a year divided by a 10 second rotation for the earth)
    var rotationAroundTheSun:Double { return Double(self) / (365 / 10) }
    
    // roation on it's own axis is hours / 8 (just a trial for now - we get 3 seconds for earth)
    var rotationOnAxis:Double { return Double(self) / 8 }
}
