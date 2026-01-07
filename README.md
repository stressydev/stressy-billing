### 📄 Stressy Billing

A simple, lightweight billing system for FiveM using ox_lib, oxmysql, and a framework bridge supporting QBX, QB-Core, and ESX.

Players with allowed jobs can send bills to others, and players can view and pay their bills through an ox_lib context menu. Paid bills are deleted from the database.

## ✨ Features

- 🧾 Send bills to players by Player ID

- 💰 Supports cash & bank payments

- 📋 View bills using an ox_lib context menu

- ❌ Bills are deleted when paid

- 🔁 Menu refreshes automatically

- 🧠 Framework-agnostic (QBX / QB / ESX)

- 🗄️ Runtime database table creation

- ⚡ Lightweight and optimized

## 📦 Dependencies

# Required resources:

- ox_lib

- oxmysql

# One of the following frameworks:

- qbx_core

- qb-core

- es_extended

## 🛠 Installation

- Drop the resource into your resources folder.

- Ensure dependencies start before this resource.

- Add to your server.cfg:
```
    ensure ox_lib
    ensure oxmysql
    ensure stressy_billing
```

<img src="https://stressy.sirv.com/scripts/billing.png" width="482" height="619" alt="">