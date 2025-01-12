//
//  LessonUseCase.swift
//  EnPractice
//
//  Created by 정영민 on 1/11/25.
//

import Foundation
import Combine

protocol LessonUseCase {
    func levelList() -> AnyPublisher<[LevelModel], Never>
    func lessonList(level: Int, unit: Int) -> AnyPublisher<[LessonModel], Never>
}

class LessonUseCaseImp: LessonUseCase {
    init() {
    }
    
    func levelList() -> AnyPublisher<[LevelModel], Never> {
        let level1 = LevelModel(id: UUID().uuidString, levelNo: 1, title: "Level1", desc: "Level1 Desc")
        return Just([level1]).eraseToAnyPublisher()
    }
    
    func lessonList(level: Int, unit: Int) -> AnyPublisher<[LessonModel], Never> {
        let lesson = LessonModel(levelNo: level, unitNo: unit, id: UUID(), lessonNo: 1, title: "Title", desc: "Desc")
        return Just([lesson]).eraseToAnyPublisher()
    }
}
