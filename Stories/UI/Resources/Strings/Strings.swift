// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Alert {
    internal enum Feedback {
      /// Помогите улучшить наш сервис рекомендаций, ответив на несколько вопросов
      internal static let message = L10n.tr("Localizable", "Alert.Feedback.message")
      /// Это займет 1 минуту
      internal static let title = L10n.tr("Localizable", "Alert.Feedback.title")
      internal enum Button {
        /// Не в этот раз
        internal static let cancel = L10n.tr("Localizable", "Alert.Feedback.Button.cancel")
        /// Да, давайте
        internal static let ok = L10n.tr("Localizable", "Alert.Feedback.Button.ok")
      }
    }
    internal enum TurnOnNotifications {
      /// Чтобы включить подписки разреши уведомления
      internal static let message = L10n.tr("Localizable", "Alert.TurnOnNotifications.message")
      /// Включить подписки!
      internal static let title = L10n.tr("Localizable", "Alert.TurnOnNotifications.title")
      internal enum Button {
        /// Отмена
        internal static let cancel = L10n.tr("Localizable", "Alert.TurnOnNotifications.Button.cancel")
        /// Настройки
        internal static let ok = L10n.tr("Localizable", "Alert.TurnOnNotifications.Button.ok")
      }
    }
  }

  internal enum FutureStoryPreview {
    /// %ld
    internal static func days(_ p1: Int) -> String {
      return L10n.tr("Localizable", "FutureStoryPreview.days", p1)
    }
  }

  internal enum FutureStoryPreviewCell {
    internal enum SubscribeButton {
      /// Напомнить
      internal static let disabled = L10n.tr("Localizable", "FutureStoryPreviewCell.subscribeButton.disabled")
      /// Не напоминать
      internal static let enabled = L10n.tr("Localizable", "FutureStoryPreviewCell.subscribeButton.enabled")
      /// Повторить
      internal static let failure = L10n.tr("Localizable", "FutureStoryPreviewCell.subscribeButton.failure")
    }
  }

  internal enum Notification {
    /// Доступно новое путешествие!
    internal static let title = L10n.tr("Localizable", "Notification.title")
  }

  internal enum SummaryContentStoryView {
    internal enum BuyButton {
      /// Купить билет!
      internal static let title = L10n.tr("Localizable", "SummaryContentStoryView.BuyButton.title")
    }
  }

  internal enum TurnOnNotificationsAlert {
    /// Чтобы включить подписки разреши уведомления
    internal static let message = L10n.tr("Localizable", "TurnOnNotificationsAlert.message")
    /// Включить подписки!
    internal static let title = L10n.tr("Localizable", "TurnOnNotificationsAlert.title")
    internal enum Button {
      /// Отмена
      internal static let cancel = L10n.tr("Localizable", "TurnOnNotificationsAlert.Button.cancel")
      /// Настройки
      internal static let ok = L10n.tr("Localizable", "TurnOnNotificationsAlert.Button.ok")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
