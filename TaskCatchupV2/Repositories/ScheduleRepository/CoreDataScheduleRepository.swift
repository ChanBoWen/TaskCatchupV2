//
//  CoreDataScheduleRepository.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation
import CoreData

/// The Core Data implementation of the ScheduleRepository.
/// 
class CoreDataScheduleRepository: ScheduleRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // Methods for Event data
    // Read event data
    func fetchSchedules() throws -> [DailySchedule] {
        let request: NSFetchRequest<DailyScheduleEntity> = DailyScheduleEntity.fetchRequest()
        // Sort chronologically
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DailyScheduleEntity.startTime, ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { toScheduleDomainModel(entity: $0) }
        } catch {
            throw TaskCatchupError.databaseError(reason: "Failed to fetch schedules")
        }
    }
    
    // Schedule a new event
    func updateSchedule(_ schedule: DailySchedule) throws {
        let entity = DailyScheduleEntity(context: context)
        
        // Create the new entities
        entity.id = schedule.id
        entity.title = schedule.title
        entity.startTime = schedule.startTime
        entity.endTime = schedule.endTime
        entity.category = schedule.category.rawValue
        
        // Link it to the student profile
        let profileRequest: NSFetchRequest<StudentProfileEntity> = StudentProfileEntity.fetchRequest()
        if let profileEntity = try? context.fetch(profileRequest).first {
            entity.profile = profileEntity
        }
        
        do {
            try context.save()
        } catch {
            throw TaskCatchupError.databaseError(reason: "Failed to save schedule event")
        }
    }
    
    // Delete an event
    func deleteSchedule(byId id: UUID) throws {
        let request: NSFetchRequest<DailyScheduleEntity> = DailyScheduleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                context.delete(entity)
                try context.save()
            }
        } catch {
            throw TaskCatchupError.databaseError(reason: "Failed to delete schedule event")
        }
    }
    
   
    // Methods for translation from Entity to Struct
    // Convert schedule entities to struct
    private func toScheduleDomainModel(entity: DailyScheduleEntity) -> DailySchedule {
        let category = DailySchedule.ScheduleCategory(rawValue: entity.category ?? "") ?? .academic
        
        // Convert schedule entities to struct
        return DailySchedule(
            id: entity.id ?? UUID(),
            title: entity.title ?? "Unknown Event",
            startTime: entity.startTime ?? Date(),
            endTime: entity.endTime ?? Date().addingTimeInterval(3600),
            category: category
        )
    }
}
