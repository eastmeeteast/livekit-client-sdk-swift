import Foundation
import AVFAudio

protocol AudioSessionHandler: AnyObject {
    var audioSession: AVAudioSession { get }

    func handleInterruptionBegan(applicationWasSuspended: Bool)

    func handleInterruptionEnd(shouldResume: Bool)

    func handleAudioRouteChange()

    func handleMediaServerWereReset()

    func handleMediaServerWereLost()
}

extension AudioSessionHandler {
    func subscribeAudioSessionNotifications() -> [Any] {
        let center = NotificationCenter.default
        let interruptionNotificationSubscribtion = center.addObserver(forName: AVAudioSession.interruptionNotification, object: audioSession, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            guard let type = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber,
                  let interruptionType = AVAudioSession.InterruptionType(rawValue: type.uintValue) else {
                return
            }

            switch interruptionType {
            case .began:
                var applicationWasSuspended: Bool = false
                if #available(iOS 14.5, *) {
                    if let rawReason = notification.userInfo?[AVAudioSessionInterruptionReasonKey] as? NSNumber,
                       let reason = AVAudioSession.InterruptionReason(rawValue: rawReason.uintValue) {
                        applicationWasSuspended = reason == .appWasSuspended
                    }
                } else {
                    if let wasSuspended = notification.userInfo?[AVAudioSessionInterruptionWasSuspendedKey] as? NSNumber, wasSuspended.boolValue {
                        applicationWasSuspended = true
                    }
                }
                self.handleInterruptionBegan(applicationWasSuspended: applicationWasSuspended)
            case .ended:
                var shouldResume = false
                if let type = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? NSNumber {
                    let interruptionOptions = AVAudioSession.InterruptionOptions(rawValue: type.uintValue)
                    shouldResume = interruptionOptions.contains(.shouldResume)
                }
                self.handleInterruptionEnd(shouldResume: shouldResume)
            @unknown default:
                return
            }

        }
        let routeChangeNotificationSubscribtion = center.addObserver(forName: AVAudioSession.routeChangeNotification, object: audioSession, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.handleAudioRouteChange()
        }

        let mediaServicesWereLostNotificationSubscribtion = center.addObserver(forName: AVAudioSession.mediaServicesWereLostNotification, object: audioSession, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.handleMediaServerWereLost()
        }
        let mediaServicesWereResetNotificationSubscribtion = center.addObserver(forName: AVAudioSession.mediaServicesWereResetNotification, object: audioSession, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.handleMediaServerWereReset()
        }

        return [interruptionNotificationSubscribtion, routeChangeNotificationSubscribtion, mediaServicesWereLostNotificationSubscribtion, mediaServicesWereResetNotificationSubscribtion]
    }

    func unsubscribeAudioSessionNotifications(observers: [Any]) {
        let center = NotificationCenter.default
        for observer in observers {
            center.removeObserver(observer)
        }
    }
}
