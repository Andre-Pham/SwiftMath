//
//  File.swift
//  
//
//  Created by Andre Pham on 15/12/2024.
//

import Foundation

extension Array {
    
    func at(_ index: Int) -> Element? {
        return index >= 0 && index < self.count ? self[index] : nil
    }
    
}
