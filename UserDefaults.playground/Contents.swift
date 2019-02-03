//
//  UserDefault.swift
//  Todoey
//
//  Created by Seiji AMANO on 2019/02/01.
//  Copyright © 2019 Seiji AMANO. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard

defaults.set(0.24, forKey: "Volume")
defaults.set(true, forKey: "MusicOn")
defaults.set("Seiji", forKey: "PlayerName")
defaults.set(Date(), forKey: "LastOpenedByPlayer")
let array = [1, 2, 3]
defaults.set(array, forKey: "myArray")
let dictionary = ["name": "Seiji"]
defaults.set(dictionary, forKey: "myDictionary")


let volume = defaults.float(forKey: "Volume")
let lastOpenDate = defaults.object(forKey: "LastOpenedByPlayer")
let userName = defaults.object(forKey: "PlayerName")
let boolVal = defaults.bool(forKey: "MusicOn")
let myArray = defaults.array(forKey: "myArray") as! [Int]
let myDictionary = defaults.dictionary(forKey: "myDictionary")

