//
//  MainButtonTests.swift
//
//
//  Copyright © 2021 IBM. All rights reserved.
//

@testable import VaccinationUI
import XCTest

class MainButtonTests: XCTestCase {
    var sut: MainButton!

    override func setUp() {
        super.setUp()
        sut = MainButton()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut.contentView, "Button ContentView should exist")

        let viewWithFrame = MainButton(frame: .zero)
        XCTAssertNotNil(viewWithFrame.contentView, "Button ContentView should exist")

        let viewWithCoder = MainButton(coder: CoderMock.unarchivedCoder)
        viewWithCoder?.awakeFromNib()
        viewWithCoder?.prepareForInterfaceBuilder()
        XCTAssertNotNil(viewWithCoder, "Button should exist")
        XCTAssertNotNil(viewWithCoder!.contentView, "Button ContentView should exist")
    }

    func test_style_primary() {
        // given
        let style = MainButtonStyle.primary

        // when
        sut.style = style

        // then
        XCTAssertEqual(sut.backgroundColor, style.backgroundColor)
        XCTAssertEqual(sut.layer.borderColor, style.borderColor?.cgColor)
        XCTAssertEqual(sut.layer.shadowColor, style.shadowColor?.cgColor)
    }

    func testActivityView() {
        XCTAssertEqual(sut.dotPulseActivityView.color, .backgroundSecondary)
        XCTAssertEqual(sut.dotPulseActivityView.numberOfDots, 3)
        XCTAssertEqual(sut.dotPulseActivityView.padding, 5)
    }

    func testAction() {
        var actionExecuted = false
        sut.action = {
            actionExecuted = true
        }
        sut.buttonPressed()
        XCTAssertTrue(actionExecuted, "Action should be executed")
    }

    func testTitle() {
        XCTAssertTrue(sut.title.isNilOrEmpty)
    }

    func test_title() {
        // Given
        let testTitle = "test title"

        // When
        sut.title = testTitle

        // Then
        XCTAssertEqual(sut.innerButton.titleLabel?.text, testTitle)
    }

    func testStartAnimation() {
        // When
        sut.startAnimating()

        // Then
        XCTAssertEqual(sut.dotPulseActivityView.isAnimating, true)
        XCTAssertEqual(sut.innerButton.alpha, 0)
        XCTAssertTrue(sut.buttonWidthConstraint?.isActive ?? false)
        XCTAssertTrue(sut.buttonHeightConstraint?.isActive ?? false)
    }

    func testStopAnimation() {
        // When
        sut.startAnimating()
        sut.stopAnimating()

        // Then
        XCTAssertEqual(sut.dotPulseActivityView.isAnimating, false)

        XCTAssertFalse(sut.buttonWidthConstraint?.isActive ?? false)
        XCTAssertFalse(sut.buttonHeightConstraint?.isActive ?? false)
    }

    func testStopAnimationOnTitleButton() {
        // Given
        sut.title = "Random title"

        // When
        sut.startAnimating()
        sut.stopAnimating()

        // Then
        XCTAssertEqual(sut.dotPulseActivityView.isAnimating, false)
//        XCTAssertTrue(sut.textableView.isHidden)
//        XCTAssertEqual(sut.textableView.text, "Random title")
        XCTAssertEqual(sut.innerButton.alpha, 1)

        XCTAssertFalse(sut.buttonWidthConstraint?.isActive ?? false)
        XCTAssertFalse(sut.buttonHeightConstraint?.isActive ?? false)
    }

    func testEnable() {
        // Given
        let expectedText = "Test".styledAs(.mainButton).aligned(to: .center).colored(.neutralWhite)
        sut.title = expectedText.string

        // When
        sut.enable()

        // Then
        XCTAssertTrue(sut.isEnabled, "Button should be enabled.")
        XCTAssertEqual(sut.innerButton.attributedTitle(for: .disabled), expectedText)
        XCTAssertEqual(sut.backgroundColor, .brandAccent, "Button background color should match.")
    }

    func testDisable() {
        // Given
        let expectedText = "Test".styledAs(.mainButton).aligned(to: .center).colored(.neutralWhite)
        sut.title = expectedText.string

        // When
        sut.disable()

        // Then
        XCTAssertFalse(sut.isEnabled, "Button should not be enabled.")
        XCTAssertEqual(sut.backgroundColor, .brandBase, "Button background color should match.")
        XCTAssertEqual(sut.innerButton.attributedTitle(for: .disabled), expectedText)
    }
}