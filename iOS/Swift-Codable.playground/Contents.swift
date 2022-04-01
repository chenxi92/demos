import Foundation

// Code for: https://www.swiftbysundell.com/discover/codable/

struct User: Codable {
    var name: String
    var age: Int
}

func test1() {
    do {
        print("\n\n--- test1")
        let user = User(name: "John", age: 31)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(user)
        print("encoded string:", String(data: data, encoding: .utf8)!)
        
        let decoder = JSONDecoder()
        let secondUser = try decoder.decode(User.self, from: data)
        print("decode object:", String(describing: secondUser))
    } catch {
        print("Whoops, an error occured: \(error)")
    }
}

test1()

extension User {
    struct CodingData: Codable {
        struct Container: Codable {
            var fullName: String
            var userAge: Int
        }
        
        var userData: Container
    }
}

extension User.CodingData {
    var user: User {
        return User(name: userData.fullName, age: userData.userAge)
    }
}


func test2() {
    print("\n\n--- test2")
    
    let jsonString = """
{
    "user_data": {
        "full_name": "John Sundell",
        "user_age": 31
    }
}
"""
    
    do {
        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let codingData = try decoder.decode(User.CodingData.self, from: data)
        let user = codingData.user
        print("decode object (convert from snake case):", String(describing: user))
    } catch {
        print(error)
    }
}

test2()


protocol ItemVariant: Decodable {
    var title: String { get }
    var imageURL: URL { get }
}

struct Video: ItemVariant {
    var title: String
    var imageURL: URL
    var url: URL
    var duration: String
    var resolution: String
}

struct Recipe: ItemVariant {
    var title: String
    var imageURL: URL
    var text: String
    var ingredients: [String]
}

@dynamicMemberLookup
enum Item {
    case video(Video)
    case recipe(Recipe)
}

extension Item {
    subscript<T>(dynamicMember keyPath: KeyPath<ItemVariant, T>) -> T {
        switch self {
        case .video(let video):
            return video[keyPath: keyPath]
        case .recipe(let recipe):
            return recipe[keyPath: keyPath]
        }
    }
}

extension Item: Decodable {
    struct InvalidTypeError: Error {
        var type: String
    }
    
    private enum CodingKeys: CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "video":
            self = .video(try Video(from: decoder))
        case "recipe":
            self = .recipe(try Recipe(from: decoder))
        default:
            throw InvalidTypeError(type: type)
        }
    }
}

struct ItemCollection: Decodable {
    var items: [Item]
}

extension ItemCollection {
//    func allTitles() -> [String] {
//        items.map { item in
//            switch item {
//            case .video(let video):
//                return video.title
//            case .recipe(let recipe):
//                return recipe.title
//            }
//        }
//    }
    
    func allTitles() -> [String] {
        items.map(\.title)
    }
}

func test3() {
    print("\n\n--- test3")
    
    let dataString = """
{
    "items": [
        {
            "type": "video",
            "title": "Making perfect toast",
            "imageURL": "https://image-cdn.com/toast.png",
            "url": "https://videoservice.com/toast.mp4",
            "duration": "00:12:09",
            "resolution": "720p"
        },
        {
            "type": "recipe",
            "title": "Tasty burritos",
            "imageURL": "https://image-cdn.com/burritos.png",
            "text": "Here's how to make the best burritos...",
            "ingredients": [
                "Tortillas",
                "Salsa"
            ]
        }
    ]
}
"""
    if let data = dataString.data(using: .utf8) {
        do {
            let itemCollection = try JSONDecoder().decode(ItemCollection.self, from: data)
            print("decode enum: ", String(describing: itemCollection))
            print("all titles: ", itemCollection.allTitles())
        } catch {
            print(error)
        }
    }
}

test3()


enum Video1: Codable {
    case youTube(id: String)
    case vimeo(id: String)
    case hosted(url: URL)
}

struct Video1Collection: Codable {
    var name: String
    var videos: [Video1]
}

func test4() {
    print("\n\n--- test4 (enum codable with associate object)")
    let collection = Video1Collection(name: "Conference talks", videos: [
        .youTube(id: "01afsd434"),
        .vimeo(id: "234550")
    ])
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(collection)
        print("enum encode:", String(data: data, encoding: .utf8)!)
    }catch {
        print(error)
    }
}

test4()


struct Article: Codable {
    var url: URL
    var title: String
    var body: String
    
    enum CodingKeys: String, CodingKey {
        case url = "source_link"
        case title = "content_name"
        case body
    }
}

func test5() {
    print("\n\n--- test5")
    let dataString = """
{
    "source_link": "http://www.google.com",
    "content_name": "Title",
    "body": "this is a test body"
}
"""
    do {
        let data = dataString.data(using: .utf8)!
        print(String(data: data, encoding: .utf8)!)
       
        let decoder = JSONDecoder()
        let article = try decoder.decode(Article.self, from: data)
        print("decode object:", String(describing: article))
    } catch {
        print(error)
    }
}

test5()


@propertyWrapper
struct LossyCodableList<Element> {
    var elements: [Element]
    
    var wrappedValue: [Element] {
        get { elements }
        set { elements = newValue }
    }
}


extension LossyCodableList: Decodable where Element: Decodable {
    private struct ElementWrapper: Decodable {
        var element: Element?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            element = try? container.decode(Element.self)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let wrapper = try container.decode([ElementWrapper].self)
        elements = wrapper.compactMap(\.element)
    }
}

extension LossyCodableList: Encodable where Element: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in elements {
            try? container.encode(element)
        }
    }
}

extension User {
    struct Collection: Codable {
        @LossyCodableList var items: [User]
    }
}

func test6() {
    print("\n\n--- test6")
    let json = """
{
    "items": [
        {
            "name": "peak",
            "age": 12
        },
        {
            "name": "chenxi",
            "age": null
        }
    ]
}
"""
    let data = Data(json.utf8)
    do {
        let obj = try JSONDecoder().decode(User.Collection.self, from: data)
        print("ignore nil object:", String(describing: obj))
        print(obj.items)
    } catch {
        print(error)
    }
}

test6()
