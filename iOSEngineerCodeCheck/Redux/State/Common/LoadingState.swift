//
//  LoadingState.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

/// API通信状況の状態を管理する
public struct LoadingState {
    private var count = 0

    public var isLoading: Bool {
        // swiftlintがバグっていてErrorになるのでdisable
        // swiftlint:disable:next empty_count
        count > 0
    }

    mutating func increment() {
        count += 1
    }

    mutating func decrement() {
        // swiftlintがバグっていてErrorになるのでdisable
        // swiftlint:disable:next empty_count
        if count == 0 { return }
        count -= 1
    }
}
