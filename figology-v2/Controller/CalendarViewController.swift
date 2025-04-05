//
//  CalendarViewController.swift
//  figology-v2
//
//  Created by emily zhang on 2025-03-24.
//

import SwiftUI
import UIKit
import Foundation

// UIViewController that will host the SwiftUI CalendarScene (from GPT) 
class CalendarViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUICalendar()
    }
    
    private func setupSwiftUICalendar() {
        // Create the SwiftUI view
        let calendarScene = CalendarScene()
        
        // Create a UIHostingController to embed SwiftUI inside UIKit
        let hostingController = UIHostingController(rootView: calendarScene)
        
        // Add hostingController as a child view controller
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == K.resultPickerSegue {
                let destinationVC = segue.destination as! FoodViewController
                destinationVC.dateString = "234" // change
            }
        }
}

struct CalendarScene: View {
    // State variables to track selected date, calendar identifier, and other UI states
    @State private var selectedIdentifier: Calendar.Identifier = .gregorian // Calendar type (Gregorian by default)
    @State private var selectedDate: Date? // Selected date from the calendar
    @State private var selectedDateFromPicker = Date() // Selected date from the date picker
    @State private var selectedDateComponents = Set<DateComponents>() // Date components (day, month, year, etc.)
    
    // Computed property to format and display the selected date as a string
    private var textDate: String {
        guard let selectedDate else { return "Date not selected" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack {
            calendars // Display only the calendar view
            Spacer() // Pushes content up, adding flexible space below
        }
        .background(Color(red: 242/255, green: 225/255, blue: 246/255)) // Background applied to VStack
        
        .padding(.horizontal) // Adds horizontal padding for better layout
    }
    
    private var dates: String {
        guard !selectedDateComponents.isEmpty else { return "Date not selected"}
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return selectedDateComponents.map { components in
            guard let date = components.date else { return nil}
            return formatter.string(from: date)
        }.compactMap { $0 }
            .joined(separator: "\t")
    }
    
    private var calendars: some View {
        VStack { // Arranges views vertically
            // Calendar at the top
            CalendarView(canSelect: true, selectedDate: $selectedDate)
                .scaledToFit()
            
            Spacer() // Pushes `textDate` to the vertical middle
            
            // Text displayed in the center of the screen
            Text(textDate)
                .font(.title3)
            
            Spacer() // Pushes everything above so `textDate` stays in the middle
        }
        .padding(.horizontal) // Adds padding to the sides for better layout
    }
}

struct CalendarScene_Previews: PreviewProvider {
    static var previews: some View {
        CalendarScene()
    }
}

// A SwiftUI view that wraps a UIKit calendar (UICalendarView)
struct CalendarView: UIViewRepresentable {
    // The calendar system to use (default: Gregorian)
    var calendarIdentifier: Calendar.Identifier = .gregorian
    // Whether date selection is enabled
    var canSelect: Bool = false
    var viewController: UIViewController?
    // A variable to store the selected date
    @Binding var selectedDate: Date?
    
    // Creates and returns a coordinator to manage interactions
    func makeCoordinator() -> CalendarCoordinator {
        CalendarCoordinator(calendarIdentifier: calendarIdentifier, canSelect: canSelect, selectedDate: $selectedDate)
    }
    
    // Creates the underlying UIKit calendar view
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        // Set the calendar system
        view.calendar = Calendar(identifier: calendarIdentifier)
        
        // Enable selection behavior if canSelect is true
        if canSelect {
            view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        }
        
        // Assign the coordinator as the delegate
        view.delegate = context.coordinator
        return view
    }
    
    // Updates the UIKit view when SwiftUI state changes
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        let calendar = Calendar(identifier: calendarIdentifier)
        uiView.calendar = calendar
        context.coordinator.calendarIdentifier = calendarIdentifier
        
        // If selection is disabled, highlight the previously selected date
        if !canSelect, let selectedDate {
            var components = Set<DateComponents>()
            // Store the previously selected date (if any)
            if let previousDate = context.coordinator.pickedDate {
                components.insert(calendar.dateComponents([.month, .day, .year], from: previousDate))
            }
            // Store the newly selected date
            components.insert(calendar.dateComponents([.month, .day, .year], from: selectedDate))
            // Update the picked date in the coordinator
            context.coordinator.pickedDate = selectedDate
            // Refresh the calendar view to apply decorations
            uiView.reloadDecorations(forDateComponents: Array(components), animated: true)
        }
    }
}

// Coordinator to handle user interactions with UICalendarView
final class CalendarCoordinator: NSObject, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
    var calendarIdentifier: Calendar.Identifier
    let canSelect: Bool
    weak var viewController: UIViewController?
    // Variable to update the selected date in SwiftUI
    @Binding var selectedDate: Date?
    var pickedDate: Date? // Stores the most recently selected date
    // Computed property to get the calendar instance
    var calendar: Calendar {
        Calendar(identifier: calendarIdentifier)
    }
    
    // Initialize the coordinator with required properties
    init(calendarIdentifier: Calendar.Identifier, canSelect: Bool, selectedDate: Binding<Date?>) {
        self.calendarIdentifier = calendarIdentifier
        self.canSelect = canSelect
        self._selectedDate = selectedDate
    }

    
    // Handles when a date is selected and updates the selectedDate binding
    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                         didSelectDate dateComponents: DateComponents?) {
        guard
          let dateComponents,
          let date = calendar.date(from: dateComponents)
        else { return }
        self.selectedDate = date // Update the SwiftUI state with the selected date
        viewController?.performSegue(withIdentifier: K.calendarFoodSegue, sender: nil)
      }
}

