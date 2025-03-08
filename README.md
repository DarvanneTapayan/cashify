flutter clean
flutter pub get
flutter run -d windows


# ukay_ukay_cashiering_app

A new Flutter project.

## Getting Started

Glad everything’s working well now! To copy your **Ukay-Ukay Cashiering App** code to another device and ensure it runs smoothly, you’ll need to transfer the project files, set up the development environment, and handle the database. Here’s a step-by-step guide:

---

### Steps to Copy the Code to Another Device

#### 1. **Transfer the Project Files**
- **What to Copy**:
  - The entire project folder (e.g., `ukay_ukay_cashiering_app`) containing:
    - `lib/` (your Dart code)
    - `pubspec.yaml` (dependencies)
    - `assets/` (if you added any)
    - Other config files (e.g., `analysis_options.yaml`, `android/`, `ios/`, `windows/`, etc.)
- **How to Copy**:
  - **USB Drive**: Zip the folder, copy it to a USB drive, and unzip it on the new device.
  - **Cloud Storage**: Upload to Google Drive, Dropbox, etc., and download on the new device.
  - **Git**: If you’re using version control (recommended), push to a repository (e.g., GitHub) from the original device and clone it on the new one:
    ```bash
    # On original device (if not already in a repo):
    git init
    git add .
    git commit -m "Initial commit"
    git remote add origin <your-repo-url>
    git push -u origin main

    # On new device:
    git clone <your-repo-url>
    cd ukay_ukay_cashiering_app
    ```

#### 2. **Set Up the Development Environment on the New Device**
- **Install Flutter**:
  - Download and install Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install).
  - Extract it to a folder (e.g., `C:\flutter` on Windows).
  - Add Flutter to your PATH:
    - Windows: Update the system environment variable `Path` to include `C:\flutter\bin`.
    - Verify with:
      ```bash
      flutter --version
      ```
- **Install an IDE**:
  - Install Visual Studio Code (recommended) or Android Studio.
  - Add Flutter and Dart plugins:
    - VS Code: Search for "Flutter" in Extensions and install.
    - Android Studio: Comes with Flutter support.
- **Install Dependencies**:
  - Open a terminal in the project folder on the new device.
  - Run:
    ```bash
    flutter pub get
    ```
  - This installs all dependencies listed in `pubspec.yaml` (e.g., `provider`, `sqflite`).

#### 3. **Handle the Database**
- **Database Location**:
  - The app uses SQLite at `C:\Users\Deestarling\Documents\ukay_ukay.db` on your current device.
  - This file contains your products, transactions, settings, etc.
- **Options**:
  - **Copy the Database** (to keep existing data):
    - Locate `C:\Users\Deestarling\Documents\ukay_ukay.db`.
    - Copy it to the new device at the equivalent path (e.g., `C:\Users\<NewUser>\Documents\`).
    - Ensure the app’s `DatabaseService` points to this path (it does by default via `getApplicationDocumentsDirectory()`).
  - **Recreate the Database** (start fresh):
    - Skip copying the `.db` file.
    - On first run, the app will create a new `ukay_ukay.db` in the new device’s documents directory with default data (admin user, sample products).
    - You’ll need to re-add your 100+ products manually or via script (see below).
- **Script for 100+ Products** (if recreating):
  - Edit `DatabaseService._initDatabase` temporarily:
    ```dart
    onCreate: (db, version) async {
      // Existing table creation code...
      await db.insert('users', {'username': 'admin', 'password': 'admin123'});
      for (int i = 1; i <= 100; i++) {
        await db.insert('products', {'name': 'Product $i', 'price': i * 10.0, 'stock': i});
      }
      await db.insert('settings', {'cash_enabled': 1, 'card_enabled': 0});
      print('Database initialized with 100+ products');
    },
    ```
  - Run the app once, then remove this loop to avoid re-adding on every startup.

#### 4. **Run the App on the New Device**
- **Connect a Device or Use Emulator**:
  - **Physical Device**: Enable Developer Mode and USB Debugging on an Android phone, connect via USB, and run:
    ```bash
    flutter devices
    flutter run
    ```
  - **Windows Desktop**: Since you’ve been using `flutter run -d windows`, ensure the new device has Visual Studio (with Desktop development with C++) installed for Windows builds.
    ```bash
    flutter config --enable-windows-desktop
    flutter run -d windows
    ```
  - **Emulator**: Set up an Android emulator in Android Studio if needed.
- **Clean and Build**:
  - Run:
    ```bash
    flutter clean
    flutter pub get
    flutter run -d windows
    ```
  - This ensures a fresh build with no cached issues.

#### 5. **Verify Functionality**
- Log in with `admin`/`admin123`.
- Check:
  - **Inventory Management**: Scrollbar and sorting work with 100+ products.
  - **New Transaction**: Payment dropdown has a border and works.
  - **Settings**: Save shows "Successfully saved" on the dashboard.
  - **Sales Reports**: Top-selling products show correct totals.
- If you copied the database, ensure all data (products, transactions) is intact.

---

### Things to Watch Out For

- **Flutter Version**: Ensure the Flutter version matches (run `flutter --version` on both devices). If different, run `flutter upgrade` on the new device to match, or specify the version in `pubspec.yaml` (e.g., `flutter: ">=3.19.0"`).
- **Dependencies**: If `flutter pub get` fails, check `pubspec.yaml` for outdated packages and run `flutter pub upgrade`.
- **Paths**: The database path adjusts to the new user’s Documents folder, but if you hardcode paths elsewhere, update them.
- **Git Ignore**: If using Git, ensure `ukay_ukay.db` isn’t in `.gitignore` if you want to version it (though typically, databases aren’t committed).

---

### Recommended Workflow

- **Use Git**: Set up a GitHub repository to easily sync code across devices without manual copying:
  - On original device:
    ```bash
    git init
    git add .
    git commit -m "Initial commit"
    git remote add origin https://github.com/<your-username>/<repo-name>.git
    git push -u origin main
    ```
  - On new device:
    ```bash
    git clone https://github.com/<your-username>/<repo-name>.git
    cd <repo-name>
    flutter pub get
    flutter run -d windows
    ```
- **Backup Database**: Before transferring, back up `ukay_ukay.db` somewhere safe (e.g., cloud storage) in case of issues.

---

### Summary

1. Copy the project folder (via USB, cloud, or Git).
2. Install Flutter and an IDE on the new device.
3. Decide whether to copy or recreate the database.
4. Run `flutter pub get` and `flutter run -d windows`.
5. Test all features.

With these steps, your app should run identically on the new device. Let me know if you hit any snags during the transfer!