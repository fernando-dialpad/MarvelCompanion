import Foundation

extension AsyncStream {
    func waitForElements(count: Int = 1) async {
        await withCheckedContinuation { continuation in
            Task {
                var count = count
                for await _ in self {
                    count -= 1
                    if count == 0 {
                        break
                    }
                }
                continuation.resume(returning: ())
            }
        }
    }
}
