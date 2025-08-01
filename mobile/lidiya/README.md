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
  - `data/`: Data layer (models, repositories, datasources)
  - `domain/`: Business logic (entities, use cases, contracts)
  - `presentation/`: UI and view logic

### Folder Structure:

```
lib/
├── core/
│   ├── errors/
│   └── utils/
├── features/
│   └── product/
│       ├── data/
│       │   ├── models/
│       │   │   └── product_model.dart
│       │   ├── repositories/
│       │   │   └── product_repository_impl.dart
│       │   └── datasources/
│       │       ├── remote_data_source.dart
│       │       ├── remote_data_source_impl.dart
│       │       ├── local_data_source.dart
│       │       └── local_data_source_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── product.dart
│       │   ├── repositories/
│       │   │   └── product_repository.dart
│       │   └── usecases/
│       │       ├── create_product.dart
│       │       ├── update_product.dart
│       │       ├── delete_product.dart
│       │       └── view_product.dart
│       └── presentation/
└── main.dart
```

## 🔄 Data Flow

### 1. **Domain Layer** (Business Logic)

- **Entities**: Pure business objects (Product)
- **Use Cases**: Business rules and operations
- **Repository Interfaces**: Contracts for data operations

### 2. **Data Layer** (Data Management)

- **Models**: Data transfer objects with JSON conversion
- **Repository Implementations**: Concrete data access logic
- **Data Sources**: Remote and local data contracts and implementations

### 3. **Presentation Layer** (UI)

- **Views**: User interface components
- **Controllers/Blocs**: State management and UI logic

## 📋 Data Source Contracts (Task 11)

### Remote Data Source Contract

The `RemoteDataSource` abstract class defines the contract for fetching data from remote APIs:

- `getAllProducts()`: Fetches all products from remote API
- `getProductById(String id)`: Fetches specific product by ID
- `createProduct(ProductModel product)`: Creates new product on remote
- `updateProduct(ProductModel product)`: Updates existing product
- `deleteProduct(String id)`: Deletes product from remote

### Local Data Source Contract

The `LocalDataSource` abstract class defines the contract for local data storage:

- `getAllProducts()`: Retrieves cached products from local storage
- `getProductById(String id)`: Retrieves specific cached product
- `createProduct(ProductModel product)`: Stores product locally
- `updateProduct(ProductModel product)`: Updates cached product
- `deleteProduct(String id)`: Removes product from local cache
- `cacheProducts(List<ProductModel> products)`: Caches products from remote
- `clearCache()`: Clears all cached data

### Repository Implementation

The `ProductRepositoryImpl` orchestrates between remote and local data sources:

- **Cache-First Strategy**: Checks local cache before making remote calls
- **Fallback Mechanism**: Falls back to remote when local cache is empty
- **Synchronization**: Keeps local and remote data in sync
- **Error Handling**: Graceful handling of network and storage failures

## 🌐 Network-Aware Repository (Task 12)

### Network Information Contract

The `NetworkInfo` abstract class provides network connectivity status:

- `isConnected`: Returns true if device has internet connectivity

### Enhanced Repository Implementation

The `ProductRepositoryImpl` now includes intelligent network-aware logic:

#### **Network Available Strategy:**

- **Read Operations**: Fetch from remote, cache locally, return fresh data
- **Write Operations**: Update remote first, then sync to local cache
- **Fallback**: If remote fails, use local data for reads, still cache locally for writes

#### **Network Unavailable Strategy:**

- **Read Operations**: Return cached local data only
- **Write Operations**: Cache locally for offline support
- **Sync**: Changes are queued locally and will sync when network returns

#### **Key Features:**

- ✅ **Offline-First**: App works without internet connection
- ✅ **Intelligent Caching**: Automatic local caching of remote data
- ✅ **Error Resilience**: Graceful handling of network failures
- ✅ **Data Consistency**: Local and remote data synchronization
- ✅ **Performance**: Fast local access with background remote sync

### Comprehensive Testing

The repository includes extensive unit tests covering:

- **Network Available Scenarios**: Remote success, remote failure with local fallback
- **Network Unavailable Scenarios**: Local-only operations
- **Error Handling**: Network errors, local storage errors
- **Data Consistency**: Proper caching and synchronization
- **All CRUD Operations**: Create, Read, Update, Delete with network awareness

## 🚀 Usage

### Product Operations

The app supports full CRUD operations for products:

1. **Create Product**: Add new products with name, description, price, and image
2. **Read Products**: View all products or get specific product details
3. **Update Product**: Modify existing product information
4. **Delete Product**: Remove products from the system

### Architecture Benefits

- **Separation of Concerns**: Each layer has a specific responsibility
- **Testability**: Business logic is isolated and easily testable
- **Maintainability**: Changes in one layer don't affect others
- **Scalability**: Easy to add new features following the same pattern
- **Data Source Abstraction**: Contracts allow easy switching between data sources
- **Offline Support**: Local caching enables offline functionality

## 🧪 Testing

The project includes comprehensive unit tests:

- **Model Tests**: Verify JSON conversion logic
- **Widget Tests**: Ensure UI components work correctly

Run tests with:

```bash
flutter test
```

## 📦 Dependencies

Key dependencies used:

- `flutter_test`: For unit and widget testing
- `http`: For remote API calls
- `shared_preferences`: For local data storage
- Clean Architecture pattern for code organization

## 🔧 Development

This project demonstrates:

- Clean Architecture implementation
- Test-Driven Development (TDD) practices
- Proper separation of concerns
- Modern Flutter development patterns
- Data source contracts and repository pattern
- Offline-first architecture with caching
