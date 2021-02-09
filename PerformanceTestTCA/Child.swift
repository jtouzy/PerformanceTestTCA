//
//  Child.swift
//  PerformanceTestTCA
//
//  Created by Jérémy Touzy on 09/02/2021.
//

import ComposableArchitecture
import SwiftUI

struct Child {
}

extension Child {
  struct State: Equatable, Identifiable {
    var id: String { item.id }
    var item: Item
  }
}

extension Child {
  enum Action {
    case loadItemContent
    case itemLoaded(Item)
  }
}

extension Child {
  struct Environment {
    let loadItem: (Item) -> Effect<Item, Never>
  }
}

extension Child {
  struct View: SwiftUI.View {
    let store: Store<State, Action>

    var body: some SwiftUI.View {
      WithViewStore(store) { viewStore in
        Text("\(viewStore.item.id) - \(viewStore.item.name)")
          .onAppear {
            viewStore.send(.loadItemContent)
          }
      }
    }
  }
}

extension Child {
  static let reducer: Reducer<State, Action, Environment> = .init { state, action, environment in
    switch action {
    case .loadItemContent:
      return environment
        .loadItem(state.item)
        .map(Action.itemLoaded)
    case .itemLoaded(let item):
      state.item = item
    }
    return .none
  }
}
