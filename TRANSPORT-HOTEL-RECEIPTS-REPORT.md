# Transport & Hotel Receipt Upload — Completion Report
**Date:** 2026-03-01
**Git Tag:** `v7.1-transport-hotel-receipts-2026-03-01`
**Latest Commit:** `dc938b3`
**Rollback Tag:** `v7.0-phone-benefit-2026-03-01`

---

## Features Delivered

### 1. Transport Receipt Uploads (Trip Tab)
- **Multi-page capture**: Each transport mode (Flight, Train, Bus, Rental, Taxi) has a "📷 Add Receipt Page" button
- **One-at-a-time capture**: Hidden file input + styled button — take a photo, it appends to the list, button updates to "📷 + Add Another Page (N added)"
- **Client-side compression**: All images compressed via `compressFiles()` (1200px max, JPEG 0.7 quality)
- **File list with remove**: Each page shown as "Page 1: filename (size KB)" with ❌ remove button
- **Backend storage**: `transport_receipts` table (trip_id, transport_mode, BLOB, file_name, file_type, file_size, upload_order)
- **Upload on submission**: All receipts uploaded during `tdpDoSubmitTrip()`
- **Existing receipts loaded**: When re-opening a trip, previously uploaded receipts display as clickable links

### 2. Hotel Receipt Uploads (Trip Tab)
- **Same multi-page UX**: "📷 Add Receipt Page" button per hotel entry
- **Compression**: Same `compressFiles()` pipeline
- **Append model**: Each capture adds to the list, never replaces
- **Storage**: Uses `transport_receipts` table with mode `hotel_0`, `hotel_1`, etc.
- **First page also stored as expense receipt** for PDF embedding compatibility

### 3. Bug Fixes
- **Transport button selector bug**: 5 unscoped `[data-mode]` selectors were matching wrong form's buttons — all scoped to `#tdp-transport-toggles`
- **Null section crash**: `tdpToggleTransport` crashed on modes without a section element (e.g., personal) — added null checks
- **Wrong save function**: `tdpToggleTransport` was calling `dpSaveTransport()` instead of `saveTdpTransport()` — fixed
- **Scroll-to-top on receipt add**: `showMessage()` toasts caused browser to scroll up — removed from receipt handlers

---

## Database Schema

### transport_receipts (NEW)
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PK | Auto-increment |
| trip_id | INTEGER FK | References trips(id) ON DELETE CASCADE |
| transport_mode | TEXT | flight, train, bus, rental, taxi, hotel_0, hotel_1, etc. |
| file_data | BLOB | Compressed image/PDF data |
| file_name | TEXT | Original filename |
| file_type | TEXT | MIME type |
| file_size | INTEGER | File size in bytes |
| upload_order | INTEGER | Order within mode (1-based) |
| created_at | DATETIME | Auto timestamp |

---

## API Endpoints (NEW)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/trips/:id/transport-receipts` | Employee | Upload receipts (FormData: mode + receipts[]) |
| GET | `/api/trips/:id/transport-receipts` | Employee | List receipts (optional ?mode= filter) |
| GET | `/api/transport-receipts/:receiptId` | Employee | Download single receipt file |

---

## Frontend Functions (NEW/MODIFIED)

### Transport Receipts
| Function | Description |
|----------|-------------|
| `tdpTransportReceiptChanged(mode)` | Handles file selection, compresses, appends to list |
| `tdpRenderTransportReceiptList(mode)` | Renders file list with page numbers + remove buttons |
| `tdpRemoveTransportReceipt(mode, index)` | Removes a file from the list |
| `tdpUploadTransportReceipts(tripId)` | Uploads all transport receipts to server |
| `tdpLoadExistingTransportReceipts(tripId)` | Loads previously uploaded receipts as clickable links |

### Hotel Receipts (MODIFIED)
| Function | Description |
|----------|-------------|
| `tdpHotelReceiptChanged(idx)` | Now compresses + appends (was replace-only) |
| `tdpRenderHotelReceiptList(idx)` | New — renders page list with remove buttons |
| `tdpRemoveHotelReceipt(hotelIdx, fileIdx)` | New — removes a page from hotel receipt list |

---

## Backup Files
- `app.js.backup-transport-receipts-20260301`
- `employee-dashboard.html.backup-transport-receipts-20260301`
- `admin.html.backup-transport-receipts-20260301`

## Commits in This Release
1. `b03eb22` — Fix transport button selectors - scope to correct form container
2. `637b9f4` — Add multi-file transport receipt uploads with compression
3. `b990822` — UX: one-at-a-time receipt capture with Add Another Page button
4. `d38461d` — Hotel receipts: multi-page capture with compression
5. `dc938b3` — Remove showMessage toasts to prevent scroll-to-top
