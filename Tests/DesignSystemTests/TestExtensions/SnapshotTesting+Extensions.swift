import SnapshotTesting
import SwiftUI
import UIKit

/// UIKit UIView extension
extension UIView {
    public func assertSnapshot(
        in size: CGSize = CGSize(width: 500, height: 500),
        precision: Float = 0.995,
        perceptualPrecision: Float = 0.98,
        record recording: Bool? = nil,
        timeout: TimeInterval = 5,
        fileID: StaticString = #fileID,
        file filePath: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line,
        column: UInt = #column,
        traitCollections: [[UITraitCollection]] = allCombinationsOf(
            arrays: [
                UITraitCollection.testingDynamicTypeTraits,
                UITraitCollection.testingUserInterfaceStyle
            ]
        )
    ) {
        traitCollections.forEach {
            let traits = UITraitCollection(traitsFrom: $0)

            let canvas = UIView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: size.width,
                    height: size.height
                )
            )

            canvas.addSubview(self)
            canvas.backgroundColor = .clear

            self.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate(
                [
                    self.centerXAnchor.constraint(equalTo: canvas.centerXAnchor),
                    self.centerYAnchor.constraint(equalTo: canvas.centerYAnchor)
                ]
            )

            SnapshotTesting.assertSnapshot(
                of: canvas,
                as: .image(
                    precision: precision,
                    perceptualPrecision: perceptualPrecision,
                    size: CGSize(
                        width: size.width,
                        height: size.height
                    ),
                    traits: traits
                ),
                record: recording,
                timeout: timeout,
                fileID: fileID,
                file: filePath,
                testName: testName,
                line: line,
                column: column
            )
        }
    }
}

/// UIKit UIViewController extension
extension UIViewController {
    public func assertSnapshot(
        devices: [ViewImageConfig] = .standard,
        precision: Float = 0.995,
        perceptualPrecision: Float = 0.98,
        record recording: Bool? = nil,
        timeout: TimeInterval = 5,
        fileID: StaticString = #fileID,
        file filePath: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line,
        column: UInt = #column,
        traitCollections: [[UITraitCollection]] = allCombinationsOf(
            arrays: [
                UITraitCollection.testingDynamicTypeTraits,
                UITraitCollection.testingUserInterfaceStyle
            ]
        )
    ) {
        traitCollections.forEach {
            let traits = UITraitCollection(traitsFrom: $0)

            devices.forEach {
                SnapshotTesting.assertSnapshot(
                    of: self,
                    as: .image(
                        on: $0,
                        precision: precision,
                        perceptualPrecision: perceptualPrecision,
                        traits: traits
                    ),
                    record: recording,
                    timeout: timeout,
                    fileID: fileID,
                    file: filePath,
                    testName: testName,
                    line: line,
                    column: column
                )
            }
        }
    }
}

/// SwiftUI View extension
extension View {
    public func assertSnapshot(
        devices: [ViewImageConfig] = .standard,
        precision: Float = 0.995,
        perceptualPrecision: Float = 0.98,
        record recording: Bool? = nil,
        timeout: TimeInterval = 5,
        fileID: StaticString = #fileID,
        file filePath: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line,
        column: UInt = #column,
        traitCollections: [[UITraitCollection]] = allCombinationsOf(
            arrays: [
                UITraitCollection.testingDynamicTypeTraits,
                UITraitCollection.testingUserInterfaceStyle
            ]
        )
    ) {
        traitCollections.forEach {
            let traits = UITraitCollection(traitsFrom: $0)

            devices.forEach {
                SnapshotTesting.assertSnapshot(
                    of: self,
                    as: .image(
                        precision: 0.995,
                        perceptualPrecision: 0.995,
                        layout: .device(config: $0),
                        traits: traits,
                    ),
                    record: recording,
                    timeout: timeout,
                    fileID: fileID,
                    file: filePath,
                    testName: testName,
                    line: line,
                    column: column
                )
            }
        }
    }
}

extension [ViewImageConfig] {
    public static let standard: [ViewImageConfig] = [
        .iPhone13ProMax(.portrait),
        .iPhone13ProMax(.landscape)
    ]
}
