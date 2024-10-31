extension Array {

    func at(_ index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

}
