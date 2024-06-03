//
//  Test.swift
//  UISample
//
//  Created by 정영민 on 2024/06/03.
//

import Foundation

protocol Test {
    func doTest()
}

struct TestA: Test {
    func doTest() {
        
    }
}

struct TestB: Test {
    func doTest() {
        
    }
}

struct Sample {
    func doSomeTest<T>(test: T) where T : Test {
        test.doTest()
    }
    
    func doSomeOtherTest(test: Test) {
        test.doTest()
    }
    
    func example() {
        let testA = TestA()
        doSomeTest(test: testA)
    }
}
