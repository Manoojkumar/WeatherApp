//
//  Helper.swift
//  Weather
//
//  Created by Mano on 03/08/23.
//

import Foundation
import SwiftUI

extension Color {
    static let customLightGray = Color("LightGray")
    static let customTextColor = Color("TextColor")
    static let customButtonColor = Color("CustomButtonColor")
    static let textColor2 = Color("TextColor2")
    static let constantWhite = Color("ConstantColorWhite")
    static let constantBlack = Color("ConstantColorBlack")
    static let buttonColor2 = Color("ButtonColor2")
}

extension Font {
    static func customAvenir(size: CGFloat) -> Font {
        return Font.custom("Avenir", size: size)
    }
    
    static func customNewYork(size: CGFloat) -> Font {
        return Font.custom("Times New Roman", size: size)
    }
}

class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    
    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    func renew(_ action: @escaping () -> Void) {
        workItem?.cancel()
        let workItem = DispatchWorkItem(block: action)
        self.workItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}

extension DispatchQueue {
    static func delay(_ seconds: Double, execute: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            execute()
        }
    }
}

// Update for iOS 15
// MARK: - UIApplication extension for resgning keyboard on pressing the cancel buttion of the search bar
extension UIApplication {
    // Resigns the keyboard.

    func endEditing(_ force: Bool) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
    func hasScrollEnabled(_ value: Bool) -> some View {
        self.onAppear {
            UITableView.appearance().isScrollEnabled = value
        }
    }
}

func extractImageCode(from urlString: String) -> Int? {
       guard let lastComponent = urlString.split(separator: "/").last else {
           return nil
       }
       let imageCode = lastComponent.split(separator: ".").first
   
       return Int(imageCode ?? "")
}



func formatTime(_ time: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    if let date = dateFormatter.date(from: time) {
        dateFormatter.dateFormat = "H"
        return dateFormatter.string(from: date)
    }
    
    return ""
}

extension DateFormatter {
    static var hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    
    static var weekDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
}




struct NavigationUtil {
    static func popToRootView() {
        findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
            .popToRootViewController(animated: true)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}
extension View {
    func externalURLAlert(isPresented: Binding<Bool>, action: ()) -> some View {
        self.alert(isPresented: isPresented) {
            Alert(
                title: Text("alert.externalURL.title"),
                message: Text("alert.externalURL.message"),
                primaryButton: .cancel(),
                secondaryButton: .default(Text("alert.externalURL.openAction.title")) {
                    action
                }
            )
        }
    }
}
