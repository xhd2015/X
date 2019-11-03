//
//  CoreDataManager.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//
import Foundation
import CoreData

class CoreDataManager {
    static let share = CoreDataManager()
    private init(){
        
    }
    
    private lazy var persistContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name:"CoreDataModel")
        container.loadPersistentStores(completionHandler: { _, error in
            _ = error.map { fatalError("Unresolved error \($0)") }
        })
        return container
    }()
    var mainContext: NSManagedObjectContext {
        return persistContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistContainer.newBackgroundContext()
    }
    /* load all content that ever persisted
     */
    func loadContent() -> [ContentEntity] {
        let fetchRequest: NSFetchRequest<ContentEntity> = ContentEntity.fetchRequest()
        do {
            let results = try mainContext.fetch(fetchRequest)
            return results
        }
        catch {
            debugPrint(error)
        }
        return [ContentEntity]()
    }
    /* save a new row, you can custom it by setting to existing row
     */
    func saveContent(content: String) throws {
        let context = self.backgroundContext()
        context.perform{ () -> Void in
            let entity = ContentEntity.entity()
            let pill = ContentEntity(entity: entity, insertInto: context)
            
            pill.content=content
            
            do {
                try  context.save()
                
            }catch{
                fatalError("Cannot save")
            }
        }
    }
}
