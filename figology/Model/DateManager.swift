//
//  DateManager.swift
//  
//
//  Created by olivia chen on 2025-04-27.
//

import Foundation

struct DateManager {

    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    }
    
    func formatCurrentDate(dateFormat: String) -> String {
        
        // Get the current date and time
        let date = Date()
        
        // Set formatter style to chosen format
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func formatString(dateString: String, stringFormat: String) -> Date {
        
        // Set formatter style to chosen format
        dateFormatter.dateFormat = stringFormat
        let date = dateFormatter.date(from: dateString)!
        return date
    }
}
