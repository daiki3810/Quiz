import Foundation
import SwiftData

class SwiftDataManager<T: PersistentModel> {

    var container: ModelContainer?
    var context: ModelContext?

    init() {
        do {
            container = try ModelContainer(for: T.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }
    func saveItem(data: T) {
            if let context {
                context.insert(data)
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        }
    func fetchAll() -> [T] {
            if let context {
                do {
                    let descriptor = FetchDescriptor<T>()
                    return try context.fetch(descriptor)
                } catch {
                    print(error)
                    return []
                }
            } else {
                return []
            }
        }
}

