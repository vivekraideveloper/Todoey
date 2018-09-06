//
//  Category.swift
//  Todoey
//
//  Created by Vivek Rai on 06/09/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
