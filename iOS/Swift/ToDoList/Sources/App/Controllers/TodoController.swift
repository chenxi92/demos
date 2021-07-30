import Fluent
import Vapor

struct CreateRequestBody: Content {
    let title: String
    let order: Int?

    func makeTodo() -> Todo {
        return Todo(title: title, completed: false, order: order)
    }
}

extension CreateRequestBody: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty && .count(1...))
        validations.add("order", as: Int.self, is: .range(0...), required: false)
    }
}

struct UpdateRequestBody: Content {
    let title: String?
    let completed: Bool?
    let order: Int?
}

struct TodoController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: index)
        todos.get(":todoID", use: getSingle)
        todos.post(use: create)
        todos.group(":todoID") { todo in
            todo.delete(use: delete)
        }
        todos.patch(":todoID", use: update)
    }

    func index(req: Request) throws -> EventLoopFuture<[TodoAPIModel]> {
        return Todo.query(on: req.db)
            .all()
            .flatMapThrowing { todos in
                // convert `todos` to `[TodoAPIModel]
                try todos.map { try TodoAPIModel($0) }
            }
    }
    
    func getSingle(req: Request) throws -> EventLoopFuture<TodoAPIModel> {
        guard let todoIDString = req.parameters.get("todoID"),
              let todoID = UUID(todoIDString) else {
            throw Abort(.badRequest, reason: "Invalid parameter `todoID`")
        }
        return Todo.find(todoID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { try TodoAPIModel($0) }
    }
    
    
    func create(req: Request) throws -> EventLoopFuture<TodoAPIModel> {
        try CreateRequestBody.validate(content: req)
        let requestBody = try req.content.decode(CreateRequestBody.self)
        let todo = requestBody.makeTodo()
        return todo.save(on: req.db)
            .flatMapThrowing { try TodoAPIModel(todo) }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func update(req: Request) throws -> EventLoopFuture<TodoAPIModel> {
        guard let todoIDString = req.parameters.get("todoID"),
              let todoID = UUID(todoIDString) else {
            throw Abort(.badRequest, reason: "Invalid parameter `todoID`")
        }
        
        let requestBody = try req.content.decode(UpdateRequestBody.self)
        
        return Todo.find(todoID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { todo in
                if let title = requestBody.title {
                    todo.title = title
                }
                if let completed = requestBody.completed {
                    todo.completed = completed
                }
                if let order = requestBody.order {
                    todo.order = order
                }
                return todo.save(on: req.db).transform(to: todo)
            }
            .flatMapThrowing { try TodoAPIModel($0) }
    }
}
