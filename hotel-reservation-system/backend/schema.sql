CREATE DATABASE IF NOT EXISTS hotel_db;
USE hotel_db;

CREATE TABLE IF NOT EXISTS rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number INT NOT NULL UNIQUE,
    capacity TINYINT NOT NULL DEFAULT 2,
    status ENUM('AVAILABLE','OCCUPIED') NOT NULL DEFAULT 'AVAILABLE'
);

CREATE TABLE IF NOT EXISTS guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    father_name VARCHAR(100) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    address VARCHAR(255) NOT NULL,
    cnic VARCHAR(25) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL,
    days INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reservation_room
        FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    CONSTRAINT chk_days CHECK (days > 0)
);

CREATE TABLE IF NOT EXISTS reservation_guests (
    reservation_id INT NOT NULL,
    guest_id INT NOT NULL,
    PRIMARY KEY (reservation_id, guest_id),
    CONSTRAINT fk_rg_reservation
        FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_rg_guest
        FOREIGN KEY (guest_id) REFERENCES guests(guest_id)
);

-- Create exactly 50 rooms: 101 through 150.
INSERT INTO rooms (room_number, capacity)
SELECT 101, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 101);
INSERT INTO rooms (room_number, capacity)
SELECT 102, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 102);
INSERT INTO rooms (room_number, capacity)
SELECT 103, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 103);
INSERT INTO rooms (room_number, capacity)
SELECT 104, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 104);
INSERT INTO rooms (room_number, capacity)
SELECT 105, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 105);
INSERT INTO rooms (room_number, capacity)
SELECT 106, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 106);
INSERT INTO rooms (room_number, capacity)
SELECT 107, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 107);
INSERT INTO rooms (room_number, capacity)
SELECT 108, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 108);
INSERT INTO rooms (room_number, capacity)
SELECT 109, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 109);
INSERT INTO rooms (room_number, capacity)
SELECT 110, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 110);
INSERT INTO rooms (room_number, capacity)
SELECT 111, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 111);
INSERT INTO rooms (room_number, capacity)
SELECT 112, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 112);
INSERT INTO rooms (room_number, capacity)
SELECT 113, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 113);
INSERT INTO rooms (room_number, capacity)
SELECT 114, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 114);
INSERT INTO rooms (room_number, capacity)
SELECT 115, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 115);
INSERT INTO rooms (room_number, capacity)
SELECT 116, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 116);
INSERT INTO rooms (room_number, capacity)
SELECT 117, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 117);
INSERT INTO rooms (room_number, capacity)
SELECT 118, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 118);
INSERT INTO rooms (room_number, capacity)
SELECT 119, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 119);
INSERT INTO rooms (room_number, capacity)
SELECT 120, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 120);
INSERT INTO rooms (room_number, capacity)
SELECT 121, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 121);
INSERT INTO rooms (room_number, capacity)
SELECT 122, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 122);
INSERT INTO rooms (room_number, capacity)
SELECT 123, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 123);
INSERT INTO rooms (room_number, capacity)
SELECT 124, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 124);
INSERT INTO rooms (room_number, capacity)
SELECT 125, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 125);
INSERT INTO rooms (room_number, capacity)
SELECT 126, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 126);
INSERT INTO rooms (room_number, capacity)
SELECT 127, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 127);
INSERT INTO rooms (room_number, capacity)
SELECT 128, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 128);
INSERT INTO rooms (room_number, capacity)
SELECT 129, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 129);
INSERT INTO rooms (room_number, capacity)
SELECT 130, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 130);
INSERT INTO rooms (room_number, capacity)
SELECT 131, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 131);
INSERT INTO rooms (room_number, capacity)
SELECT 132, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 132);
INSERT INTO rooms (room_number, capacity)
SELECT 133, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 133);
INSERT INTO rooms (room_number, capacity)
SELECT 134, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 134);
INSERT INTO rooms (room_number, capacity)
SELECT 135, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 135);
INSERT INTO rooms (room_number, capacity)
SELECT 136, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 136);
INSERT INTO rooms (room_number, capacity)
SELECT 137, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 137);
INSERT INTO rooms (room_number, capacity)
SELECT 138, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 138);
INSERT INTO rooms (room_number, capacity)
SELECT 139, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 139);
INSERT INTO rooms (room_number, capacity)
SELECT 140, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 140);
INSERT INTO rooms (room_number, capacity)
SELECT 141, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 141);
INSERT INTO rooms (room_number, capacity)
SELECT 142, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 142);
INSERT INTO rooms (room_number, capacity)
SELECT 143, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 143);
INSERT INTO rooms (room_number, capacity)
SELECT 144, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 144);
INSERT INTO rooms (room_number, capacity)
SELECT 145, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 145);
INSERT INTO rooms (room_number, capacity)
SELECT 146, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 146);
INSERT INTO rooms (room_number, capacity)
SELECT 147, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 147);
INSERT INTO rooms (room_number, capacity)
SELECT 148, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 148);
INSERT INTO rooms (room_number, capacity)
SELECT 149, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 149);
INSERT INTO rooms (room_number, capacity)
SELECT 150, 2 WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE room_number = 150);
