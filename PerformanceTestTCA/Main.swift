//
//  ContentView.swift
//  PerformanceTestTCA
//
//  Created by Jérémy Touzy on 09/02/2021.
//

import CasePaths
import ComposableArchitecture
import SwiftUI

struct Main {
}

extension Main {
  struct State: Equatable {
    var children: [Child.State]
  }
}

extension Main {
  enum Action {
    case child(index: Int, action: Child.Action)
  }
}

extension Main {
  struct Environment {
    let loadItem: (Item) -> Effect<Item, Never>
  }
}

extension Main {
  struct View: SwiftUI.View {
    let store: Store<State, Action>

    var body: some SwiftUI.View {
      WithViewStore(store) { viewStore in
        ScrollView {
          LazyVGrid(columns: [.init(), .init()]) {
            ForEachStore(
              store.scope(
                state: \.children,
                action: Action.child(index:action:)
              )
            ) { childStore in
              Child.View(
                store: childStore
              )
            }
          }
        }
      }
    }
  }
}

extension Main {
  static let localReducer: Reducer<State, Action, Environment> = .init { state, action, environment in
    return .none
  }
  static let reducer: Reducer<State, Action, Environment> = .combine(
    Child.reducer.forEach(
      state: \.children,
      action: /Action.child(index:action:),
      environment: { env in
        .init(
          loadItem: env.loadItem
        )
      }
    ),
    localReducer
  )
}
