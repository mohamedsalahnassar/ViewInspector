import SwiftUI

public extension ViewType {
    
    struct Button: KnownViewType {
        public static var typePrefix: String = "Button"
    }
}

public extension Button {
    
    func inspect() throws -> InspectableView<ViewType.Button> {
        return try InspectableView<ViewType.Button>(self)
    }
}

// MARK: - SingleViewContent

extension ViewType.Button: SingleViewContent {
    
    public static func content(view: Any) throws -> Any {
        return try Inspector.attribute(label: "_label", value: view)
    }
}

// MARK: - SingleViewContent

public extension InspectableView where View: SingleViewContent {
    
    func button() throws -> InspectableView<ViewType.Button> {
        let content = try View.content(view: view)
        return try InspectableView<ViewType.Button>(content)
    }
}

// MARK: - MultipleViewContent

public extension InspectableView where View: MultipleViewContent {
    
    func button(_ index: Int) throws -> InspectableView<ViewType.Button> {
        let content = try contentView(at: index)
        return try InspectableView<ViewType.Button>(content)
    }
}

// MARK: - Custom Attributes

public extension InspectableView where View == ViewType.Button {
    
    func tap() throws {
        let action = try Inspector.attribute(label: "action", value: view)
        typealias Callback = () -> Void
        guard let callback = action as? Callback
            else { throw InspectionError.typeMismatch(
                factual: Inspector.typeName(value: action),
                expected: Inspector.typeName(type: Callback.self)) }
        callback()
    }
}