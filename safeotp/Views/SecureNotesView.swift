//
//  SecureNotesView.swift
//  safeotp
//
//  Created by Rama Adi Nugraha on 28/12/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SecureNotesFeature {
    
    @ObservableState
    struct State: Equatable {
        
    }
    
}


struct SecureNotesView: View {
    @Bindable var store: StoreOf<SecureNotesFeature>
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    SecureNotesView(
        store: Store(initialState: SecureNotesFeature.State()) {
            SecureNotesFeature()
        }
    )
}
