🛍️ E-Commerce Flutter App

A modern and fully functional 'E-Commerce mobile application' built using Flutter, Firebase, and Riverpod state management. This app supports user authentication, product browsing, cart, wishlist, checkout, and admin product management features.

---

1.Features

=> 👤 User Side:

-  User Registration & Login (with Firebase Auth)
-  Product Listing & Details
-  Add to Wishlist
-  Add to Cart, Quantity Update, Remove
-  Checkout with order confirmation
-  Order History
-  Profile Page with Logout

=> 🔧 Admin Panel:

-  Admin-only access
-  Add Products (title,description, price, category, image URL)
-  Secured with role-based access

---

2. 📸 Screenshots
   
  <h3>Login Page</h3>
<img src="assets/screenshots/login.jpg" width="300" height="600"/>

 <h3>Register Page</h3>
<img src="assets/screenshots/signup.jpg" width="300" height="600"/>

  <h3>Home Page</h3>
<img src="assets/screenshots/home.jpg" width="300" height="600"/>

<h3>Sidebar(Drawer)</h3>
<img src="assets/screenshots/sidebar.jpg" width="300" height="600"/>

<h3>Product Detail Page</h3>
<img src="assets/screenshots/detail.jpg" width="300" height="600"/>

<h3>Cart Page</h3>
<img src="assets/screenshots/cart.jpg" width="300" height="600"/>

<h3>Checkout Page </h3>
<img src="assets/screenshots/checkout.jpg" width="300" height="600"/>

<h3>Profile Page</h3>
<img src="assets/screenshots/profile.jpg" width="300" height="600"/>

<h3>Admin Page</h3>
<img src="assets/screenshots/admin.jpg" width="300" height="600"/>

<h3>Wishlist</h3>
<img src="assets/screenshots/wishlist.jpg" width="300" height="600"/>

---

3. Tech Stack

- Flutter 3.0+
- Firebase (Auth, Firestore, Storage, Messaging)
- Riverpod (for state management)
- Google Fonts for UI design
- Material Design + Theme customization

---

4. Installation

* Prerequisites
- Flutter SDK installed
- Firebase Project setup (with Android support)
- Emulator or physical Android device


* Steps
1. Clone this repo:
git clone https://github.com/ebroahmed/e_commerce_flutter_app.git
cd e_commerce_flutter_app

2.Install dependencies:
  flutter pub get

3.Configure Firebase:
Add your google-services.json to /android/app/
Enable Firebase Auth, Firestore, Messaging, Storage

4.Run the app:
 flutter run


 📂 Project Structure Highlights
 
 lib/
 ├── models/
 ├── providers/
 ├── repositories/
 ├── screens/
 ├── widgets/
 └── main.dart

* Admin Access
To enable admin access:
 - Go to Firestore → Users collection → Find the user document.
 - Add a role field with value: "admin"
Only users with role: "admin" can access the admin panel.

* Deployment (APK)
   1. Run
      flutter build apk --release
   2. Find the APK at:
      build/app/outputs/flutter-apk/app-release.apk


Contact
If you'd like to collaborate, hire, or ask questions:

Ebrahim Ahmed
📧 [ebrahimahmed804853@gmail.com]
🔗 [Github (https://github.com/ebroahmed/)]    

Star ⭐ the repo if you found it helpful!
