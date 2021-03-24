//
//  NewTransactionView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 24..
//

import SwiftUI

struct NewTransactionView: View {
    @ObservedObject private var model = ViewModel()
    
    @GestureState private var gs_isRecordingUserVoice: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("New Transaction")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Colors.Green.typed(.prominentGreen))
            
            descriptionField
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
    }
    
    @ViewBuilder
    private var descriptionField: some View {
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
                    .onChange(of: $gs_isRecordingUserVoice.wrappedValue, perform: { value in
                        if !value {
                            model.shouldRecordUserVoice = false
                        }
                    })
            }
        }
    }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text("")
        }
        .bottomSheet(isShown: .constant(true)) {
            NewTransactionView()
        }
    }
}
