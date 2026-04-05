#if TEXTUAL_ENABLE_TEXT_SELECTION && canImport(AppKit)
  import AppKit
  import SwiftUI
  import Testing

  @testable import Textual

  @MainActor
  struct NSTextInteractionViewTests {
    @Test
    func hitTestOnlyReturnsSelfForRenderedText() throws {
      let model = try TextSelectionModel(fixtureName: "two-paragraphs-bidi")
      let openURL = OpenURLAction(handler: { _ in .handled })
      let container = NSView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
      let view = NSTextInteractionView(
        model: model,
        exclusionRects: [],
        openURL: openURL
      )
      view.frame = container.bounds
      container.addSubview(view)

      let textPoint = CGPoint(x: 36, y: 25)
      let emptyPoint = CGPoint(x: 10, y: 10)

      #expect(model.containsText(at: textPoint))
      #expect(!model.containsText(at: emptyPoint))
      #expect(view.hitTest(textPoint) === view)
      #expect(view.hitTest(emptyPoint) == nil)
    }

    @Test
    func hitTestIgnoresExcludedTextRegions() throws {
      let model = try TextSelectionModel(fixtureName: "two-paragraphs-bidi")
      let openURL = OpenURLAction(handler: { _ in .handled })
      let textPoint = CGPoint(x: 36, y: 25)
      let container = NSView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
      let view = NSTextInteractionView(
        model: model,
        exclusionRects: [CGRect(x: 0, y: 0, width: 80, height: 40)],
        openURL: openURL
      )
      view.frame = container.bounds
      container.addSubview(view)

      #expect(model.containsText(at: textPoint))
      #expect(view.hitTest(textPoint) == nil)
    }
  }
#endif
