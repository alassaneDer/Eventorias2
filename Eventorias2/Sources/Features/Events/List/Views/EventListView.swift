//
//  EventListView.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
//

import SwiftUI

struct EventListView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var dependencyContainer: DependencyContainer
    @StateObject var viewModel: EventListViewModel
    @Environment(\.self) private var env
    @State private var navigateToRoute: MainRoute?
    @State private var showCalendarView: Bool = false
    
    init(viewModel: EventListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.background(env)
                .ignoresSafeArea(.all)
            
            VStack {
                SearchBar(text: $viewModel.searchable)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.searchable)
                
                HStack {
                    SortButton {
                        viewModel.toggleSort()
                    }
                    Spacer()
                    Button(action: {
                        showCalendarView.toggle()
                    }) {
                        Image(systemName: showCalendarView ? "list.bullet" : "calendar")
                            .foregroundStyle(Color.primary)
                            .padding(8)
                            .background(Color(hex: "#D0021B"))
                            .clipShape(Circle())
                    }
                    .accessibilityLabel(NSLocalizedString(showCalendarView ? "switch_to_list_view" : "switch_to_calendar_view", comment: "Switch to calendar/list view"))
                }
                .padding(.horizontal)
                
                ScrollView {
                    if showCalendarView {
                        CalendarView(events: viewModel.filteredEvents, navigateToRoute: $navigateToRoute)
                            .padding(.horizontal)
                    } else {
                        VStack(spacing: 12) {
                            if viewModel.filteredEvents.isEmpty {
                                Text(NSLocalizedString("Empty_list", comment: "List empty"))
                                    .font(.custom("Inter-Regular", size: 16))
                                    .foregroundStyle(Color.gray)
                            } else {
                                ForEach(viewModel.filteredEvents) { event in
                                    Button {
                                        navigateToRoute = .eventDetail(event.id ?? "")
                                    } label: {
                                        ListRowView(event: event)
                                            .foregroundStyle(Color.primary)
                                            .padding(.leading)
                                            .background(Color.background_field(env))
                                            .frame(height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                            .padding(.horizontal)
                                            .scaleEffect(1.0)
                                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: event.id)
                                    }
                                    .accessibilityLabel(NSLocalizedString("event_detail_button_accessibility", comment: "View event details for \(event.title)"))
                                }
                            }
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                }
            }
            
            VStack {
                Spacer()
                ZStack(alignment: .topTrailing) {
                    CustomTabBar(currentRoute: .main(.eventList)) { route in
                        coordinator.push(route)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.background(env))
                    .ignoresSafeArea(edges: .bottom)
                    
                    IconicButton(backgroundColor: Color(hex: "#D0021B")) {
                        navigateToRoute = .eventCreate
                    }
                    .padding(.trailing, 16)
                    .offset(y: -60)
                    .accessibilityLabel(NSLocalizedString("create_event_button", comment: "Create new event"))
                }
            }
        }
        .environmentObject(viewModel)
        .task(id: navigateToRoute) {
            if let route = navigateToRoute {
                coordinator.push(.main(route))
                navigateToRoute = nil
            }
        }
        .task {
            await viewModel.fetchEvents()
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        EventListView(viewModel: dependencyContainer.makeEventListViewModel())
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}

/// DEPLACER AFTER
import SwiftUI

struct CalendarView: View {
    let events: [Event]
    @Binding var navigateToRoute: MainRoute?
    @State private var selectedDate: Date?
    @State private var currentMonth: Date = Date()
    @Environment(\.self) private var env
    private let calendar = Calendar.current
    private let daysInWeek = 7
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.primary)
                }
                .accessibilityLabel(NSLocalizedString("previous_month", comment: "Previous month"))
                
                Spacer()
                
                Text(monthYearString(from: currentMonth))
                    .font(.custom("Inter-Medium", size: 18))
                
                Spacer()
                
                Button(action: {
                    currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.primary)
                }
                .accessibilityLabel(NSLocalizedString("next_month", comment: "Next month"))
            }
            .padding()
            
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.custom("Inter-Regular", size: 14))
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.gray)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: daysInWeek), spacing: 8) {
                ForEach(daysInMonth(), id: \.self) { date in
                    let eventsForDate = eventsForDay(date: date)
                    VStack {
                        Text(dayString(from: date))
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundStyle(isSameDay(date, Date()) ? Color.red : Color.primary)
                            .frame(width: 40, height: 40)
                            .background(
                                selectedDate != nil && isSameDay(date, selectedDate!) ?
                                Circle().fill(Color(hex: "#D0021B").opacity(0.2)) :
                                    Circle().fill(Color.clear)
                            )
                            .onTapGesture {
                                selectedDate = date
                            }
                            .accessibilityLabel(NSLocalizedString("calendar_day", comment: "Day \(dayString(from: date)) with \(eventsForDate.count) events"))
                        
                        if !eventsForDate.isEmpty {
                            Circle()
                                .fill(Color(hex: "#D0021B"))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
            }
            .padding(.vertical)
            
            if let selectedDate = selectedDate {
                let eventsForDate = eventsForDay(date: selectedDate)
                if !eventsForDate.isEmpty {
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("events_for_date" + " : " + "\(dateString(from: selectedDate))", comment: "Events for \(dateString(from: selectedDate))"))
                            .font(.custom("Inter-Medium", size: 16))
                            .padding(.top)
                        ForEach(eventsForDate) { event in
                            Button {
                                navigateToRoute = .eventDetail(event.id ?? "")
                            } label: {
                                ListRowView(event: event)
                                    .foregroundStyle(Color.primary)
                                    .padding(.leading)
                                    .background(Color.background_field(env))
                                    .frame(height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .scaleEffect(1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: event.id)
                            }
                            .accessibilityLabel(NSLocalizedString("event_detail_button_accessibility", comment: "View event details for \(event.title)"))
                        }
                    }
                } else {
                    Text(NSLocalizedString("no_events_for_date", comment: "No events for \(dateString(from: selectedDate))"))
                        .font(.custom("Inter-Regular", size: 16))
                        .foregroundStyle(Color.gray)
                        .padding(.top)
                }
            }
        }
        .padding()
        .background(Color.background_field(env))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func daysInMonth() -> [Date] {
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
        }
    }
    
    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }
    
    private func eventsForDay(date: Date) -> [Event] {
        events.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(events: [], navigateToRoute: .constant(nil))
    }
}
