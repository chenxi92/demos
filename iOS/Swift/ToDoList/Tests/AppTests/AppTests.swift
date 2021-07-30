@testable import App
import XCTVapor

func convertStringToArray(_ text: String) -> [Dictionary<String, Any>] {
    do {
        let data = text.data(using: .utf8)!
        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String, Any>]
        {
            return jsonArray
        }
    } catch {
        print(error)
    }
    return []
}

final class AppTests: XCTestCase {
        
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }
    
    func testGetAll() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "todos", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let array = convertStringToArray(res.body.string)
            for element in array {
                print("\n\(element)")
            }
        })
        
        print("\nend\n")
    }
    
    func testGetSingle() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        let todoID = "0F0461E1-1997-4935-9621-C6C48B538F22"
        let path = "todos" + "/" + todoID
        try app.test(.GET, path, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let model = try res.content.decode(TodoAPIModel.self)
            print("\n\(model)\n")
        })
    }
    
    func testCreate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        let todoModel = Todo(title: "", order: 2)
        try app.test(.POST, "todos", beforeRequest: { req in
            try req.content.encode(todoModel)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let model = try res.content.decode(TodoAPIModel.self)
            print("\n\(model)\n")
        })
    }
    
    func testDelete() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        let todoID = "056A865C-293D-455A-BCAB-5E8B375F9952"
        try app.test(.DELETE, "todos/\(todoID)", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }
    
    func testUpdate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        let todoID = "991560BC-F74B-430C-B336-24FD020793E4"
        let todoModel = Todo(title: "learn vapor", completed: true, order: 3)
        
        try app.test(.PATCH, "todos/\(todoID)", beforeRequest: { req in
            try req.content.encode(todoModel)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let model = try res.content.decode(TodoAPIModel.self)
            print(model)
        })
    }
}
