# Giao diện Web - Web Interface

## Giới thiệu

Dự án đã được nâng cấp với giao diện web HTML đầy đủ, thay thế cho việc sử dụng API trực tiếp qua curl. Giao diện được thiết kế với Bootstrap 5, responsive và user-friendly.

## Truy cập Giao diện Web

Sau khi khởi động dự án với `docker-compose up`, mở trình duyệt và truy cập:

```
http://localhost:5000
```

## Tính năng Giao diện Web

### 1. Dashboard / Trang chủ (`/`)

**URL:** `http://localhost:5000/`

**Tính năng:**
- Thống kê tổng quan hệ thống
  - Tổng số nhóm nghiên cứu
  - Tổng số nhân viên
  - Tổng số đề án
  - Tổng số tham gia
- Phân bổ nhóm theo phòng (P1 vs P2)
- Hiển thị số đề án chưa có nhân viên
- Thông tin kiến trúc hệ thống (3 databases)
- Menu thao tác nhanh
- Tự động refresh stats mỗi 30 giây

**Screenshot mô tả:**
```
┌─────────────────────────────────────────────────────┐
│  Hệ thống CSDL Phân Tán                             │
│  [Trang chủ] [Nhóm NC] [Nhân viên] [Đề án] [...]   │
└─────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────┐
│  📊 Thống kê Hệ thống                                │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐       │
│  │ Nhóm NC│ │Nhân viên│ │ Đề án │ │Tham gia│       │
│  │   4    │ │   8     │ │   9   │ │  15    │       │
│  └────────┘ └────────┘ └────────┘ └────────┘       │
└──────────────────────────────────────────────────────┘
```

### 2. Quản lý Nhóm Nghiên Cứu (`/web/nhomnc`)

**URL:** `http://localhost:5000/web/nhomnc`

**Tính năng:**
- ✅ Xem danh sách tất cả nhóm nghiên cứu
- ✅ Hiển thị site badge (P1 = Site1_DB, P2 = Site2_DB)
- ✅ Thêm nhóm mới (Modal popup)
- ✅ Sửa thông tin nhóm (Modal popup với warning về migration)
- ✅ Xóa nhóm (với confirm dialog)
- ✅ Tự động phân mảnh dữ liệu theo phòng
- ✅ Flash messages cho mọi thao tác

**Form Thêm Nhóm:**
```
┌────────────────────────────────────┐
│  ➕ Thêm Nhóm Nghiên Cứu Mới      │
├────────────────────────────────────┤
│  Mã Nhóm: [______] (bắt buộc)     │
│  Tên Nhóm: [__________________]   │
│  Phòng: [▼ P1/P2]                 │
│                                    │
│  ℹ️ Dữ liệu sẽ tự động lưu vào    │
│     đúng site                      │
│                                    │
│  [Hủy]  [💾 Lưu]                  │
└────────────────────────────────────┘
```

**Form Sửa Nhóm:**
```
┌────────────────────────────────────┐
│  ✏️ Cập nhật Nhóm Nghiên Cứu      │
├────────────────────────────────────┤
│  Mã Nhóm: [N01] (disabled)        │
│  Tên Nhóm: [__________________]   │
│  Phòng: [▼ P1/P2]                 │
│                                    │
│  ⚠️ Lưu ý: Nếu thay đổi phòng,   │
│  toàn bộ dữ liệu liên quan sẽ     │
│  được tự động di chuyển!           │
│                                    │
│  [Hủy]  [💾 Cập nhật]             │
└────────────────────────────────────┘
```

**Bảng Dữ liệu:**
| Mã Nhóm | Tên Nhóm | Phòng | Site | Thao tác |
|---------|----------|-------|------|----------|
| N01 | Nhóm Trí Tuệ Nhân Tạo | P1 | `Site1_DB` | ✏️ 🗑️ |
| N03 | Nhóm An Ninh Mạng | P2 | `Site2_DB` | ✏️ 🗑️ |

### 3. Truy vấn Đặc biệt (`/web/queries`)

**URL:** `http://localhost:5000/web/queries`

Trang này tích hợp tất cả 4 truy vấn đặc biệt trong một giao diện:

#### Form 1: Đề án có nhân viên từ nhóm khác tham gia

```
┌────────────────────────────────────────────────┐
│  1️⃣ Form 1: Đề án có nhân viên từ nhóm khác  │
├────────────────────────────────────────────────┤
│  Chọn Nhóm Nghiên Cứu:                        │
│  [▼ N01 - Nhóm Trí Tuệ Nhân Tạo (P1)]        │
│                                                │
│  [🔍 Tìm kiếm]                                │
├────────────────────────────────────────────────┤
│  Kết quả:                                      │
│  ┌──────────────────────────────────────────┐ │
│  │ MaDeAn | TenDeAn | Nhóm | NV | ...      │ │
│  │ DA002  | AI y tế | N01  | NV005 (N03)  │ │
│  └──────────────────────────────────────────┘ │
└────────────────────────────────────────────────┘
```

**Cách sử dụng:**
1. Chọn nhóm từ dropdown
2. Click "Tìm kiếm"
3. Kết quả hiển thị các đề án của nhóm đó có nhân viên từ nhóm khác tham gia

#### Form 2: Cập nhật phòng của nhóm

```
┌────────────────────────────────────────────────┐
│  2️⃣ Form 2: Cập nhật phòng của nhóm          │
├────────────────────────────────────────────────┤
│  Chọn Nhóm: [▼ N01 (Hiện tại: P1)]          │
│  Phòng Mới: [▼ P2]                           │
│                                                │
│  [↔️ Cập nhật Phòng]                         │
│                                                │
│  ℹ️ Toàn bộ dữ liệu liên quan sẽ được        │
│     tự động di chuyển sang site mới           │
└────────────────────────────────────────────────┘
```

#### Form 3: Đề án chưa có nhân viên

```
┌────────────────────────────────────────────────┐
│  3️⃣ Form 3: Đề án chưa có nhân viên tham gia│
├────────────────────────────────────────────────┤
│  [🔍 Tìm đề án chưa có nhân viên]            │
├────────────────────────────────────────────────┤
│  Kết quả: 🔴 1 đề án                          │
│  ┌──────────────────────────────────────────┐ │
│  │ DA009 | Blockchain giáo dục | 350M      │ │
│  └──────────────────────────────────────────┘ │
└────────────────────────────────────────────────┘
```

#### Form 4: Migration Demo (P1 → P2)

```
┌────────────────────────────────────────────────┐
│  4️⃣ Form 4: Chuyển nhóm từ P1 sang P2       │
│  (Demo Migration)                              │
├────────────────────────────────────────────────┤
│  ℹ️ Chức năng đặc biệt: Demo tự động di      │
│     chuyển toàn bộ dữ liệu từ Site1 sang      │
│     Site2 thông qua trigger                    │
│                                                │
│  Chọn Nhóm (P1): [▼ N01 - Trí tuệ NT]       │
│  [➡️ Chuyển P1 → P2]                         │
├────────────────────────────────────────────────┤
│  ✅ Migration thành công!                     │
│                                                │
│  Nhóm: N01 - Nhóm Trí Tuệ Nhân Tạo           │
│  Đã chuyển: P1 → P2                           │
│                                                │
│  Dữ liệu đã di chuyển:                        │
│  • Nhân viên: 2 người                         │
│  • Đề án: 2 đề án                             │
│  • Tham gia: 5 records                        │
│                                                │
│  ℹ️ Tự động di chuyển từ Site1_DB sang       │
│     Site2_DB qua trigger                       │
└────────────────────────────────────────────────┘
```

### 4. API Documentation (`/api`)

**URL:** `http://localhost:5000/api`

Endpoint JSON để xem danh sách tất cả API endpoints (giống như route `/` cũ).

## Thiết kế Giao diện

### Color Scheme

```css
Primary: Linear gradient(135deg, #667eea 0%, #764ba2 100%)
Background: Linear gradient(135deg, #667eea 0%, #764ba2 100%)
Cards: White với box-shadow
P1 Badge: Light blue (#d1ecf1)
P2 Badge: Light red (#f8d7da)
```

### Typography

- Font: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif
- Headers: Font-weight 600
- Body: Regular

### Components

- **Navbar:** Sticky top với backdrop-filter blur
- **Cards:** Rounded corners (15px), hover effects
- **Buttons:** Rounded (8px), gradient backgrounds, hover lift
- **Forms:** Rounded inputs (8px), focus glow effect
- **Tables:** Hover rows, gradient header
- **Alerts:** Auto-dismiss sau 5 giây
- **Modals:** Bootstrap 5 modal với custom styling

### Responsive Design

- Mobile-first approach
- Breakpoints:
  - xs: < 576px
  - sm: ≥ 576px
  - md: ≥ 768px
  - lg: ≥ 992px
  - xl: ≥ 1200px

## Icons

Sử dụng Bootstrap Icons:
- `bi-database-fill`: Database
- `bi-people-fill`: Groups
- `bi-person-fill`: Employee
- `bi-folder-fill`: Project
- `bi-link-45deg`: Participation
- `bi-search`: Search/Query
- `bi-plus-circle`: Add
- `bi-pencil`: Edit
- `bi-trash`: Delete

## User Experience Features

### 1. Flash Messages

Mọi thao tác đều có feedback:
- ✅ Success: Green alert
- ⚠️ Warning: Yellow alert
- ❌ Error: Red alert
- ℹ️ Info: Blue alert

Auto-dismiss sau 5 giây.

### 2. Confirm Dialogs

Các thao tác nguy hiểm (DELETE) có confirm dialog:
```javascript
"Bạn có chắc muốn xóa nhóm nghiên cứu 'N01'?
Hành động này không thể hoàn tác."
[Hủy] [Xóa]
```

### 3. Form Validation

- Client-side validation với HTML5
- Required fields marked với `*`
- Server-side validation với error messages

### 4. Loading States

- Loading spinner cho các thao tác dài
- Disabled buttons khi đang xử lý

### 5. Empty States

- Hiển thị thông báo khi không có dữ liệu
- Icon và text gợi ý thao tác tiếp theo

## Navigation Flow

```
┌─────────────┐
│  Dashboard  │ ← Landing page
└──────┬──────┘
       │
       ├─→ Nhóm NC ────→ [Thêm/Sửa/Xóa Modal]
       │
       ├─→ Nhân viên ──→ [Coming soon - sử dụng API]
       │
       ├─→ Đề án ──────→ [Coming soon - sử dụng API]
       │
       ├─→ Tham gia ───→ [Coming soon - sử dụng API]
       │
       ├─→ Truy vấn ───→ [Form 1-4]
       │
       └─→ API ─────────→ [JSON Documentation]
```

## Keyboard Shortcuts (Planned)

- `Ctrl+N`: Thêm mới
- `Ctrl+S`: Lưu
- `Esc`: Đóng modal
- `/`: Focus vào search

## Accessibility

- Semantic HTML
- ARIA labels
- Keyboard navigation
- Screen reader friendly
- High contrast mode support

## Browser Support

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ⚠️ IE 11 (Limited support)

## Performance

- Minified CSS/JS
- CDN for Bootstrap và jQuery
- Lazy loading cho images
- Optimized database queries
- 30s stats refresh interval

## Security

- CSRF protection (Flask secret_key)
- SQL injection prevention (parameterized queries)
- XSS prevention (template escaping)
- Input sanitization

## Future Enhancements

### Phase 2 (Planned)
- [ ] Complete CRUD pages cho Nhân viên
- [ ] Complete CRUD pages cho Đề án
- [ ] Complete CRUD pages cho Tham gia
- [ ] Advanced search và filters
- [ ] Export data (CSV, Excel, PDF)
- [ ] Import data từ file
- [ ] User authentication & authorization
- [ ] Role-based access control
- [ ] Audit log
- [ ] Dark mode toggle

### Phase 3 (Future)
- [ ] Charts và visualizations (Chart.js)
- [ ] Real-time updates (WebSocket)
- [ ] Notification system
- [ ] Advanced reporting
- [ ] Multi-language support
- [ ] API rate limiting
- [ ] Caching layer
- [ ] Progressive Web App (PWA)

## Troubleshooting

### Giao diện không hiển thị CSS
**Giải pháp:**
- Kiểm tra kết nối internet (Bootstrap từ CDN)
- Hard refresh: Ctrl+F5
- Xóa cache trình duyệt

### Form submit không hoạt động
**Giải pháp:**
- Kiểm tra console log (F12)
- Kiểm tra Flask app đang chạy
- Kiểm tra database connection

### Modal không đóng
**Giải pháp:**
- Refresh page
- Kiểm tra jQuery loaded
- Kiểm tra Bootstrap JS loaded

## Screenshots

Để xem screenshots thực tế, truy cập các URL sau khi chạy project:

1. **Dashboard:** `http://localhost:5000/`
2. **Nhóm NC:** `http://localhost:5000/web/nhomnc`
3. **Truy vấn:** `http://localhost:5000/web/queries`

## Development Notes

### File Structure
```
app/
├── app.py                  # Flask routes
├── templates/
│   ├── base.html          # Base template
│   ├── index.html         # Dashboard
│   ├── nhomnc.html        # Groups management
│   └── queries.html       # Special queries
└── static/ (future)
    ├── css/
    ├── js/
    └── images/
```

### Adding New Pages

1. Create template in `app/templates/`
2. Add route in `app.py`
3. Update navigation in `base.html`
4. Test functionality
5. Update documentation

### Customizing Styles

Edit the `<style>` section in `base.html` hoặc tạo file CSS riêng trong `app/static/css/`.

---

**Enjoy the beautiful web interface! 🎨✨**
