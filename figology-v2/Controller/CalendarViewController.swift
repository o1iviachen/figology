//
//  CalendarViewController.swift
//  figology-v2
//
//  Created by emily zhang on 2025-03-24.
//

import SwiftUI
import UIKit
import Foundation

// Source: https://www.youtube.com/watch?v=B_VFHeg2LH4&t=7s
// Generates a Calendar View for users to easily access and view their past food logs
class CalendarViewController: UIViewController {

    // Sets up the SwiftUI Calendar from the UIKit
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUICalendar()
    }

    // Creates the Calendar View for the user's interface
    private func setupSwiftUICalendar() {
        
        let calendarScene = CalendarScene()

        // Adds the Calendar View as a child view controller to link it to the StoryBoard
        let hostingController = UIHostingController(rootView: calendarScene)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

// SwiftUI that formats the calendar and allows the food log to be displayed based on the food selection
struct CalendarScene: View {
    @State private var selectedDate: Date? = nil
    @State private var navigate = false

    var body: some View {
        // Allows the CalendarUI to be navigated
        NavigationStack {
            // Custom functionality that allows and records the user's date selection
            VStack {
                CalendarView(canSelect: true, selectedDate: $selectedDate)
                    .scaledToFit()
                    .onChange(of: selectedDate) { newDate in
                        if newDate != nil {
                            navigate = true
                        }
                    }
                Spacer()
                Spacer()
                // Triggers the FoodView for the user's selected date to be displayed
                NavigationLink(
                    destination: Group {
                        if let date = selectedDate {
                            FoodView(date: date)
                        }
                    },
                    isActive: $navigate,
                    label: { EmptyView() }
                )
            }
            .padding(.horizontal)
            .background(Color(red: 242/255, green: 225/255, blue: 246/255))
        }
    }
}

// Allows previews of the CalendarUI during development
struct CalendarScene_Previews: PreviewProvider {
    static var previews: some View {
        CalendarScene()
    }
}

// A SwiftUI view that wraps a UIKit calendar (UICalendarView)
struct CalendarView: UIViewRepresentable {
  // The calendar system to use
  var calendarIdentifier: Calendar.Identifier = .gregorian
  // Whether date selection is enabled
  var canSelect: Bool = false
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
  }
}
