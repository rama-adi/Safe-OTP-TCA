//
//  OtpListView.swift
//  safeotp
//
//  Created by Rama Adi Nugraha on 28/12/24.
//

import SwiftUI
import ComposableArchitecture
import IdentifiedCollections

@Reducer
struct OtpListFeature {
    @Dependency(\.otpClient) var otp
    
    @ObservableState
    struct State: Equatable {
        var otps: IdentifiedArrayOf<OTPItem> = [
            .init(issuer: "Auth test", secret: "I65VU7K5ZQL7WB4E")
        ]
    }
    
    enum Action {
        case viewDidAppear
        case viewDidDisappear
        case otpUpdated(id: UUID, code: String, remaining: Int)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewDidAppear:
                return .merge(
                    state.otps.map { item in
                            .run { send in
                                for await (code, remaining) in self.otp.stream(item.secret) {
                                    await send(.otpUpdated(
                                        id: item.id,
                                        code: code,
                                        remaining: remaining
                                    ), animation: .default)
                                }
                            }.cancellable(id: item.id)
                    }
                )
            case .viewDidDisappear:
                return .merge(
                    state.otps.map { .cancel(id: $0.id) }
                )
            case .otpUpdated(id: let id, code: let code, remaining: let remaining):
                // Update the corresponding item in state.
                
                state.otps[id: id]?.otp = code
                state.otps[id: id]?.remainingTime = remaining
                return .none
            }
        }
        
    }
}


struct OtpListView: View {
    @Bindable var store: StoreOf<OtpListFeature>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.otps) { otp in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(otp.issuer)
                                .font(.headline)
                            Text(otp.otp ?? "Loading...")
                                .fontDesign(.monospaced)
                                .contentTransition(.numericText())
                                .font(.title)
                        }
                        
                        Spacer()
                        
                        spinnerWithDuration(duration: otp.remainingTime ?? 30)
                    }
                }
            }
            .onAppear {
                store.send(.viewDidAppear)
            }
            .onDisappear {
                store.send(.viewDidDisappear)
            }
            .navigationTitle("OTP Keys")
        }
    }
    
    @ViewBuilder
    func spinnerWithDuration(duration: Int) -> some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            // Progress Circle
            Circle()
                .trim(from: 0, to: CGFloat(duration) / 30)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(-90)) // Start from the top
                .animation(.linear(duration: 1), value: duration)
            
            // Remaining Time Text
            Text("\(duration)")
                .animation(.none)
                .font(.subheadline)
        }
        .frame(width: 50, height: 50) // Adjust size as needed
    }
}

#Preview {
    OtpListView(store: Store(initialState: OtpListFeature.State()) {
        OtpListFeature()
    })
}
