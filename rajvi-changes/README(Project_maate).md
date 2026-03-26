# Dream Dwellings Real Estate - Project Documentation

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Tech Stack](#tech-stack)
4. [API Endpoints](#api-endpoints)
5. [Database Schema](#database-schema)
6. [How It Works](#how-it-works)
7. [Quick Start](#quick-start)
8. [Configuration](#configuration)
9. [Key Features](#key-features)

---

## 1. Project Overview

**Dream Dwellings** is a full-stack Real Estate Management System with three connected applications:

| Application             | Description            | Port |
| ----------------------- | ---------------------- | ---- |
| **RealEstate_Api**      | RESTful Backend API    | 5250 |
| **RealEstate_Admin**    | Admin Dashboard (MVC)  | 5021 |
| **RealEstate_Frontend** | Customer Website (MVC) | 5133 |

---

## 2. Architecture

```
                    ┌─────────────────────────────────────────┐
                    │         BROWSER / CLIENT               │
                    └───────────────┬─────────────────────────┘
                                    │
            ┌───────────────────────┼───────────────────────┐
            │                       │                       │
            ▼                       ▼                       ▼
┌─────────────────────┐   ┌─────────────────────┐   ┌─────────────────────┐
│  RealEstate_Frontend│   │  RealEstate_Admin  │   │    Swagger API     │
│   (Customer Site)   │   │   (Dashboard)      │   │   (Documentation)  │
└─────────┬───────────┘   └─────────┬───────────┘   └─────────┬───────────┘
          │                         │                       │
          │            ┌────────────┴────────────┐        │
          │            │                        │        │
          └────────────┼────────────────────────┼────────┘
                       ▼
              ┌─────────────────────────┐
              │   RealEstate_Api      │
              │  (ASP.NET Core Web    │
              │       API)            │
              └───────────┬───────────┘
                          │
                          ▼
              ┌─────────────────────────┐
              │    SQL Server         │
              │  PRIT-LEGION\        │
              │   SQLEXPRESS          │
              │    RealEstate         │
              └───────────────────────┘
```

---

## 3. Tech Stack

| Layer               | Technology                                 |
| ------------------- | ------------------------------------------ |
| **Frontend**        | ASP.NET Core MVC, Bootstrap 5, HTML5, CSS3 |
| **Backend**         | ASP.NET Core Web API                       |
| **Database**        | Microsoft SQL Server                       |
| **ORM**             | ADO.NET (SqlClient)                        |
| **Session**         | In-Memory Cache + Session                  |
| **Background Jobs** | Hangfire (Email scheduling)                |
| **API Docs**        | Swagger / Swashbuckle                      |

---

## 4. API Endpoints

### 4.1 Property Endpoints

| Method | Endpoint                                         | Description                            |
| ------ | ------------------------------------------------ | -------------------------------------- |
| GET    | `/api/Property`                                  | Get all properties                     |
| GET    | `/api/Property/{id}`                             | Get property by ID                     |
| GET    | `/api/Property/category/{category}`              | Get properties by category (Sell/Rent) |
| GET    | `/api/Property/propertytype/{type}`              | Get properties by type                 |
| GET    | `/api/Property/filter?category=X&propertyType=Y` | Filter properties                      |
| POST   | `/api/Property`                                  | Create new property                    |
| PUT    | `/api/Property/{id}`                             | Update property                        |
| DELETE | `/api/Property/{id}`                             | Delete property                        |
| DELETE | `/api/Property/image/{imageId}`                  | Delete property image                  |

### 4.2 User Endpoints

| Method | Endpoint             | Description       |
| ------ | -------------------- | ----------------- |
| GET    | `/api/User`          | Get all users     |
| GET    | `/api/User/{id}`     | Get user by ID    |
| POST   | `/api/User/login`    | User login        |
| POST   | `/api/User/register` | Register new user |

### 4.3 Agent Endpoints

| Method | Endpoint          | Description      |
| ------ | ----------------- | ---------------- |
| GET    | `/api/Agent`      | Get all agents   |
| GET    | `/api/Agent/{id}` | Get agent by ID  |
| POST   | `/api/Agent`      | Create new agent |
| PUT    | `/api/Agent/{id}` | Update agent     |
| DELETE | `/api/Agent/{id}` | Delete agent     |

### 4.4 Property Type Endpoints

| Method | Endpoint            | Description            |
| ------ | ------------------- | ---------------------- |
| GET    | `/api/PropertyType` | Get all property types |

### 4.5 Appointment Endpoints

| Method | Endpoint                       | Description          |
| ------ | ------------------------------ | -------------------- |
| GET    | `/api/Appointment`             | Get all appointments |
| POST   | `/api/Appointment`             | Create appointment   |
| PUT    | `/api/Appointment/status/{id}` | Update status        |

### 4.6 Feedback Endpoints

| Method | Endpoint         | Description      |
| ------ | ---------------- | ---------------- |
| GET    | `/api/ContactUs` | Get all feedback |
| POST   | `/api/ContactUs` | Submit feedback  |

---

## 5. Database Schema

### 5.1 Tables

```
┌──────────────────┐     ┌──────────────────┐
│      Users       │     │     Agents       │
├──────────────────┤     ├──────────────────┤
│ UserId (PK)      │     │ AgentId (PK)     │
│ UserName         │     │ AgentName        │
│ Email            │     │ LicenseNumber    │
│ Password         │     │ ExperienceYears  │
│ Role             │     │ ContactNumber    │
└──────────────────┘     │ OfficeAddress    │
                         │ Status           │
                         └──────────────────┘

┌──────────────────┐     ┌──────────────────┐
│  PropertyTypes   │     │   Properties    │
├──────────────────┤     ├──────────────────┤
│ PropertyTypeId(PK)│◄──►│ PropertyId (PK) │
│ PropertyType     │     │ Title           │
└──────────────────┘     │ Description     │
                         │ PropertyTypeId(FK)
                         │ Category        │
                         │ Price           │
                         │ Location        │
                         │ Status          │
                         └────────┬────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │  PropertyImages │
                         ├──────────────────┤
                         │ ImageId (PK)    │
                         │ PropertyId (FK) │
                         │ ImageName       │
                         │ ImagePath       │
                         │ IsPrimary       │
                         │ DisplayOrder    │
                         └──────────────────┘
```

### 5.2 Key Tables

| Table                  | Purpose                                       |
| ---------------------- | --------------------------------------------- |
| **Users**              | User accounts (Admin/Buyer/Seller/User roles) |
| **Properties**         | Property listings with details                |
| **PropertyImages**     | Multiple images per property                  |
| **PropertyTypes**      | House, Apartment, Commercial                  |
| **Agents**             | Real estate agents                            |
| **Appointments**       | User appointment bookings                     |
| **Feedback/ContactUs** | User inquiries                                |

---

## 6. How It Works

### 6.1 Property Management Flow

```
1. Admin logs in → Dashboard
2. Navigate to Property → Add Property
3. Fill form (Title, Price, Location, etc.)
4. Upload multiple images
5. Submit → API receives data
6. API saves property + images to DB
7. Images saved to wwwroot/images/property/
8. API serves images via /images endpoint
9. Frontend displays via API URLs
```

### 6.2 Image Management

```
Images stored in: RealEstate_Admin/wwwroot/images/property/

API serves: http://localhost:5250/images/property/xxx.jpg

Database stores: /images/property/xxx.jpg

API converts to: http://localhost:5250/images/property/xxx.jpg
```

### 6.3 User Roles & Permissions

| Role       | Access                               |
| ---------- | ------------------------------------ |
| **Admin**  | Full dashboard, CRUD all             |
| **Buyer**  | Browse properties, book appointments |
| **Seller** | List properties                      |
| **User**   | General access                       |

---

## 7. Quick Start

### 7.1 Prerequisites

- .NET 8.0 SDK
- SQL Server (PRIT-LEGION)
- Visual Studio 2022 or VS Code

### 7.2 Setup

```bash
# 1. Clone project
git clone <repo-url>
cd Rajvi_DreamDwellings

# 2. Create Database
sqlcmd -S PRIT-LEGION -E -Q "CREATE DATABASE RealEstate"
sqlcmd -S PRIT-LEGION -d RealEstate -E -i RealEstateDB_Clean.sql

# 3. Run API
dotnet run --project RealEstate_Api

# 4. Run Admin (new terminal)
dotnet run --project RealEstate_Admin

# 5. Run Frontend (new terminal)
dotnet run --project RealEstate_Frontend
```

### 7.3 Access Points

| App      | URL                   | Credentials                         |
| -------- | --------------------- | ----------------------------------- |
| API      | http://localhost:5250 | -                                   |
| Admin    | http://localhost:5021 | admin@dreamdwellings.com / admin123 |
| Frontend | http://localhost:5133 | Same as admin                       |

---

## 8. Configuration

### 8.1 Connection String

All projects use this connection format:

```json
{
  "ConnectionStrings": {
    "ConnectionString": "Data Source=PRIT-LEGION;Initial Catalog=RealEstate;Integrated Security=true;TrustServerCertificate=True"
  }
}
```

### 8.2 API Configuration

```json
{
  "AppSettings": {
    "ApiBaseUrl": "http://localhost:5250",
    "ApiImageUrl": "http://localhost:5250/images"
  }
}
```

### 8.3 Email Settings

```json
{
  "EmailSettings": {
    "MailServer": "smtp.gmail.com",
    "MailPort": 587,
    "FromEmail": "adesararajvi912@gmail.com"
  }
}
```

---

## 9. Key Features

### ✅ Complete Features

- [x] User Authentication (Session-based)
- [x] Property CRUD with Multiple Images
- [x] Image Upload/Remove/Set Primary
- [x] Agent Management
- [x] Property Categories (Buy/Rent/Sell)
- [x] Property Types (House/Apartment/Commercial)
- [x] Status Management (Available/Sold/Pending)
- [x] Appointment Booking
- [x] Contact/Feedback Forms
- [x] Dashboard with Stats
- [x] Search & Filter Properties
- [x] Email Notifications (via Hangfire)

### 🎨 UI/UX Features

- [x] Modern Card-based Property List
- [x] Modern Card-based Agent List
- [x] Image Gallery in Add/Edit Form
- [x] Category & Status Badge Filters
- [x] Search Functionality
- [x] Responsive Design
- [x] Toast Notifications

---

## 📞 Support

For issues or questions, check:

1. CHANGES_LOG.md - All modifications documented
2. RealEstateDB_Clean.sql - Run this for fresh setup

---

_Last Updated: 2026-03-26_
_Dream Dwellings Real Estate Management System_
