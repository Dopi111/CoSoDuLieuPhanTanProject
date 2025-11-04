# Hướng Dẫn Nhanh - Quick Start Guide

## Khởi động dự án trong 3 bước

### Bước 1: Khởi động containers
```bash
docker-compose up --build
```

Đợi khoảng 30-40 giây để SQL Server khởi động và chạy setup script.
Khi thấy dòng "Setup completed!" và Flask app hiển thị "Running on http://0.0.0.0:5000", bạn đã sẵn sàng!

### Bước 2: Kiểm tra health check
```bash
curl http://localhost:5000/health
```

Kết quả mong đợi:
```json
{
  "status": "healthy",
  "database": "connected",
  "message": "Distributed Database System is running"
}
```

### Bước 3: Test API
```bash
# Xem trang chủ với danh sách API
curl http://localhost:5000/

# Xem thống kê
curl http://localhost:5000/stats
```

## Test Cases - Các Tình Huống Thử Nghiệm

### Test 1: CRUD Cơ Bản

#### Xem danh sách nhóm nghiên cứu
```bash
curl http://localhost:5000/nhomnc
```

#### Xem chi tiết một nhóm
```bash
curl http://localhost:5000/nhomnc/N01
```

#### Tạo nhóm mới (P1)
```bash
curl -X POST http://localhost:5000/nhomnc \
  -H "Content-Type: application/json" \
  -d '{
    "MaNhom": "N05",
    "TenNhom": "Nhóm Machine Learning",
    "TenPhong": "P1"
  }'
```

#### Kiểm tra nhóm đã được tạo ở Site1_DB
```bash
curl http://localhost:5000/nhomnc/N05
```

#### Tạo nhóm khác (P2)
```bash
curl -X POST http://localhost:5000/nhomnc \
  -H "Content-Type: application/json" \
  -d '{
    "MaNhom": "N06",
    "TenNhom": "Nhóm Cloud Computing",
    "TenPhong": "P2"
  }'
```

### Test 2: Phân Mảnh Tự Động

Kiểm tra rằng N05 (P1) và N06 (P2) được lưu ở các site khác nhau:

```bash
# Xem tất cả nhóm
curl http://localhost:5000/nhomnc

# Kết quả sẽ thấy cả N05 và N06, dù chúng ở 2 site khác nhau
# View toàn cục v_NhomNC đã UNION ALL dữ liệu từ cả 2 site
```

### Test 3: Tham Gia Cross-Site

#### Tạo nhân viên cho nhóm N05 (P1)
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

#### Tạo đề án cho nhóm N06 (P2)
```bash
curl -X POST http://localhost:5000/dean \
  -H "Content-Type: application/json" \
  -d '{
    "MaDeAn": "DA010",
    "TenDeAn": "Cloud Infrastructure Migration",
    "KinhPhi": 750000000,
    "NgayBD": "2024-08-01",
    "NgayKT": "2025-07-31",
    "MaNhom": "N06"
  }'
```

#### Cho nhân viên từ P1 tham gia đề án ở P2 (Cross-site)
```bash
curl -X POST http://localhost:5000/thamgia \
  -H "Content-Type: application/json" \
  -d '{
    "MaNV": "NV009",
    "MaDeAn": "DA010",
    "ThoiGian": 100
  }'
```

#### Kiểm tra tham gia cross-site
```bash
curl http://localhost:5000/thamgia/NV009/DA010
```

### Test 4: Form 1 - Đề án có nhân viên từ nhóm khác

```bash
# Kiểm tra đề án của nhóm N01 có nhân viên từ nhóm khác không
curl http://localhost:5000/query/form1/N01

# Kết quả sẽ hiển thị các đề án của N01 mà có nhân viên từ nhóm khác tham gia
# Ví dụ: DA002 có NV005 (từ nhóm N03) tham gia
```

### Test 5: Form 3 - Đề án chưa có nhân viên

```bash
curl http://localhost:5000/query/form3

# Sẽ thấy DA009 (Nghiên cứu Blockchain trong giáo dục) chưa có ai tham gia
```

### Test 6: Form 2 - Cập nhật phòng của nhóm

```bash
# Cập nhật nhóm N05 từ P1 sang P2
curl -X PUT http://localhost:5000/query/form2 \
  -H "Content-Type: application/json" \
  -d '{
    "MaNhom": "N05",
    "TenPhongMoi": "P2"
  }'

# Kiểm tra lại
curl http://localhost:5000/nhomnc/N05
```

### Test 7: Form 4 - Migration Tự Động (P1 → P2)

Đây là test case quan trọng nhất - demo việc tự động di chuyển toàn bộ dữ liệu liên quan từ Site1 sang Site2.

#### Chuẩn bị: Tạo nhóm mới với dữ liệu đầy đủ ở P1
```bash
# Tạo nhóm
curl -X POST http://localhost:5000/nhomnc \
  -H "Content-Type: application/json" \
  -d '{
    "MaNhom": "N07",
    "TenNhom": "Nhóm Test Migration",
    "TenPhong": "P1"
  }'

# Tạo nhân viên
curl -X POST http://localhost:5000/nhanvien \
  -H "Content-Type: application/json" \
  -d '{
    "MaNV": "NV010",
    "TenNV": "Test User",
    "NgaySinh": "1995-01-01",
    "DiaChi": "Test Address",
    "MaNhom": "N07"
  }'

# Tạo đề án
curl -X POST http://localhost:5000/dean \
  -H "Content-Type: application/json" \
  -d '{
    "MaDeAn": "DA011",
    "TenDeAn": "Test Project",
    "KinhPhi": 100000000,
    "NgayBD": "2024-01-01",
    "NgayKT": "2024-12-31",
    "MaNhom": "N07"
  }'

# Tạo tham gia
curl -X POST http://localhost:5000/thamgia \
  -H "Content-Type: application/json" \
  -d '{
    "MaNV": "NV010",
    "MaDeAn": "DA011",
    "ThoiGian": 120
  }'
```

#### Kiểm tra trước khi migrate
```bash
# Xem nhóm (đang ở P1)
curl http://localhost:5000/nhomnc/N07

# Xem stats
curl http://localhost:5000/stats
```

#### Thực hiện migration
```bash
curl -X PUT http://localhost:5000/query/form4/N07
```

Kết quả sẽ hiển thị:
- Nhóm đã chuyển từ P1 sang P2
- Số lượng records đã được migrate (employees, projects, participations)
- Thông báo về việc dữ liệu đã được tự động chuyển từ Site1_DB sang Site2_DB

#### Kiểm tra sau khi migrate
```bash
# Kiểm tra nhóm đã chuyển sang P2
curl http://localhost:5000/nhomnc/N07

# Kiểm tra nhân viên vẫn còn
curl http://localhost:5000/nhanvien/NV010

# Kiểm tra đề án vẫn còn
curl http://localhost:5000/dean/DA011

# Kiểm tra tham gia vẫn còn
curl http://localhost:5000/thamgia/NV010/DA011

# Xem stats để thấy sự thay đổi trong phân bổ P1/P2
curl http://localhost:5000/stats
```

### Test 8: DELETE Cascade

```bash
# Xóa nhóm (sẽ tự động xóa nhân viên, đề án, tham gia liên quan)
curl -X DELETE http://localhost:5000/nhomnc/N07

# Kiểm tra nhân viên đã bị xóa
curl http://localhost:5000/nhanvien/NV010
# Sẽ trả về 404 Not Found

# Kiểm tra đề án đã bị xóa
curl http://localhost:5000/dean/DA011
# Sẽ trả về 404 Not Found
```

## Kết nối SQL Server trực tiếp

```bash
# Vào container
docker exec -it sqlserver_distributed_db /bin/bash

# Sử dụng sqlcmd
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'Your_S@trong_P@ssword1'

# Các lệnh SQL hữu ích:
```

```sql
-- Xem tất cả databases
SELECT name FROM sys.databases;
GO

-- Chuyển sang Global_DB
USE Global_DB;
GO

-- Xem dữ liệu từ view toàn cục
SELECT * FROM v_NhomNC;
GO

-- Kiểm tra dữ liệu ở Site1_DB
SELECT * FROM Site1_DB.dbo.NhomNC;
GO

-- Kiểm tra dữ liệu ở Site2_DB
SELECT * FROM Site2_DB.dbo.NhomNC;
GO

-- Xem trigger
SELECT name, object_name(parent_id) as table_name
FROM sys.triggers
WHERE parent_class = 1;
GO

-- Exit
EXIT
```

## Xem Logs

```bash
# Xem logs của tất cả services
docker-compose logs -f

# Chỉ xem logs SQL Server
docker-compose logs -f db

# Chỉ xem logs Flask app
docker-compose logs -f app
```

## Dừng và Dọn dẹp

```bash
# Dừng containers (giữ dữ liệu)
docker-compose stop

# Khởi động lại
docker-compose start

# Dừng và xóa containers (giữ volumes)
docker-compose down

# Dừng và xóa tất cả (bao gồm dữ liệu)
docker-compose down -v

# Rebuild từ đầu
docker-compose down -v && docker-compose up --build
```

## Kiểm tra Performance

```bash
# Kiểm tra resource usage
docker stats

# Kiểm tra response time
time curl http://localhost:5000/stats

# Stress test (cần cài apache bench)
ab -n 1000 -c 10 http://localhost:5000/nhomnc
```

## Troubleshooting

### SQL Server không khởi động
```bash
# Kiểm tra logs
docker-compose logs db

# Thường do thiếu RAM - SQL Server cần ít nhất 2GB
# Giải pháp: Tăng memory limit trong Docker settings
```

### Flask không kết nối được
```bash
# Kiểm tra SQL Server đã sẵn sàng
docker-compose logs db | grep "Setup completed"

# Nếu chưa, đợi thêm vài giây rồi restart Flask
docker-compose restart app
```

### Port đã được sử dụng
```bash
# Kiểm tra port
lsof -i :5000  # Flask
lsof -i :1433  # SQL Server

# Đổi port trong docker-compose.yml nếu cần
```

## Kết luận

Dự án đã demo thành công:
✅ Phân mảnh dữ liệu tự động dựa trên TenPhong
✅ Views toàn cục UNION ALL từ nhiều site
✅ Triggers INSTEAD OF để định tuyến INSERT/UPDATE/DELETE
✅ Migration tự động giữa các site
✅ Cross-site participation
✅ Cascade delete
✅ RESTful API đầy đủ
✅ Docker containerization

Chúc bạn test vui vẻ! 🚀
