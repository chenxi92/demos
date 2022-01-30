//
//  BuyButtonStyle.swift
//  MyRefund
//
//  Created by peak on 2022/1/28.
//

import StoreKit
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    let isSuccess: Bool
    
    init(isSuccess: Bool = false) {
        self.isSuccess = isSuccess
    }
    
    func makeBody(configuration: Configuration) -> some View {
        var bgColor: Color = isSuccess ? Color.gray : Color.blue
        bgColor = configuration.isPressed ? bgColor.opacity(0.8) : bgColor.opacity(1.0)
        
        return configuration.label
            .frame(width: 100)
            .padding(10)
            .background(bgColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .shadow(color: .black.opacity(0.4), radius: 4, x:0, y: 6)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

extension View {
    func customButtonStyle(isSuccess: Bool) -> some View {
        self
            .buttonStyle(CustomButtonStyle(isSuccess: isSuccess))
    }
}
