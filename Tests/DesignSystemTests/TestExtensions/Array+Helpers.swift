public func allCombinationsOf<T>(arrays: [[T]], partial: [T] = []) -> [[T]] {
    if arrays.isEmpty {
        return [partial]
    } else {
        var arrays = arrays

        let first = arrays.removeFirst()

        var result = [[T]]()

        for item in first {
            result += allCombinationsOf(arrays: arrays, partial: partial + [item])
        }

        return result
    }
}
