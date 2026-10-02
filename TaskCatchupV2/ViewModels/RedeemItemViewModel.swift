//
//  RedeemItemViewModel.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation
import Combine
import CoreData

/// ViewModel responsible for managing the state and business logic for the Redeem screen.
///
class RedeemItemViewModel: ObservableObject {
    @Published var profile: StudentProfile?
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    
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
    func purchaseRestVoucher() {
        guard let currentProfile = profile else { return }
        
        do {
            // If BP is not enough, throws error
            let updatedProfile = try purchaseUseCase.execute(voucher: .guiltFreeRest, cost: 50, profile: currentProfile)
            
            // Save updated profile to database
            try repository.updateProfile(updatedProfile)
            self.showSuccess = true
            
            // Reload from the database
            loadData()
        } catch let error as TaskCatchupError {
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            self.errorMessage = "An unexpected error occurred."
            self.showError = true
        }
    }
}
