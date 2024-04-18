//
//  WebView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 18/04/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#Preview() {
    WebView(url: URL(string: "https://www.google.com.ar")!)
}
