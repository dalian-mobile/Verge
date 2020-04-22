//
// Copyright (c) 2020 Hiroshi Kimura(Muukii) <muuki.app@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

// TODO: Get a good name
public struct FilterMap<Source, Destination> {
  
  public enum Result {
    case updated(Destination)
    case noChanages
  }
  
  private let _makeIniital: (Source) -> Destination
  private let _update: (Source) -> Result
  
  public init(
    makeInitial: @escaping (Source) -> Destination,
    update: @escaping (Source) -> Result
  ) {
    self._makeIniital = makeInitial
    self._update = update
  }
  
  public init(
    preFilter: @escaping (Source) -> Bool,
    map: @escaping (Source) -> Destination,
    postFilter: @escaping (Destination) -> Bool
  ) {
    
    self.init(
      makeInitial: map,
      update: { source in
        guard !preFilter(source) else { return .noChanages }
        let result = map(source)
        guard !postFilter(result) else { return .noChanages }
        return .updated(result)
    })
    
  }
  
  public func map(_ source: Source) -> Result {
    _update(source)
  }
  
  public func makeInitial(_ source: Source) -> Destination {
    _makeIniital(source)
  }
  
}
