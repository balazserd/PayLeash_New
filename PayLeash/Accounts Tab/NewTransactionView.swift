//
//  NewTransactionView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 24..
//

import SwiftUI

struct NewTransactionView: View {
    @ObservedObject private var model = ViewModel() //TODO change init to receive value from outside
    
    @GestureState private var gs_isRecordingUserVoice: Bool = false
    
    @AppStorage("didEverUseVoiceToText") private var didEverUseVoiceToText: Bool = false
    @State private var showVoiceToTextOnboarding: Bool = false
    
    @State private var openedField: OpenedField = .none
    
    private let mainPadding: CGFloat = 15.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("New Transaction")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Colors.Green.typed(.prominentGreen))
            
            descriptionFieldRow
            
            balanceAndTimeFieldsRow
        }
        .padding(EdgeInsets(top: 0, leading: mainPadding, bottom: mainPadding, trailing: mainPadding))
    }
    
    //MARK:- High level building blocks
    private var descriptionFieldRow: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Short description")
                .systemFont(size: 12)
                .foregroundColor(Colors.Green.typed(.mediumGreen))
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Colors.Green.typed(.lightGreen))
                        .frame(height: 28)
                    
                    TextField("", text: $model.shortDescription)
                        .systemFont(size: 14, weight: .semibold)
                        .foregroundColor(Colors.Green.typed(.prominentGreen))
                        .frame(height: 28)
                        .padding(.horizontal, 8)
                }
                
                Image(systemName: model.speechRecognitionIsAvailable ? "mic" : "mic.slash")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(model.speechRecognitionIsAvailable ? Colors.Green.typed(.prominentGreen) : .gray)
                    .opacity(model.shouldRecordUserVoice ? 0.4 : 1)
                    .gesture(
                        LongPressGesture()
                            .sequenced(before: LongPressGesture(minimumDuration: .infinity))
                            .updating($gs_isRecordingUserVoice) { value, state, _ in
                                switch value {
                                    case .second(true, nil):
                                        state = true
                                        model.shouldRecordUserVoice = true
                                    default: break
                                }
                            }
                    )
                    .onTapGesture {
                        if !didEverUseVoiceToText {
                            showVoiceToTextOnboarding = true
                        }
                    }
                    .onChange(of: gs_isRecordingUserVoice, perform: { value in
                        if !value {
                            model.shouldRecordUserVoice = false
                        }
                    })
            }
        }
    }
    
    private var balanceAndTimeFieldsRow: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                balanceField
                dateField
            }
            
            if self.openedField == .balance {
                calculator
            }
            
            if self.openedField == .time {
                openedDatePicker
            }
        }
    }
    
    //MARK:- Low level building blocks
    private var balanceField: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Balance change")
                .systemFont(size: 12)
                .foregroundColor(Colors.Green.typed(.mediumGreen))
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Colors.Green.typed(.lightGreen))
                    .frame(height: 28)
                
                Text(NumberFormatter.regularNumberFormatter.string(from: model.amount)!)
                    .systemFont(size: 14, weight: .semibold)
                    .foregroundColor(model.amount < 0.0
                                        ? Colors.Red.typed(.regularRed)
                                        : Colors.Green.typed(.prominentGreen))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
            }
            .onTapGesture {
                self.openedField.toggle(.balance)
            }
        }
    }
    
    private var dateField: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Time")
                .systemFont(size: 12)
                .foregroundColor(Colors.Green.typed(.mediumGreen))
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Colors.Green.typed(.lightGreen))
                    .frame(height: 28)
                
                Text(DateFormatter.regularDateAndTimeFormatter.string(from: model.date))
                    .systemFont(size: 14, weight: .semibold)
                    .foregroundColor(Colors.Green.typed(.prominentGreen))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
            }
            .onTapGesture {
                self.openedField.toggle(.time)
            }
        }
    }
    
    private var openedDatePicker: some View {
        VStack {
            DatePicker("", selection: $model.date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding(9)
                .accentColor(Colors.Green.typed(.prominentGreen))
            
            Button(action: { self.openedField = .none }) {
                Text("Close")
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Colors.Green.typed(.mediumGreen))
                    )
                    .shadow(color: Color.gray.opacity(0.4), radius: 5)
            }
            .padding(9)
        }
        .background(
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Colors.Green.typed(.lightGreen))
                
                Rectangle()
                    .fill(Colors.Green.typed(.lightGreen))
                    .frame(width: (UIScreen.main.bounds.size.width - 2 * mainPadding) * 0.5, height: 18)
                    .offset(x: (UIScreen.main.bounds.size.width - 2 * mainPadding) * 0.5,
                            y: -13)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
                    .frame(width: (UIScreen.main.bounds.size.width - 2 * mainPadding) * 0.5 + 5 /* Half of 10 spacing */,
                           height: 8)
                    .offset(y: -8)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
                    .frame(width: 5 /* Half of 10 spacing */,
                           height: 25)
                    .offset(x: (UIScreen.main.bounds.size.width - 2 * mainPadding) * 0.5,
                            y: -25)
            }
        )
    }
    
    private var calculator: some View {
        CalculatorView(currentResult: $model.amount, doneAction: {
            self.openedField = .none
        })
        .padding(9)
        .background(
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Colors.Green.typed(.lightGreen))
                
                
                Rectangle()
                    .fill(Colors.Green.typed(.lightGreen))
                    .frame(width: (UIScreen.main.bounds.size.width - 2 * mainPadding) * 0.5, height: 18)
                    .offset(y: -13)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
                    .frame(width: (UIScreen.main.bounds.size.width - 2 * mainPadding) * 0.5 + 5 /* Half of 10 spacing */,
                           height: 8)
                    .offset(x: (UIScreen.main.bounds.size.width - 2 * mainPadding) * 0.5 - 5,
                            y: -8)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
                    .frame(width: 8 /* Half of 10 spacing */,
                           height: 25)
                    .offset(x: (UIScreen.main.bounds.size.width - 2 * mainPadding) * 0.5 - 5,
                            y: -25)
            }
        )
        .animation(nil)
    }
}

//MARK:- Extensions
extension NewTransactionView {
    struct CalculatorHeightPreferenceKey : PreferenceKey {
        typealias Value = CGFloat
        
        static var defaultValue: CGFloat = 0.0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

extension NewTransactionView {
    enum OpenedField {
        case balance
        case time
        case category
        case none
        
        mutating func toggle(_ field: OpenedField) {
            if self == field {
                self = .none
            } else {
                self = field
            }
        }
    }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            
            ZStack {
                Text("")
            }
            .bottomSheet(isShown: .constant(true)) {
                NewTransactionView()
            }
        }
        .allowFullScreenOverlays()
    }
}
