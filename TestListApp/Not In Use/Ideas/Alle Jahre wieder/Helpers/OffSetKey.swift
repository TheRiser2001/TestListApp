//
//  OffSetKe.swift
//  TestListApp
//
//  Created by Michael Ilic on 22.07.24.
//

import Foundation
import SwiftUI

/// OffSetKey ist eine Art "Schlüssel", den SwiftUI verwendet, um einen bestimmten Wert (hier eine Zahl vom Typ CGFloat) zwischen verschiedenen Ansichten zu speichern und zu teilen. Der Standardwert dieses Schlüssels ist 0. Wenn ein neuer Wert verfügbar ist, wird der alte Wert durch den neuen Wert ersetzt. Dieser Mechanismus wird genutzt, um die Position (Offset) einer Ansicht zu überwachen und diesen Wert anderen Teilen der Benutzeroberfläche zur Verfügung zu stellen.

struct OffSetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
