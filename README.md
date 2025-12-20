# Immediate Edge - Speed Reading App

iOS приложение для развития навыков скорочтения.

## Публикация в App Store без MacBook

Эта инструкция позволяет опубликовать приложение в App Store используя только браузер и сервис Codemagic.

---

## Шаг 1: Регистрация в Apple Developer Program

1. Перейдите на [developer.apple.com](https://developer.apple.com)
2. Нажмите "Account" и войдите с Apple ID
3. Зарегистрируйтесь в Apple Developer Program ($99/год)
4. Дождитесь подтверждения (обычно 24-48 часов)

---

## Шаг 2: Создание приложения в App Store Connect

1. Перейдите в [App Store Connect](https://appstoreconnect.apple.com)
2. Нажмите "My Apps" → "+" → "New App"
3. Заполните:
   - **Platform**: iOS
   - **Name**: Immediate Edge: Speed Reading
   - **Primary Language**: English
   - **Bundle ID**: выберите "com.immediateedge.edgeimme.speedreadingimmed"
   - **SKU**: immediateedge2024 (любой уникальный идентификатор)
4. Нажмите "Create"

---

## Шаг 3: Регистрация Bundle ID

1. Перейдите в [Apple Developer Portal](https://developer.apple.com/account)
2. Certificates, Identifiers & Profiles → Identifiers
3. Нажмите "+" для создания нового
4. Выберите "App IDs" → Continue
5. Выберите "App" → Continue
6. Заполните:
   - **Description**: Immediate Edge Speed Reading
   - **Bundle ID**: Explicit → `com.immediateedge.edgeimme.speedreadingimmed`
7. Прокрутите вниз и включите нужные Capabilities (можно оставить по умолчанию)
8. Нажмите "Continue" → "Register"

---

## Шаг 4: Создание API ключа для Codemagic

1. В [App Store Connect](https://appstoreconnect.apple.com) → Users and Access
2. Вкладка "Integrations" → "App Store Connect API"
3. Нажмите "+" для создания ключа
4. **Name**: Codemagic
5. **Access**: Admin (или App Manager)
6. Нажмите "Generate"
7. **ВАЖНО**: Скачайте файл `.p8` — он даётся только один раз!
8. Запишите:
   - **Issuer ID** (вверху страницы)
   - **Key ID** (в таблице рядом с ключом)

---

## Шаг 5: Настройка Codemagic

1. Зарегистрируйтесь на [codemagic.io](https://codemagic.io)
2. Подключите GitHub/GitLab/Bitbucket репозиторий с проектом
3. Перейдите в Settings → Integrations → App Store Connect
4. Нажмите "Add key" и заполните:
   - **Name**: Codemagic
   - **Issuer ID**: (из шага 4)
   - **Key ID**: (из шага 4)
   - **API Key**: загрузите файл `.p8`
5. Сохраните

---

## Шаг 6: Настройка переменных окружения

1. В Codemagic откройте настройки приложения
2. Перейдите в Environment variables
3. Добавьте переменную:
   - **Name**: `CM_EMAIL`
   - **Value**: ваш email для уведомлений

---

## Шаг 7: Запуск сборки

1. В Codemagic нажмите "Start new build"
2. Выберите ветку `main`
3. Выберите workflow `ios-release`
4. Нажмите "Start new build"

Codemagic автоматически:
- Загрузит сертификаты из Apple Developer
- Создаст provisioning profile (если нужно)
- Соберёт приложение
- Отправит в TestFlight
- После проверки Apple — опубликует в App Store

---

## Шаг 8: Заполнение метаданных в App Store Connect

Пока идёт сборка, заполните информацию о приложении:

### Вкладка "App Information"
- **Subtitle**: Train Your Brain to Read Faster
- **Category**: Education
- **Content Rights**: Не содержит контент третьих лиц

### Вкладка "Pricing and Availability"
- Выберите цену (Free или платная)
- Выберите страны

### Вкладка "App Privacy"
- Укажите какие данные собирает приложение
- Для этого приложения: Data Not Collected (данные хранятся только на устройстве)

### Версия приложения
- **Screenshots**: загрузите скриншоты для iPhone 6.7" и 5.5"
- **Description**: описание приложения
- **Keywords**: speed reading, reading trainer, comprehension, learn, study
- **Support URL**: ваш сайт или страница поддержки
- **Marketing URL**: (опционально)

---

## Скриншоты

Размеры скриншотов:
- **iPhone 6.7"** (iPhone 14 Pro Max): 1290 x 2796 px
- **iPhone 5.5"** (iPhone 8 Plus): 1242 x 2208 px
- **iPad 12.9"**: 2048 x 2732 px (если поддерживается iPad)

Можно сделать скриншоты в симуляторе или использовать сервисы вроде [screenshots.pro](https://screenshots.pro)

---

## Автоматическая публикация

После настройки каждый push в ветку `main` будет автоматически:
1. Собирать приложение
2. Отправлять в TestFlight
3. После прохождения Review — публиковать в App Store с постепенным релизом (phased release)

---

## Статусы сборки

- **Building**: идёт сборка
- **Publishing**: отправка в App Store Connect
- **Finished**: успешно завершено
- **Failed**: ошибка (проверьте логи)

При любом статусе вы получите email уведомление.

---

## Troubleshooting

### "No matching provisioning profile"
- Убедитесь что Bundle ID совпадает в Apple Developer и codemagic.yaml
- API ключ имеет права Admin или App Manager

### "Code signing error"
- Проверьте что интеграция App Store Connect настроена в Codemagic
- Имя интеграции должно быть "Codemagic" (как в codemagic.yaml)

### "Build failed"
- Скачайте логи из Codemagic и проверьте ошибки
- Убедитесь что Xcode версия совместима с проектом

---

## Поддержка

- Codemagic документация: [docs.codemagic.io](https://docs.codemagic.io)
- Apple Developer документация: [developer.apple.com/documentation](https://developer.apple.com/documentation)
