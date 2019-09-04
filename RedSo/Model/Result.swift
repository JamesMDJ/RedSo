//
//  Result.swift
//  RedSo
//
//  Created by 馬丹君 on 2019/9/3.
//  Copyright © 2019 MaJ. All rights reserved.
//

import Foundation
struct Result: Decodable {
    let id: String?
    let type:String?
    let url:String?
    let name: String?
    let position:String?
    let expertise:Array<String>?
    let avatar:String?
}

