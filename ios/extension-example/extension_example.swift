//
//  extension_example.swift
//  extension-example
//
//  Created by Dimitri Dessus on 28/09/2022.
//

import ActivityKit
import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
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

      let userName = sharedDefault.string(forKey: context.attributes.prefixedKey("userName"))!
      let recordingTime = sharedDefault.string(forKey: context.attributes.prefixedKey("recordingTime"))!;



      HStack(spacing: 20) {
                 // Mic Icon & Name
                 HStack(spacing: 12) {

                     VStack(alignment: .leading, spacing: 4) {
                         Text(userName)
                             .font(.system(size: 24, weight: .semibold))
                             .foregroundColor(.white)

                         Text(recordingTime)
                             .font(.system(size: 20, weight: .medium))
                             .foregroundColor(Color(red: 139/255, green: 149/255, blue: 166/255)) // greyish blue
                     }
                 }

                 Spacer()

                 // Action Buttons
                 HStack(spacing: 20) {

                   Circle()
                       .fill(Color.white)
                       .frame(width: 60, height: 60)
                       .overlay(
                           Image(systemName: "pause")
                               .font(.system(size: 26))
                               .foregroundColor(.gray)
                       ).onTapGesture {
                         // Handle the tap action here
                         print("Circle tapped!")
                         sharedDefault.set("Kishan Suthar", forKey: "userName")
                         sharedDefault.synchronize()

                     }


                   Link(destination: URL(string: "la://my.app/stop")!) {
                       Circle()
                           .fill(Color.red)
                           .frame(width: 60, height: 60)
                           .overlay(
                               Image(systemName: "stop.fill")
                                   .font(.system(size: 26))
                                   .foregroundColor(.white)
                           )
                   }

//                     Circle()
//                         .fill(Color.red)
//                         .frame(width: 60, height: 60)
//                         .overlay(
//                             Image(systemName: "stop.fill")
//                                 .font(.system(size: 26))
//                                 .foregroundColor(.white)
//                         )
                 }
             }
             .padding()
             .background(Color.black)
             .shadow(radius: 20)


    } dynamicIsland: { context in

      return DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
        }
        DynamicIslandExpandedRegion(.trailing) {
        }
        DynamicIslandExpandedRegion(.center) {
        }
      } compactLeading: {
      } compactTrailing: {
      } minimal: {

      }
    }
  }
}

extension LiveActivitiesAppAttributes {
  func prefixedKey(_ key: String) -> String {
    return "\(id)_\(key)"
  }
}
