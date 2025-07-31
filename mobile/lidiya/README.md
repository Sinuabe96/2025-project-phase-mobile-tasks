# eCommerce Flutter App

## 📱 Screenshots

### Home page
![home](screenshots/home.png)

### Details page
![details](screenshots/details.png)

### Search page
![search](screenshots/search.png)

### Add/Update Page
![add_update](screenshots/add_update.png)
![au](screenshots/au.png)

---

## 🧱 Architecture: Clean Architecture

The project follows **Clean Architecture** principles, organized into layers:
- `core/`: Shared components (e.g., entities, errors)
- `features/product/`: Feature module for product operations
  - `data/`: Data layer (models, repositories)
  - `domain/`: Business logic (entities, use cases, contracts)
  - `presentation/`: UI and view logic

### Folder Structure:
