//
//  subqdocsrecordingLiveActivity.swift
//  subqdocsrecording
//
//  Created by HariKrishna Kundariya on 08/04/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct subqdocsrecordingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct subqdocsrecordingLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: subqdocsrecordingAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension subqdocsrecordingAttributes {
    fileprivate static var preview: subqdocsrecordingAttributes {
        subqdocsrecordingAttributes(name: "World")
    }
}

extension subqdocsrecordingAttributes.ContentState {
    fileprivate static var smiley: subqdocsrecordingAttributes.ContentState {
        subqdocsrecordingAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: subqdocsrecordingAttributes.ContentState {
         subqdocsrecordingAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: subqdocsrecordingAttributes.preview) {
   subqdocsrecordingLiveActivity()
} contentStates: {
    subqdocsrecordingAttributes.ContentState.smiley
    subqdocsrecordingAttributes.ContentState.starEyes
}
