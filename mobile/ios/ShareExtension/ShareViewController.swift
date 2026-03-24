import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    private let appGroupId = "group.com.ledoweb.huly"

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }

        var sharedText: String?
        var sharedURL: String?
        let group = DispatchGroup()

        for item in extensionItems {
            guard let attachments = item.attachments else { continue }

            for attachment in attachments {
                if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    group.enter()
                    attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { data, _ in
                        if let url = data as? URL {
                            sharedURL = url.absoluteString
                        }
                        group.leave()
                    }
                }

                if attachment.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                    group.enter()
                    attachment.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { data, _ in
                        if let text = data as? String {
                            sharedText = text
                        }
                        group.leave()
                    }
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.saveAndOpenApp(text: sharedText, url: sharedURL)
        }
    }

    private func saveAndOpenApp(text: String?, url: String?) {
        guard let userDefaults = UserDefaults(suiteName: appGroupId) else {
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }

        let shareData: [String: Any?] = [
            "text": text,
            "url": url,
            "timestamp": Date().timeIntervalSince1970,
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: shareData.compactMapValues { $0 }),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            userDefaults.set(jsonString, forKey: "pendingShare")
            userDefaults.synchronize()
        }

        // Open the main app via URL scheme.
        if let appURL = URL(string: "huly://share") {
            openURL(appURL)
        }

        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    // Open URL from extension context (uses responder chain).
    @objc private func openURL(_ url: URL) {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.open(url, options: [:], completionHandler: nil)
                return
            }
            responder = responder?.next
        }
        // Fallback: use selector-based approach.
        let selector = sel_registerName("openURL:")
        var nextResponder: UIResponder? = self
        while let r = nextResponder {
            if r.responds(to: selector) {
                r.perform(selector, with: url)
                return
            }
            nextResponder = r.next
        }
    }

    override func configurationItems() -> [Any]! {
        return []
    }
}
