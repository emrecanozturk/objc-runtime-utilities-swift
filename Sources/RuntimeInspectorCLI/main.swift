import Foundation
import ObjCRuntimeUtilities

let arguments = CommandLine.arguments.dropFirst()
let prefix = arguments.first

let names = RuntimeInspector.classNames(prefix: prefix)
if names.isEmpty {
    if let prefix {
        print("No Objective-C runtime classes found with prefix '\(prefix)'.")
    } else {
        print("No Objective-C runtime classes found.")
    }
    exit(0)
}

for name in names.prefix(100) {
    print(name)
}

if names.count > 100 {
    print("... \(names.count - 100) more")
}
