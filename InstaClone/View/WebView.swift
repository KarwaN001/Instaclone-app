//
//  WebView.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // Handle loading start if needed
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Handle loading completion if needed
        }
    }
}

struct RepositoryWebView: View {
    let url: URL
    let repositoryName: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            WebView(url: url)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text(repositoryName)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("GitHub Repository")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Open in Safari
                            UIApplication.shared.open(url)
                        }) {
                            Image(systemName: "safari")
                        }
                    }
                }
        }
    }
} 