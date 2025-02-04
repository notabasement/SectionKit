import UIKit

/// An enumeration of all SectionKit errors.
public enum Error: Swift.Error {
    /// The function hasn't been implemented.
    case notImplemented(function: StaticString = #function)

    /**
     The list of sections contains two or more sections with the same id.

     This is not supported and would result in undefined behaviour.
     */
    case duplicateSectionIds([AnyHashable])

    /// There is no datasource for section with given index.
    case missingDataSource(section: Int)

    /// The given supplementary view kind is not supported.
    case unsupportedSupplementaryViewKind(elementKind: String)

    /// The given `IndexPath` is not valid (does not contain exactly 2 values).
    case invalidIndexPath(IndexPath)

    /// Move is not supported inside the same section.
    case moveIsNotInTheSameSection(sourceSection: Int, destinationSection: Int)

    /// The `adapter` is not set on the context.
    case adapterIsNotSetOnContext

    /// The given controller is not child of this adapter.
    case adapterDoesNotContainSectionController

    /// The dequeued view has not the correct type.
    case dequeuedViewHasNotTheCorrectType(expected: UICollectionReusableView.Type, actual: UICollectionReusableView.Type)

    /// The model that was given to the sectioncontroller has not the correct type.
    case sectionControllerModelTypeMismatch(expected: Any.Type, actual: Any.Type)
}

extension Error: Equatable {
    @inlinable
    public static func == (lhs: Error, rhs: Error) -> Bool {
        switch (lhs, rhs) {
        case let (.notImplemented(lhsFunction), .notImplemented(rhsFunction)):
            return lhsFunction.description == rhsFunction.description

        case let (.duplicateSectionIds(lhsIds), .duplicateSectionIds(rhsIds)):
            return lhsIds == rhsIds

        case let (.missingDataSource(lhsSection), .missingDataSource(rhsSection)):
            return lhsSection == rhsSection

        case let (.unsupportedSupplementaryViewKind(lhsElementKind), .unsupportedSupplementaryViewKind(rhsElementKind)):
            return lhsElementKind == rhsElementKind

        case let (.invalidIndexPath(lhsIndexPath), .invalidIndexPath(rhsIndexPath)):
            return lhsIndexPath == rhsIndexPath

        case let (.moveIsNotInTheSameSection(lhsSourceSection, lhsDestinationSection), .moveIsNotInTheSameSection(rhsSourceSection, rhsDestinationSection)):
            return lhsSourceSection == rhsSourceSection
                && lhsDestinationSection == rhsDestinationSection

        case (.adapterIsNotSetOnContext, .adapterIsNotSetOnContext):
            return true

        case (.adapterDoesNotContainSectionController, .adapterDoesNotContainSectionController):
            return true

        case let (.dequeuedViewHasNotTheCorrectType(lhsExpected, lhsActual), .dequeuedViewHasNotTheCorrectType(rhsExpected, rhsActual)):
            return lhsExpected == rhsExpected
                && lhsActual == rhsActual

        case let (.sectionControllerModelTypeMismatch(lhsExpected, lhsActual), .sectionControllerModelTypeMismatch(rhsExpected, rhsActual)):
            return lhsExpected == rhsExpected
                && lhsActual == rhsActual

        default:
            return false
        }
    }
}

extension Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .notImplemented(function):
            return "\(function) not implemented."

        case let .duplicateSectionIds(duplicateIds):
            return "The list of sections contains two or more sections with the same id. Affected section id(s): \(duplicateIds)"

        case let .missingDataSource(section: section):
            return "There is no datasource for section with index \(section)."

        case let .unsupportedSupplementaryViewKind(kind):
            return "Unsupported supplementary view kind \"\(kind)\"."

        case let .invalidIndexPath(indexPath):
            return "The given IndexPath \(indexPath) is not valid (does not contain exactly 2 values)."

        case let .moveIsNotInTheSameSection(sourceSection, destinationSection):
            return "Move is not supported inside the same section (from \(sourceSection) to \(destinationSection))."

        case .adapterIsNotSetOnContext:
            return "The `adapter` is not set on the context."

        case .adapterDoesNotContainSectionController:
            return "The given controller is not child of this adapter."

        case let .dequeuedViewHasNotTheCorrectType(expected, actual):
            return "The dequeued view has not the correct type. Expected: \(expected) Actual: \(actual)"

        case let .sectionControllerModelTypeMismatch(expected, actual):
            return "The model that was given to the sectioncontroller has not the correct type. Expected: \(expected) Actual: \(actual)"
        }
    }
}
