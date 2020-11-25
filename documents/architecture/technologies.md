# Document Purpose
 
This document contains the description and the reason behind this project's technology choices.

# Frontend

As stated in the [Lepic Project Proposal](https://docs.google.com/document/d/1G6QDAHeg57RUrg7Ormm1C21lwNI5f1crjdSHH5iTV4U/edit), the application must be written using the [**Flutter Framework**](https://flutter.dev/). Even though it's a requisite, our team agrees with the choice, as the framework facilitates the work to build both iOS and Android apps with virtually the same codebase.

![flutter](https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png)

Further details about the architecture and design of our flutter app will be discussed in the documents to come.

# Backend

In the same way as the frontend, the [Lepic Project Proposal](https://docs.google.com/document/d/1G6QDAHeg57RUrg7Ormm1C21lwNI5f1crjdSHH5iTV4U/edit) states that the backend must be built using [**Django**](https://www.djangoproject.com/) and Python. 

![django](https://www.djangoproject.com/m/img/logos/django-logo-negative.png)

## Database

At the time of writing, Django supports the following databases ([documentation](https://docs.djangoproject.com/en/3.1/ref/databases/)):

- PostgreSQL
- MariaDB
- MySQL
- ~~Oracle~~ (paid)
- SQLite

By laying down these options, as well as the application data aspects and usage, this document will arrive at an appropriate database solution.

### Data

The next table is a summary of a few data that our application will store.

| Type     | Description |
| -------- | ------------------ |
| Class    | A class is described by its `Name` (text), `Level`, unique `ID`, and an assigned `Teacher` (who is also a user). A class is also filled with `Student`s that have their own data. |
| User     | A user has a `Name` (text), `Role` (Excluding option, defining his permissions and access), `ID`, and other user-related fields, like his `Picture` (image) and `Email`. |
| TextTask  | `Student`s can be assigned multiple tasks, where a `Text` is designated for them to read. `Recording`s (audio) can also be stored. |

> This is highly subject to change!

As our application will have varying levels of access, the lack of multi-user capabilities and serialized operations is a major drawback for the SQLite database.

In the end, there are three **relational** databases left:

- PostgreSQL
- MariaDB
- MySQL

As our application scale isn't large, complex features and use cases are not being taken into consideration. These databases are highly used and provide enough features and specifications to fulfill our application needs.

The choice comes down to preference, and **PostgreSQL** is our selected database. It is hugely used in the Django community, increasing the support and documentation available for it.

![postgresql](https://i0.wp.com/www.computersnyou.com/wp-content/uploads/2014/12/postgresql-logo.png?fit=610%2C280&ssl=1)

# Server Hosting

To be discussed.
