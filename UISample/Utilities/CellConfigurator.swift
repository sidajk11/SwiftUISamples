//
//  CellConfigurator.swift
//  UISample
//
//  Created by 정영민 on 2024/06/13.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    @IBOutlet weak var ageLabel: UILabel!
}

struct CellConfigurator<Model> {
    let titleKeyPath: KeyPath<Model, String>
    let subtitleKeyPath: KeyPath<Model, String>
    let ageKeyPath: KeyPath<Model, Int>

    func configure(_ cell: TestTableViewCell, for model: Model) {
        cell.textLabel?.text = model[keyPath: titleKeyPath]
        cell.detailTextLabel?.text = model[keyPath: subtitleKeyPath]
        cell.ageLabel.text = String(model[keyPath: ageKeyPath])
    }
}

class CellViewModel {
    var title: String = ""
    var authorName: String = ""
    var age: Int = 0
}

struct PersonModel {
    let name: String
    let artistName: String
    let age: Int
}


class TestConfigurator: NSObject {
    let vmCellConfigurator = CellConfigurator<CellViewModel>(
        titleKeyPath: \.title,
        subtitleKeyPath: \.authorName,
        ageKeyPath: \.age
    )
    
    let personCellConfigurator = CellConfigurator<PersonModel>(
        titleKeyPath: \.name,
        subtitleKeyPath: \.artistName,
        ageKeyPath: \.age
    )
    
    func doTest() {
        // 하나의 TestTableViewCell 클래스에 다른 타입의 데이터(CellViewModel, PersonModel)들을 사용 할수 있음
        let cell = TestTableViewCell()
        let vm = CellViewModel()
        vmCellConfigurator.configure(cell, for: vm)
        
        let person = PersonModel(name: "", artistName: "", age: 0)
        personCellConfigurator.configure(cell, for: person)
    }
}
