//
//  AppView.swift
//  safeotp
//
//  Created by Rama Adi Nugraha on 28/12/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AppFeature {
    
    @CasePathable
    enum TabDestination {
        case otpList
        case secureNotes
        case devices
    }
    
    @ObservableState
    struct State: Equatable {
        var selectedTab: TabDestination = .otpList
        var otpList = OtpListFeature.State()
        var secureNotes = SecureNotesFeature.State()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case otpList(OtpListFeature.Action)
        case secureNotes(SecureNotesFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.otpList, action: \.otpList) {
            OtpListFeature()
        }
        
    }
}

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        TabView(selection: $store.selectedTab) {
            Tab("OTP List", systemImage: "list.bullet", value: .otpList) {
                OtpListView(
                    store: store.scope(state: \.otpList, action: \.otpList)
                )
            }
            
            Tab("Secure Notes", systemImage: "note.text", value: .secureNotes) {
                SecureNotesView(
                    store: store.scope(state: \.secureNotes, action: \.secureNotes)
                )
            }
            
            Tab("Devices", systemImage: "desktopcomputer", value: .devices) {
                EmptyView()
            }
        }
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
