//
//  CalendarViewController.swift
//  figology-v2
//
//  Created by emily zhang on 2025-03-24.
//

import SwiftUI
import UIKit
import Foundation

class CalendarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUICalendar()
    }
    
    private func setupSwiftUICalendar() {
        
        let calendarScene = CalendarScene()
        
        let hostingController = UIHostingController(rootView: calendarScene)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

struct CalendarScene: View {
    @State private var selectedDate: Date? = nil
    @State private var navigate = false
    
    var body: some View {
        NavigationStack {
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

struct CalendarScene_Previews: PreviewProvider {
    static var previews: some View {
        CalendarScene()
    }
}

struct CalendarView: UIViewRepresentable {
    var calendarIdentifier: Calendar.Identifier = .gregorian
    var canSelect: Bool = false
    @Binding var selectedDate: Date?
    
    func makeCoordinator() -> CalendarCoordinator {
        CalendarCoordinator(calendarIdentifier: calendarIdentifier, canSelect: canSelect, selectedDate: $selectedDate)
    }
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.calendar = Calendar(identifier: calendarIdentifier)
        
        if canSelect {
            view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        }
        
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        let calendar = Calendar(identifier: calendarIdentifier)
        uiView.calendar = calendar
        context.coordinator.calendarIdentifier = calendarIdentifier
        
        if !canSelect, let selectedDate {
            var components = Set<DateComponents>()
            if let previousDate = context.coordinator.pickedDate {
                components.insert(calendar.dateComponents([.month, .day, .year], from: previousDate))
            }
            components.insert(calendar.dateComponents([.month, .day, .year], from: selectedDate))
            context.coordinator.pickedDate = selectedDate
            uiView.reloadDecorations(forDateComponents: Array(components), animated: true)
        }
    }
}

final class CalendarCoordinator: NSObject, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
    var calendarIdentifier: Calendar.Identifier
    let canSelect: Bool
    
    @Binding var selectedDate: Date?
    var pickedDate: Date?
    var calendar: Calendar {
        Calendar(identifier: calendarIdentifier)
    }
    
    init(calendarIdentifier: Calendar.Identifier, canSelect: Bool, selectedDate: Binding<Date?>) {
        self.calendarIdentifier = calendarIdentifier
        self.canSelect = canSelect
        self._selectedDate = selectedDate
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                       didSelectDate dateComponents: DateComponents?) {
        guard
            let dateComponents,
            let date = calendar.date(from: dateComponents)
        else { return }
        self.selectedDate = date
    }
}
