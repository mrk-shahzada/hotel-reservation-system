const express = require("express");
const cors = require("cors");
const mysql = require("mysql2/promise");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 5,
  ssl: process.env.DB_SSL === "true" ? { rejectUnauthorized: true } : undefined
});

app.get("/", (req, res) => {
  res.json({ message: "Hotel Reservation API is running" });
});

app.get("/api/rooms", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT
        r.room_id,
        r.room_number,
        r.capacity,
        r.status,
        COUNT(rg.guest_id) AS occupants
      FROM rooms r
      LEFT JOIN reservations rv ON rv.room_id = r.room_id
      LEFT JOIN reservation_guests rg ON rg.reservation_id = rv.reservation_id
      GROUP BY r.room_id, r.room_number, r.capacity, r.status
      ORDER BY r.room_number
    `);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Could not load rooms" });
  }
});

app.get("/api/reservations", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT
        rv.reservation_id,
        r.room_number,
        rv.days,
        rv.created_at,
        g.guest_id,
        g.name,
        g.father_name,
        g.phone,
        g.address,
        g.cnic
      FROM reservations rv
      JOIN rooms r ON r.room_id = rv.room_id
      JOIN reservation_guests rg ON rg.reservation_id = rv.reservation_id
      JOIN guests g ON g.guest_id = rg.guest_id
      ORDER BY rv.reservation_id DESC, g.guest_id
    `);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Could not load reservations" });
  }
});

app.post("/api/reservations", async (req, res) => {
  const { roomNumber, days, guests } = req.body;

  if (!Number.isInteger(Number(roomNumber)) ||
      !Number.isInteger(Number(days)) ||
      Number(days) <= 0 ||
      !Array.isArray(guests) ||
      guests.length !== 2) {
    return res.status(400).json({
      error: "roomNumber, positive days, and exactly two guests are required"
    });
  }

  for (const guest of guests) {
    if (!guest.name || !guest.fatherName || !guest.phone ||
        !guest.address || !guest.cnic) {
      return res.status(400).json({ error: "All guest fields are required" });
    }
  }

  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    const [roomRows] = await connection.query(
      "SELECT room_id, status FROM rooms WHERE room_number = ? FOR UPDATE",
      [roomNumber]
    );

    if (roomRows.length === 0) {
      await connection.rollback();
      return res.status(404).json({ error: "Room not found" });
    }

    if (roomRows[0].status !== "AVAILABLE") {
      await connection.rollback();
      return res.status(409).json({ error: "Room is already occupied" });
    }

    const roomId = roomRows[0].room_id;

    const [reservationResult] = await connection.query(
      "INSERT INTO reservations (room_id, days) VALUES (?, ?)",
      [roomId, days]
    );

    const reservationId = reservationResult.insertId;

    for (const guest of guests) {
      const [guestResult] = await connection.query(
        `INSERT INTO guests (name, father_name, phone, address, cnic)
         VALUES (?, ?, ?, ?, ?)`,
        [guest.name, guest.fatherName, guest.phone, guest.address, guest.cnic]
      );

      await connection.query(
        "INSERT INTO reservation_guests (reservation_id, guest_id) VALUES (?, ?)",
        [reservationId, guestResult.insertId]
      );
    }

    await connection.query(
      "UPDATE rooms SET status = 'OCCUPIED' WHERE room_id = ?",
      [roomId]
    );

    await connection.commit();

    res.status(201).json({
      message: "Reservation created successfully",
      reservationId,
      roomNumber,
      days
    });
  } catch (err) {
    await connection.rollback();
    console.error(err);
    res.status(500).json({ error: "Could not create reservation" });
  } finally {
    connection.release();
  }
});

app.patch("/api/rooms/:roomNumber/checkout", async (req, res) => {
  const roomNumber = Number(req.params.roomNumber);
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    const [roomRows] = await connection.query(
      "SELECT room_id FROM rooms WHERE room_number = ? FOR UPDATE",
      [roomNumber]
    );

    if (roomRows.length === 0) {
      await connection.rollback();
      return res.status(404).json({ error: "Room not found" });
    }

    const roomId = roomRows[0].room_id;

    const [reservationRows] = await connection.query(
      "SELECT reservation_id FROM reservations WHERE room_id = ? ORDER BY reservation_id DESC LIMIT 1",
      [roomId]
    );

    if (reservationRows.length > 0) {
      await connection.query(
        "DELETE FROM reservations WHERE reservation_id = ?",
        [reservationRows[0].reservation_id]
      );
    }

    await connection.query(
      "UPDATE rooms SET status = 'AVAILABLE' WHERE room_id = ?",
      [roomId]
    );

    await connection.commit();
    res.json({ message: `Room ${roomNumber} checked out successfully` });
  } catch (err) {
    await connection.rollback();
    console.error(err);
    res.status(500).json({ error: "Checkout failed" });
  } finally {
    connection.release();
  }
});

const PORT = Number(process.env.PORT || 3000);
app.listen(PORT, () => {
  console.log(`Hotel API running on port ${PORT}`);
});
