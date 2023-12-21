User Roles:
Registered Users:
Can save addresses.
View order history.
Admins:
Manage products, categories, and inventory.
View and process orders.
//Monitor user activity.
//Browsing without a user/maybe a guest user session → more on it after discussion
Features:
Authentication and Authorization:
Devise gem for user authentication.
Role-based access control.
Product Management:
CRUD operations for products.
Image uploads for products.
Shopping Cart:
Session management for carts.
Checkout:
Address forms with validation.
Order Management:
Order history and details for users.
Order processing workflow for admins.
Inventory:
Track product quantities.
Low stock alerts
Email:
Order Verification and cancellation Email
Use Cases:
Product Browsing:
Users should be able to browse products by categories, search, and filter options.
Product Management:
Admins should be able to add, edit, and remove products.
User Authentication:
User registration and login for customers.
Shopping Cart:
Users can add products to a shopping cart.
Order Management:
Users and admins should be able to view order history.
Order confirmation emails to users.
Inventory Management:
Real-time inventory updates.
Alerts for low stock.
——————————————————————————————————————————

ERD Relations

User
Attributes: UserID (Primary Key), Username, Password, Email, Role
Address
Attributes: AddressID (Primary Key), UserID (Foreign Key), Street, City, State, Zip Code
Order
Attributes: OrderID (Primary Key), UserID (Foreign Key), OrderDate, TotalAmount, Status
Product
Attributes: ProductID (Primary Key), Name, Description, Price, CategoryID (Foreign Key), StockQuantity
Category
Attributes: CategoryID (Primary Key), Name
Cart
Attributes: CartID (Primary Key), UserID (Foreign Key)
CartItem
Attributes: CartItemID (Primary Key), CartID (Foreign Key), ProductID (Foreign Key), Quantity
Relationships:
One User can have many Addresses (One-to-Many relationship).
One User can place many Orders (One-to-Many relationship).
One Order can contain multiple Products, and each Product can be part of multiple Orders (Many-to-Many relationship through OrderDetails(// Discuss whether to do it with has_many through or has_many_belongstomany )).
One User can have one Cart, and each Cart can have multiple CartItems (One-to-Many relationship).
One Product belongs to one Category, and one Category can have multiple Products (Many-to-One relationship).
