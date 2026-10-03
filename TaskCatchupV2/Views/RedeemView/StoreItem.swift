//
//  StoreItem.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 3/10/2026.
//

import SwiftUI

/// A Presentation Model used to configure the redeem shop UI.
///
struct StoreItem: Identifiable {
    let id = UUID()
    let type: StudentProfile.VoucherType
    let title: String
    let description: String
    let cost: Int
    let icon: String
    let color: Color
}
