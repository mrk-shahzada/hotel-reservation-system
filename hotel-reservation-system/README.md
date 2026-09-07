# Hotel Reservation System — Kotlin + Node.js + MySQL

A teaching/MVP project for a 50-room hotel. Every reservation registers exactly two guests.

## Architecture

Kotlin Android app -> HTTP/JSON -> Node.js/Express REST API -> MySQL

## Backend local setup

1. Install Node.js.
2. Create a MySQL database and run `backend/schema.sql`.
3. Copy `backend/.env.example` to `backend/.env`.
4. Put your MySQL credentials in `.env`.
5. From `backend/` run:
   - `npm install`
   - `npm run dev`
6. Test:
   - `GET http://localhost:3000/`
   - `GET http://localhost:3000/api/rooms`

## Android local setup

Open the `android/` directory in Android Studio.

For the Android emulator, the backend on your computer is reached through:
`http://10.0.2.2:3000/`

For a physical phone, use your computer's LAN IP instead, for example:
`http://192.168.1.10:3000/`

After deploying the API, replace `API_BASE_URL` in `MainActivity.kt` with the HTTPS deployment URL.

## API

GET `/api/rooms`
POST `/api/reservations`
PATCH `/api/rooms/:roomNumber/checkout`

POST example:

{
  "roomNumber": 101,
  "days": 3,
  "guests": [
    {
      "name": "Demo Guest One",
      "fatherName": "Demo Father One",
      "phone": "03000000000",
      "address": "Demo Address",
      "cnic": "00000-0000000-0"
    },
    {
      "name": "Demo Guest Two",
      "fatherName": "Demo Father Two",
      "phone": "03111111111",
      "address": "Demo Address",
      "cnic": "11111-1111111-1"
    }
  ]
}

## Deployment

Recommended simple free demo architecture:
- Node.js API: Vercel
- MySQL: Aiven free MySQL
- Android APK: build locally with Android Studio

Do not commit `.env` or real CNIC data.

## Teaching map

Kotlin:
- data class = data model
- object = instance created from a class/data class
- interface `HotelApi` = API contract
- Retrofit = HTTP client
- `List<Room>` = collection/data structure
- coroutines = asynchronous network calls

Node.js:
- Express app = HTTP server
- routes = API endpoints
- controller logic = validation/business logic
- mysql2 = MySQL driver
- transaction = all reservation inserts succeed together or are rolled back

MySQL:
- tables = structured persistent storage
- primary keys = unique record identifiers
- foreign keys = relationships
- SQL = language used by backend to query/update database
