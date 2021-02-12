//
//  PerformanceTestTCAApp.swift
//  PerformanceTestTCA
//
//  Created by Jérémy Touzy on 09/02/2021.
//

import ComposableArchitecture
import SwiftUI

@main
struct PerformanceTestTCAApp: App {
  let items: [Item] = (0...2000).map {
    .init(id: "\($0)", name: "unloaded")
  }

  var body: some Scene {
    WindowGroup {
      Main.View(
        store: .init(
          initialState: .init(
            children: .init(items.map {
              .init(item: $0)
            }, id: \.id)
          ),
          reducer: Main.reducer,
          environment: .init(
            loadItem: { item in
              return Effect.future { promise in
                var newItem = item
                newItem.name = "Loaded"
                promise(.success(newItem))
              }
              .delay(
                for: .milliseconds(100),
                scheduler: DispatchQueue.main
              )
              .eraseToEffect()
            }
          )
        )
      )
    }
  }
}
