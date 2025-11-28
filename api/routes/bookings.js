// ============================================================
// BOOKINGS API - Backend Routes
// ============================================================
const express = require("express");
const router = express.Router();

/* ============================================================
   CREATE NEW BOOKING
   POST /api/bookings/create
   ============================================================ */
router.post("/create", async (req, res) => {
    try {
        const { 
            customer_id, 
            package_id, 
            event_date, 
            event_time, 
            location,
            custom_layout,
            has_custom_layout,
            base_price,
            total_price,
            notes
        } = req.body;

        // Validation
        if (!customer_id || !package_id || !event_date || !event_time || !location) {
            return res.status(400).json({
                status: "error",
                message: "customer_id, package_id, event_date, event_time, and location are required"
            });
        }

        const sql = `
            INSERT INTO bookings (
                customer_id, package_id, event_date, event_time, location,
                custom_layout, has_custom_layout, base_price, total_price, 
                notes, status, payment_status
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', 'unpaid')
        `;

        const [result] = await global.db.query(sql, [
            customer_id,
            package_id,
            event_date,
            event_time,
            location,
            custom_layout || null,
            has_custom_layout || false,
            base_price || 0,
            total_price || 0,
            notes || null
        ]);

        return res.status(201).json({
            status: "success",
            message: "Booking created successfully",
            booking_id: result.insertId
        });

    } catch (err) {
        console.error("Create booking error:", err);
        return res.status(500).json({
            status: "error",
            message: "Server error creating booking: " + err.message
        });
    }
});

/* ============================================================
   GET CUSTOMER'S BOOKINGS
   GET /api/bookings/customer/:customer_id
   ============================================================ */
router.get("/customer/:customer_id", async (req, res) => {
    try {
        const { customer_id } = req.params;

        const sql = `
            SELECT 
                b.*,
                p.Package_Name,
                p.Description as package_description,
                p.Package_Amount as package_base_price
            FROM bookings b
            LEFT JOIN package p ON b.package_id = p.Package_ID
            WHERE b.customer_id = ?
            ORDER BY b.created_at DESC
        `;

        const [rows] = await global.db.query(sql, [customer_id]);

        return res.json({
            status: "success",
            bookings: rows
        });

    } catch (err) {
        console.error("Get customer bookings error:", err);
        return res.status(500).json({
            status: "error",
            message: "Server error: " + err.message
        });
    }
});

/* ============================================================
   GET ALL BOOKINGS (Designer/Admin View)
   GET /api/bookings/all?status=pending
   ============================================================ */
router.get("/all", async (req, res) => {
    try {
        const { status, payment_status } = req.query;
        
        let sql = `
            SELECT 
                b.*,
                p.Package_Name,
                p.Description as package_description,
                c.Firstname as customer_firstname,
                c.Lastname as customer_lastname,
                c.Email as customer_email,
                c.PhoneNumber as customer_phone
            FROM bookings b
            LEFT JOIN package p ON b.package_id = p.Package_ID
            LEFT JOIN account c ON b.customer_id = c.Account_ID
            WHERE 1=1
        `;

        const params = [];

        if (status) {
            sql += ` AND b.status = ?`;
            params.push(status);
        }

        if (payment_status) {
            sql += ` AND b.payment_status = ?`;
            params.push(payment_status);
        }

        sql += ` ORDER BY b.created_at DESC`;

        const [rows] = await global.db.query(sql, params);

        return res.json({
            status: "success",
            bookings: rows
        });

    } catch (err) {
        console.error("Get all bookings error:", err);
        return res.status(500).json({
            status: "error",
            message: "Server error: " + err.message
        });
    }
});

/* ============================================================
   GET SINGLE BOOKING DETAILS
   GET /api/bookings/:booking_id
   ============================================================ */
router.get("/:booking_id", async (req, res) => {
    try {
        const { booking_id } = req.params;

        const sql = `
            SELECT 
                b.*,
                p.Package_Name,
                p.Description as package_description,
                p.Package_Amount as package_base_price,
                p.NumTables,
                p.NumRoundTables,
                p.NumChairs,
                p.NumTent,
                p.NumPlatform,
                c.Firstname as customer_firstname,
                c.Lastname as customer_lastname,
                c.Email as customer_email,
                c.PhoneNumber as customer_phone
            FROM bookings b
            LEFT JOIN package p ON b.package_id = p.Package_ID
            LEFT JOIN account c ON b.customer_id = c.Account_ID
            WHERE b.booking_id = ?
        `;

        const [rows] = await global.db.query(sql, [booking_id]);

        if (rows.length === 0) {
            return res.status(404).json({
                status: "error",
                message: "Booking not found"
            });
        }

        return res.json({
            status: "success",
            booking: rows[0]
        });

    } catch (err) {
        console.error("Get booking error:", err);
        return res.status(500).json({
            status: "error",
            message: "Server error: " + err.message
        });
    }
});

/* ============================================================
   UPDATE BOOKING STATUS
   PATCH /api/bookings/:booking_id/status
   ============================================================ */
router.patch("/:booking_id/status", async (req, res) => {
    try {
        const { booking_id } = req.params;
        const { status } = req.body;

        if (!status) {
            return res.status(400).json({
                status: "error",
                message: "status is required"
            });
        }

        const sql = `UPDATE bookings SET status = ?, updated_at = NOW() WHERE booking_id = ?`;
        await global.db.query(sql, [status, booking_id]);

        return res.json({
            status: "success",
            message: "Booking status updated successfully"
        });

    } catch (err) {
        console.error("Update booking status error:", err);
        return res.status(500).json({
            status: "error",
            message: "Server error: " + err.message
        });
    }
});

/* ============================================================
   UPDATE PAYMENT STATUS
   PATCH /api/bookings/:booking_id/payment
   ============================================================ */
router.patch("/:booking_id/payment", async (req, res) => {
    try {
        const { booking_id } = req.params;
        const { payment_status } = req.body;

        if (!payment_status) {
            return res.status(400).json({
                status: "error",
                message: "payment_status is required"
            });
        }

        const sql = `UPDATE bookings SET payment_status = ?, updated_at = NOW() WHERE booking_id = ?`;
        await global.db.query(sql, [payment_status, booking_id]);

        return res.json({
            status: "success",
            message: "Payment status updated successfully"
        });

    } catch (err) {
        console.error("Update payment status error:", err);
        return res.status(500).json({
            status: "error",
            message: "Server error: " + err.message
        });
    }
});

/* ============================================================
   UPDATE BOOKING
   PUT /api/bookings/:booking_id
   ============================================================ */
router.put("/:booking_id", async (req, res) => {
    try {
        const { booking_id } = req.params;
        const { 
            event_date, 
            event_time, 
            location,
            custom_layout,
            has_custom_layout,
            notes
        } = req.body;

        const sql = `
            UPDATE bookings 
            SET event_date = ?, event_time = ?, location = ?,
                custom_layout = ?, has_custom_layout = ?, notes = ?,
                updated_at = NOW()
            WHERE booking_id = ?
        `;

        await global.db.query(sql, [
            event_date,
            event_time,
            location,
            custom_layout || null,
            has_custom_layout || false,
            notes || null,
            booking_id
        ]);

        return res.json({
            status: "success",
            message: "Booking updated successfully"
        });

    } catch (err) {
        console.error("Update booking error:", err);
        return res.status(500).json({
            status: "error",
            message: "Server error: " + err.message
        });
    }
});

/* ============================================================
   DELETE BOOKING
   DELETE /api/bookings/:booking_id
   ============================================================ */
router.delete("/:booking_id", async (req, res) => {
    try {
        const { booking_id } = req.params;

        const [result] = await global.db.query("DELETE FROM bookings WHERE booking_id = ?", [booking_id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                status: "error",
                message: "Booking not found"
            });
        }

        return res.json({
            status: "success",
            message: "Booking deleted successfully"
        });

    } catch (err) {
        console.error("Delete booking error:", err);
        return res.status(500).json({
            status: "error",
            message: "Server error: " + err.message
        });
    }
});

module.exports = router;
