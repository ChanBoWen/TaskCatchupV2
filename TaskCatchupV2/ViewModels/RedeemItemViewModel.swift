//
//  RedeemItemViewModel.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation
import Combine
import CoreData
import SwiftUI
import WidgetKit

/// ViewModel responsible for managing the state and business logic for the Redeem screen.
///
class RedeemItemViewModel: ObservableObject {
    @Published var profile: StudentProfile?
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    @Published var successMessage: String = ""
    
    // The inventory of the shop
    @Published var storeItems: [StoreItem] = [
        StoreItem(type: .doubleXP, title: "Double XP", description: "Earn 2x XP for 24 hours.", cost: 100, icon: "arrow.up.circle.fill", color: .purple),
        StoreItem(type: .doubleBP, title: "Double BP", description: "Earn 2x BP for 24 hours.", cost: 100, icon: "bitcoinsign.circle.fill", color: .yellow),
        StoreItem(type: .restDay, title: "Rest Day Voucher", description: "Protects your streak if you rest.", cost: 50, icon: "cup.and.saucer.fill", color: .blue),
        StoreItem(type: .freeDelete, title: "Free Delete", description: "Waives the 20 BP deletion penalty.", cost: 30, icon: "trash.slash.fill", color: .red)
        ]
    
    private let repository: GoalRepository
    private let purchaseUseCase = PurchaseVoucherUseCase()
    
    // Inject the Core Data repository
    init(repository: GoalRepository = CoreDataGoalRepository(context: PersistenceController.shared.container.viewContext)) {
        self.repository = repository
        loadData()
    }
    
    // Load the profile and vouchers from Core Data
    func loadData() {
        do {
            self.profile = try repository.fetchProfile()
        } catch {
            let fallback = TaskCatchupError.databaseError(reason: "Failed to load profile")
            self.errorMessage = fallback.localizedDescription
            self.showError = true
        }
    }
    
    // Purchases a voucher
    func purchaseVoucher(type: StudentProfile.VoucherType, cost: Int, itemName: String) {
        guard let currentProfile = profile else { return }
        
        do {
            // If BP is not enough, throws error
            let updatedProfile = try purchaseUseCase.execute(voucher: type, cost: cost, profile: currentProfile)
            
            // Save the newest purchased voucher to the database
            try repository.updateProfile(updatedProfile)
            
            // Show success message
            self.successMessage = "You successfully redeemed: \(itemName)!"
            self.showSuccess = true
            
            // Reload from the database
            loadData()
            
            // Reload the widget
            WidgetCenter.shared.reloadAllTimelines()
        } catch let error as TaskCatchupError {
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            self.errorMessage = "An unexpected error occurred."
            self.showError = true
        }
    }
}
