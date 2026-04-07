//
//  MockData.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//
import Foundation

struct MockData {
    static let shared = MockData()
    private init() { }
    
    func title(_ viewName: String) -> String {
        "Mock Title For \(viewName)"
    }
    
    func subtitle(_ viewName: String) -> String {
        "This is the Mock Subtitle for \(viewName)"
    }
}
