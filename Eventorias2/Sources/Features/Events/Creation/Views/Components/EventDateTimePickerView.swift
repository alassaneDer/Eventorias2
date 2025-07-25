//
//  EventDateTimePickerView.swift
//  Eventorias2
//
//  Created by Alassane Der on 19/07/2025.
//

import SwiftUI

struct EventDateTimePickerView: View {
    let bindings: EventDateBindings
    @Environment(\.self) private var env

    var body: some View {
        
        HStack {
            /// Date
            VStack(alignment: .leading) {
                Text("Date")
                    .font(.custom("Inter-Regular", size: 14))
                    .foregroundStyle(Color.secondary)
                
                DatePicker("", selection: bindings.dateOnly, in: Date()..., displayedComponents: [.date])
                    .labelsHidden()
                    .datePickerStyle(.compact)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 4.0).fill(Color.background_field(env))
            )

            /// Heure
            VStack(alignment: .leading) {
                Text("Time")
                    .font(.custom("Inter-Regular", size: 14))
                    .foregroundStyle(Color.secondary)
                
                DatePicker("", selection: bindings.timeOnly, in: Date()..., displayedComponents: [.hourAndMinute])
                    .labelsHidden()
                    .datePickerStyle(.compact)
                
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 4.0).fill(Color.background_field(env))
            )
        }
    }
}

@MainActor
struct EventDateBindings {
    let viewModel: EventCreateViewModel
    
    var dateOnly: Binding<Date> {
        Binding(
            get: { viewModel.date },
            set: { newDate in
                viewModel.updateDate(dayPart: newDate)
            })
    }
    
    var timeOnly: Binding<Date> {
        Binding(
            get: { viewModel.date },
            set: { newDate in
                viewModel.updateDate(timePart: newDate)
            })
    }
}


#Preview {
    EventDateTimePickerView(bindings: EventDateBindings(viewModel: EventCreateViewModel()))
}
