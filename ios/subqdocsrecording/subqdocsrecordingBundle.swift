//
//  subqdocsrecordingBundle.swift
//  subqdocsrecording
//
//  Created by HariKrishna Kundariya on 08/04/25.
//

import WidgetKit
import SwiftUI
import ActivityKit

@main
struct subqdocsrecordingBundle: WidgetBundle {
  var body: some Widget {
    if #available(iOS 16.1, *) {

      FootballMatchApp()
    }
  }
}

// We need to redefined live activities pipe
struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public typealias LiveDeliveryData = ContentState

  public struct ContentState: Codable, Hashable { }

  var id = UUID()
}

// Create shared default with custom group
let sharedDefault = UserDefaults(suiteName: "group.subqdocs.liveactivities")!

@available(iOSApplicationExtension 16.1, *)
struct FootballMatchApp: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in

//      _ = sharedDefault.string(forKey: context.attributes.prefixedKey("teamAName"))


      ZStack {

        HStack {

          VStack(alignment: .center, spacing: 6.0) {
            HStack(alignment: .center) {

              Text("\("Kishan")")
                .font(.title)
                .fontWeight(.bold)
            }
            .padding(.horizontal, 5.0)
            .background(.white.opacity(0.4), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

          }
          .padding(.vertical, 6.0)

        }
        .padding(.horizontal, 2.0)
      }.frame(height: 160)
    } dynamicIsland: { context in

//      let teamAName = sharedDefault.string(forKey: context.attributes.prefixedKey("teamAName"))!

      return DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          VStack(alignment: .center, spacing: 2.0) {

            Spacer()

            Text("hfghfhtrtr")
              .lineLimit(1)
              .font(.subheadline)
              .fontWeight(.bold)
              .multilineTextAlignment(.center)
          }
          .frame(width: 70, height: 120)
          .padding(.bottom, 8)
          .padding(.top, 8)


        }
        DynamicIslandExpandedRegion(.trailing) {
          VStack(alignment: .center, spacing: 2.0) {


            Spacer()

          }
          .frame(width: 70, height: 120)
          .padding(.bottom, 8)
          .padding(.top, 8)


        }
        DynamicIslandExpandedRegion(.center) {
          VStack(alignment: .center, spacing: 6.0) {
            HStack {

            }
            .padding(.horizontal, 5.0)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

            HStack(alignment: .center, spacing: 2.0) {
            }

            VStack(alignment: .center, spacing: 1.0) {
              Link(destination: URL(string: "la://my.app/stats")!) {
                Text("See stats 📊")
              }.padding(.vertical, 5).padding(.horizontal, 5)
            }

          }
          .padding(.vertical, 6.0)
        }
      } compactLeading: {
        HStack {
        }
      } compactTrailing: {
        HStack {
        }
      } minimal: {
        ZStack {
        }
      }
    }
  }
}

extension View {
    func Print(_ item: Any) -> some View {
        #if DEBUG
        print(item)
        #endif
        return self
    }
}

extension LiveActivitiesAppAttributes {
  func prefixedKey(_ key: String) -> String {
    return "\(id)_\(key)"
  }
}


