//
//  LessonDBRepository.swift
//  UISample
//
//  Created by 정영민 on 7/20/24.
//

import CoreData
import Combine

protocol LessonDBRepository {
    func countries(lessonNoList: [Int]) -> AnyPublisher<LazyList<Lesson>, Error>
}

struct RealLessonDBRepository: LessonDBRepository {
    
    let persistentStore: PersistentStore
    
    func countries(lessonNoList: [Int]) -> AnyPublisher<LazyList<Lesson>, Error> {
        let fetchRequest = LessonMO.lessons(lessonNoList: lessonNoList)
        return persistentStore
            .fetch(fetchRequest) {
                Lesson(managedObject: $0)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Fetch Requests

extension LessonMO {
    static func lessons(lessonNoList: [Int]) -> NSFetchRequest<LessonMO> {
        let request = newFetchRequest()
        request.predicate = NSPredicate(format: "lessonNo IN %@", lessonNoList)
        request.fetchLimit = lessonNoList.count
        return request
    }
}
