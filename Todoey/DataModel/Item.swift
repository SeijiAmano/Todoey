//
//  Item.swift
//  Todoey
//
//  Created by Seiji AMANO on 2019/02/02.
//  Copyright © 2019 Seiji AMANO. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title : String = ""
    var done: Bool = false
}
