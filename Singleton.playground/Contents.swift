import UIKit

class Car {
    var color = "Red"
}

let myCar = Car()
myCar.color = "Blue"
myCar.color

let yourCar = Car()

yourCar.color

class Car2 {
    var color = "Red"

    static let singletonCar = Car2()
}

let myCar2 = Car2.singletonCar
myCar2.color = "Blue"
myCar.color

let yourCar2 = Car2.singletonCar
yourCar2.color


class A {
    init() {
        Car2.singletonCar.color = "Purple"
    }
}

class B {
    init() {
        print ("Class B: " + Car2.singletonCar.color)
    }
}

let a = A()
let b = B()
