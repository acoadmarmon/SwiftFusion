import ArgumentParser

import SwiftFusion
import BeeTracking
import PythonKit
import Foundation

/// Random Projections Tracker, with EM-based training
struct Frank03: ParsableCommand {
  @Option(help: "Run on track number x")
  var trackId: Int = 0
  
  @Option(help: "Run for number of frames")
  var trackLength: Int = 80
  
  // Just runs an RP tracker and saves image to file
  func run() {
    let (fig, _, _) = runRPTracker(directory: URL(fileURLWithPath: "./OIST_Data"), onTrack: trackId, forFrames: trackLength, withSampling:true, usingEM: true)
    fig.savefig("frank01.pdf", bbox_inches: "tight")
  }
}
