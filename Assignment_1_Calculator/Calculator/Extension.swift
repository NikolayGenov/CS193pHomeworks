//
//  Extension.swift
//  Calculator
//
//  Created by Nikolay Genov on 5/10/17.
//  Copyright © 2017 Nikolay Genov. All rights reserved.
//

import Foundation

extension Double {
    var clean: String {
        return  self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
