# Hệ thống Quản lý Nhóm Nghiên Cứu và Đề Án Khoa Học - Cơ Sở Dữ Liệu Phân Tán

Dự án mô phỏng hệ thống cơ sở dữ liệu phân tán cho quản lý nhóm nghiên cứu và đề án khoa học sử dụng Docker, SQL Server và Python Flask.

## 🌐 Giao diện Web (NEW!)

Dự án hiện có giao diện web HTML đầy đủ với Bootstrap 5! Không cần dùng curl hay Postman nữa.

**Truy cập:** Sau khi chạy `docker-compose up`, mở trình duyệt:
```
http://localhost:5000
```

**Tính năng Web:**
- ✨ Dashboard với thống kê real-time
- 📊 Quản lý nhóm nghiên cứu (CRUD đầy đủ)
- 🔍 4 truy vấn đặc biệt với giao diện form
- 🎨 Thiết kế đẹp mắt, responsive
- ⚡ Flash messages và confirm dialogs
- 📱 Mobile-friendly

👉 **Xem chi tiết:** [WEB_INTERFACE.md](WEB_INTERFACE.md)

## Kiến trúc Hệ thống

### Cơ sở dữ liệu
- **Site1_DB**: Chứa dữ liệu cho các nhóm nghiên cứu thuộc phòng P1
- **Site2_DB**: Chứa dữ liệu cho các nhóm nghiên cứu thuộc phòng P2
- **Global_DB**: Chứa các view toàn cục và trigger để định tuyến dữ liệu tự động

### Phân mảnh dữ liệu
- Dữ liệu được phân mảnh dựa trên trường `TenPhong`:
  - `P1` → Site1_DB
  - `P2` → Site2_DB
- Các trigger INSTEAD OF tự động định tuyến INSERT, UPDATE, DELETE đến đúng site

### Stack công nghệ
- **Database**: SQL Server 2019
- **Backend**: Python Flask
- **Containerization**: Docker & Docker Compose
- **Database Driver**: pyodbc với ODBC Driver 17 for SQL Server

## Cấu trúc Thư mục

```
CoSoDuLieuPhanTanProject/
├── docker-compose.yml          # Cấu hình Docker Compose
├── mssql/
│   ├── Dockerfile              # Dockerfile cho SQL Server
│   ├── setup.sql               # Script tạo database, table, view, trigger
│   └── run-setup.sh            # Script khởi động và setup
├── app/
│   ├── Dockerfile              # Dockerfile cho Flask app
│   ├── requirements.txt        # Python dependencies
│   └── app.py                  # Flask application
└── README.md                   # Tài liệu này
```

## Cài đặt và Chạy

### Yêu cầu
- Docker
- Docker Compose
- Tối thiểu 4GB RAM cho SQL Server

### Khởi động hệ thống

```bash
# Clone repository (nếu cần)
cd CoSoDuLieuPhanTanProject

# Khởi động toàn bộ hệ thống
docker-compose up --build

# Hoặc chạy ở chế độ background
docker-compose up -d --build
```

### Kiểm tra trạng thái

```bash
# Xem logs
docker-compose logs -f

# Kiểm tra container đang chạy
docker-compose ps

# Kiểm tra health check
curl http://localhost:5000/health
```

### Dừng hệ thống

```bash
# Dừng và xóa containers
docker-compose down

# Dừng và xóa cả volumes (xóa dữ liệu)
docker-compose down -v
```

## API Endpoints

### Health Check
- `GET /health` - Kiểm tra trạng thái hệ thống
- `GET /` - Trang chủ với danh sách API
- `GET /stats` - Thống kê database

### CRUD Operations

#### Nhóm Nghiên Cứu (NhomNC)
- `GET /nhomnc` - Lấy tất cả nhóm
- `GET /nhomnc/<manhom>` - Lấy nhóm theo mã
- `POST /nhomnc` - Tạo nhóm mới
- `PUT /nhomnc/<manhom>` - Cập nhật nhóm
- `DELETE /nhomnc/<manhom>` - Xóa nhóm

**Body mẫu (POST/PUT):**
```json
{
  "MaNhom": "N01",
  "TenNhom": "Nhóm Trí Tuệ Nhân Tạo",
  "TenPhong": "P1"
}
```

#### Nhân Viên (NhanVien)
- `GET /nhanvien` - Lấy tất cả nhân viên
- `GET /nhanvien/<manv>` - Lấy nhân viên theo mã
- `POST /nhanvien` - Tạo nhân viên mới
- `PUT /nhanvien/<manv>` - Cập nhật nhân viên
- `DELETE /nhanvien/<manv>` - Xóa nhân viên

**Body mẫu (POST/PUT):**
```json
{
  "MaNV": "NV001",
  "TenNV": "Nguyễn Văn An",
  "NgaySinh": "1985-05-15",
  "DiaChi": "Hà Nội",
  "MaNhom": "N01"
}
```

#### Đề Án (DeAn)
- `GET /dean` - Lấy tất cả đề án
- `GET /dean/<madean>` - Lấy đề án theo mã
- `POST /dean` - Tạo đề án mới
- `PUT /dean/<madean>` - Cập nhật đề án
- `DELETE /dean/<madean>` - Xóa đề án

**Body mẫu (POST/PUT):**
```json
{
  "MaDeAn": "DA001",
  "TenDeAn": "Phát triển hệ thống chatbot thông minh",
  "KinhPhi": 500000000,
  "NgayBD": "2024-01-01",
  "NgayKT": "2024-12-31",
  "MaNhom": "N01"
}
```

#### Tham Gia (ThamGia)
- `GET /thamgia` - Lấy tất cả tham gia
- `GET /thamgia/<manv>/<madean>` - Lấy tham gia cụ thể
- `POST /thamgia` - Tạo tham gia mới
- `PUT /thamgia/<manv>/<madean>` - Cập nhật tham gia
- `DELETE /thamgia/<manv>/<madean>` - Xóa tham gia

**Body mẫu (POST/PUT):**
```json
{
  "MaNV": "NV001",
  "MaDeAn": "DA001",
  "ThoiGian": 160
}
```

### Truy vấn Đặc biệt

#### Form 1: Đề án có nhân viên từ nhóm khác tham gia
```bash
GET /query/form1/<manhom>

# Ví dụ
curl http://localhost:5000/query/form1/N01
```

#### Form 2: Cập nhật phòng của nhóm
```bash
PUT /query/form2

# Ví dụ
curl -X PUT http://localhost:5000/query/form2 \
  -H "Content-Type: application/json" \
  -d '{"MaNhom": "N01", "TenPhongMoi": "P2"}'
```

#### Form 3: Đề án chưa có nhân viên tham gia
```bash
GET /query/form3

# Ví dụ
curl http://localhost:5000/query/form3
```

#### Form 4: Chuyển nhóm từ P1 sang P2 (Migration)
```bash
PUT /query/form4/<manhom>

# Ví dụ
curl -X PUT http://localhost:5000/query/form4/N01
```

**Lưu ý Form 4:** Endpoint này demo việc tự động di chuyển dữ liệu giữa các site thông qua trigger. Khi cập nhật `TenPhong` từ P1 sang P2, trigger sẽ tự động:
- Copy nhóm, nhân viên, đề án, và tham gia sang Site2_DB
- Xóa dữ liệu khỏi Site1_DB

## Ví dụ Sử dụng

### 1. Kiểm tra health
```bash
curl http://localhost:5000/health
```

### 2. Xem thống kê
```bash
curl http://localhost:5000/stats
```

### 3. Lấy danh sách nhóm nghiên cứu
```bash
curl http://localhost:5000/nhomnc
```

### 4. Tạo nhóm mới
```bash
curl -X POST http://localhost:5000/nhomnc \
  -H "Content-Type: application/json" \
  -d '{
    "MaNhom": "N05",
    "TenNhom": "Nhóm Machine Learning",
    "TenPhong": "P1"
  }'
```

### 5. Tạo nhân viên mới
```bash
curl -X POST http://localhost:5000/nhanvien \
  -H "Content-Type: application/json" \
  -d '{
    "MaNV": "NV009",
    "TenNV": "Phạm Văn Long",
    "NgaySinh": "1994-06-15",
    "DiaChi": "Hà Nội",
    "MaNhom": "N05"
  }'
```

### 6. Xem đề án có nhân viên từ nhóm khác
```bash
curl http://localhost:5000/query/form1/N01
```

### 7. Chuyển nhóm từ P1 sang P2
```bash
curl -X PUT http://localhost:5000/query/form4/N01
```

## Dữ liệu Mẫu

Hệ thống đã được cấu hình sẵn dữ liệu mẫu:

### Nhóm Nghiên Cứu
- **N01**: Nhóm Trí Tuệ Nhân Tạo (P1)
- **N02**: Nhóm Xử Lý Ngôn Ngữ Tự Nhiên (P1)
- **N03**: Nhóm An Ninh Mạng (P2)
- **N04**: Nhóm Cơ Sở Dữ Liệu Phân Tán (P2)

### Nhân Viên
- 8 nhân viên (NV001 - NV008) phân bổ đều cho các nhóm

### Đề Án
- 9 đề án (DA001 - DA009) với nhiều mức kinh phí khác nhau
- DA009 chưa có nhân viên tham gia (để test Form 3)

### Tham Gia
- Bao gồm cả tham gia cùng site và cross-site (nhân viên P1 làm dự án P2)

## Kết nối SQL Server Trực tiếp

Nếu muốn kết nối trực tiếp đến SQL Server:

```bash
# Vào container SQL Server
docker exec -it sqlserver_distributed_db /bin/bash

# Sử dụng sqlcmd
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'Your_S@trong_P@ssword1'

# Liệt kê databases
SELECT name FROM sys.databases;
GO

# Sử dụng Global_DB
USE Global_DB;
GO

# Xem dữ liệu
SELECT * FROM v_NhomNC;
GO
```

## Troubleshooting

### SQL Server không khởi động
```bash
# Xem logs
docker-compose logs db

# Kiểm tra memory
# SQL Server cần ít nhất 2GB RAM
docker stats
```

### Flask app không kết nối được database
```bash
# Kiểm tra SQL Server đã sẵn sàng chưa
docker-compose logs db | grep "Setup completed"

# Restart app
docker-compose restart app
```

### Reset toàn bộ dữ liệu
```bash
# Dừng và xóa containers + volumes
docker-compose down -v

# Khởi động lại
docker-compose up --build
```

## Tính năng Nổi bật

1. **Phân mảnh Tự động**: Dữ liệu tự động được lưu vào đúng site dựa trên TenPhong
2. **Migration Tự động**: Trigger xử lý việc di chuyển dữ liệu giữa các site
3. **Transparent Access**: Ứng dụng chỉ cần query vào Global views, không cần biết dữ liệu ở site nào
4. **Cross-site Participation**: Hỗ trợ nhân viên tham gia đề án ở site khác
5. **RESTful API**: API chuẩn REST với JSON response

## Thông tin Kỹ thuật

### Credentials
- **SQL Server SA Password**: `Your_S@trong_P@ssword1`
- **SQL Server Port**: 1433
- **Flask Port**: 5000

### Volumes
- `sqlserver_data`: Lưu trữ dữ liệu SQL Server (persistent)

### Networks
- `distributed_db_network`: Bridge network cho containers

## License
Educational Project - Distributed Database System Demo

## Tác giả
Hệ thống Cơ Sở Dữ Liệu Phân Tán - Demo Project
