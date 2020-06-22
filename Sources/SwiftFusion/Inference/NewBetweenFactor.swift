// Copyright 2020 The SwiftFusion Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import PenguinStructures

/// A factor that specifies a difference between two poses.
///
/// `JacobianRows` specifies the `Rows` parameter of the Jacobian of this factor. See the
/// documentation on `NewJacobianFactor.jacobian` for more information. Use the typealiases below to
/// avoid specifying this type parameter every time you create an instance.
public struct NewBetweenFactor<Pose: LieGroup, JacobianRows: FixedSizeArray>:
  NewLinearizableFactor
  where JacobianRows.Element == Tuple2<Pose.TangentVector, Pose.TangentVector>
{
  public typealias Variables = Tuple2<Pose, Pose>

  public let edges: Variables.Indices
  public let difference: Pose

  public init(_ startId: TypedID<Pose, Int>, _ endId: TypedID<Pose, Int>, _ difference: Pose) {
    self.edges = Tuple2(startId, endId)
    self.difference = difference
  }

  public typealias ErrorVector = Pose.TangentVector
  public func errorVector(_ start: Pose, _ end: Pose) -> ErrorVector {
    let actualMotion = between(start, end)
    return difference.localCoordinate(actualMotion)
  }

  // Note: All the remaining code in this factor is boilerplate that we can eventually eliminate
  // with sugar.
  
  public func error(at x: Variables) -> Double {
    return errorVector(at: x).squaredNorm
  }

  public func errorVector(at x: Variables) -> Pose.TangentVector {
    return errorVector(x.head, x.tail.head)
  }

  public typealias Linearization = NewJacobianFactor<JacobianRows, ErrorVector>
  public func linearized(at x: Variables) -> Linearization {
    Linearization(linearizing: errorVector, at: x, edges: edges)
  }
}

/// A between factor on `Pose2`.
public typealias NewBetweenFactor2 = NewBetweenFactor<Pose2, Array3<Tuple2<Vector3, Vector3>>>

/// A between factor on `Pose3`.
public typealias NewBetweenFactor3 = NewBetweenFactor<Pose3, Array6<Tuple2<Vector6, Vector6>>>