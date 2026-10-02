//
//  CoreDataGoalRepository.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation
import CoreData

/// The Core Data implementation of the GoalRepository.
/// 
class CoreDataGoalRepository: GoalRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    // Methods for Profile data
    // Read profile data
    func fetchProfile() throws -> StudentProfile {
        let request: NSFetchRequest<StudentProfileEntity> = StudentProfileEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                return toProfileDomainModel(entity: entity)
            } else {
                // Use this dummy data if no profile exists
                let newProfile = StudentProfile(name: "Alex", balancePoints: 40, lifetimeXP: 80, currentLevel: 1, dailyStreak: 2)
                try updateProfile(newProfile)
                return newProfile
            }
        } catch {
            throw TaskCatchupError.databaseError(reason: "Failed to fetch profile")
        }
    }
    
    // Update profile data
    func updateProfile(_ profile: StudentProfile) throws {
        let request: NSFetchRequest<StudentProfileEntity> = StudentProfileEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            let entity = entities.first ?? StudentProfileEntity(context: context)
            
            // Create the new entities
            entity.id = profile.id
            entity.name = profile.name
            entity.balancePoints = Int16(profile.balancePoints)
            entity.lifetimeXP = Int16(profile.lifetimeXP)
            entity.currentLevel = Int16(profile.currentLevel)
            entity.dailyStreak = Int16(profile.dailyStreak)
            
            // Encode the activeVouchers enums into Data
            if let encodedActiveVouchers = try? JSONEncoder().encode(profile.activeVouchers) {
                entity.activeVouchersData = encodedActiveVouchers
            }
            
            try context.save()
        } catch {
            throw TaskCatchupError.databaseError(reason: "Failed to save profile")
        }
    }
    
    
    // Methods for Goal data
    // Read goal data
    func fetchGoals() throws -> [DailyGoal] {
        let request: NSFetchRequest<DailyGoalEntity> = DailyGoalEntity.fetchRequest()
        // Sort chronologically
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DailyGoalEntity.createdAt, ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { toGoalDomainModel(entity: $0) }
        } catch {
            throw TaskCatchupError.databaseError(reason: "Failed to fetch goals")
        }
    }
    
    // Fetches the goals that are not completed yet
    func fetchIncompleteGoals() throws -> [DailyGoal] {
        let request: NSFetchRequest<DailyGoalEntity> = DailyGoalEntity.fetchRequest()
        
        // Only fetch entities where 'isCompleted' is false
        request.predicate = NSPredicate(format: "isCompleted == %d", false)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DailyGoalEntity.createdAt, ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { toGoalDomainModel(entity: $0) }
        } catch {
            throw TaskCatchupError.databaseError(reason: "Failed to fetch incomplete goals")
        }
    }
    
    // Create a new goal
    func addGoal(_ goal: DailyGoal) throws {
        let entity = DailyGoalEntity(context: context)
        
        // Create the new entities
        entity.id = goal.id
        entity.title = goal.title
        entity.category = goal.category.rawValue
        entity.isCompleted = goal.isCompleted
        entity.isRecurring = goal.isRecurring
        entity.rewardPoints = Int16(goal.rewardPoints)
        entity.createdAt = goal.createdAt
        
        // Link it to the profile
        let profileRequest: NSFetchRequest<StudentProfileEntity> = StudentProfileEntity.fetchRequest()
        if let profileEntity = try? context.fetch(profileRequest).first {
            entity.profile = profileEntity
        }
        
        try context.save()
    }
    
    // Update goal data
    func updateGoal(_ goal: DailyGoal) throws {
        let request: NSFetchRequest<DailyGoalEntity> = DailyGoalEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", goal.id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                entity.title = goal.title
                entity.isCompleted = goal.isCompleted
                entity.rewardPoints = Int16(goal.rewardPoints)
                try context.save()
            }
        } catch {
            throw TaskCatchupError.databaseError(reason: "Failed to update goal")
        }
    }
    
    // Delete a goal
    func deleteGoal(byId id: UUID) throws {
        let request: NSFetchRequest<DailyGoalEntity> = DailyGoalEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                context.delete(entity)
                try context.save()
            }
        } catch {
            throw TaskCatchupError.databaseError(reason: "Failed to delete goal")
        }
    }
    
    
    // Methods for translation from Entity to Struct
    // Convert goal entities to struct
    private func toGoalDomainModel(entity: DailyGoalEntity) -> DailyGoal {
        let category = DailyGoal.GoalCategory(rawValue: entity.category ?? "") ?? .academic
        
        return DailyGoal(
            id: entity.id ?? UUID(),
            title: entity.title ?? "Unknown",
            category: category,
            isRecurring: entity.isRecurring,
            isCompleted: entity.isCompleted,
            rewardPoints: Int(entity.rewardPoints),
            createdAt: entity.createdAt ?? Date()
        )
    }
    
    private func toProfileDomainModel(entity: StudentProfileEntity) -> StudentProfile {
        var vouchers: [StudentProfile.VoucherType] = []
        
        // Decode the activeVouchers enums
        if let data = entity.activeVouchersData,
           let decoded = try? JSONDecoder().decode([StudentProfile.VoucherType].self, from: data) {
            vouchers = decoded
        }
        
        // Convert profile entities to struct
        return StudentProfile(
            id: entity.id ?? UUID(),
            name: entity.name ?? "Alex",
            balancePoints: Int(entity.balancePoints),
            lifetimeXP: Int(entity.lifetimeXP),
            currentLevel: Int(entity.currentLevel),
            dailyStreak: Int(entity.dailyStreak),
            activeVouchers: vouchers
        )
    }
}
