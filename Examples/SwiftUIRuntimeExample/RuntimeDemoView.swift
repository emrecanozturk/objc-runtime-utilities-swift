import ObjCRuntimeUtilities
import ObjCRuntimeUtilitiesUI
import SwiftUI
import UIKit

struct RuntimeDemoView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("UIKit bridge") {
                    UIKitViewAdapter {
                        UILabel()
                    } updateView: { label in
                        label.text = "Backed by UIKit"
                        label.textAlignment = .center
                    } onDealloc: {
                        print("UILabel deallocated")
                    }
                    .frame(height: 44)
                }

                Section("Runtime inspection") {
                    NavigationLink("Inspect UIViewController") {
                        RuntimeInspectorPanel(UIViewController.self)
                    }
                }
            }
            .navigationTitle("Runtime Demo")
        }
    }
}
