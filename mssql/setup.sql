-- =============================================================================
-- DISTRIBUTED DATABASE SETUP SCRIPT
-- Hệ thống quản lý nhóm nghiên cứu và đề án khoa học
-- =============================================================================

PRINT 'Starting database setup...'
GO

-- =============================================================================
-- 1. CREATE DATABASES
-- =============================================================================

-- Create Site1_DB (for P1)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Site1_DB')
BEGIN
    CREATE DATABASE Site1_DB;
    PRINT 'Site1_DB created successfully'
END
GO

-- Create Site2_DB (for P2)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Site2_DB')
BEGIN
    CREATE DATABASE Site2_DB;
    PRINT 'Site2_DB created successfully'
END
GO

-- Create Global_DB (for global views and triggers)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Global_DB')
BEGIN
    CREATE DATABASE Global_DB;
    PRINT 'Global_DB created successfully'
END
GO

-- =============================================================================
-- 2. CREATE TABLES IN Site1_DB
-- =============================================================================

USE Site1_DB;
GO

-- Table: NhomNC (Research Groups)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NhomNC')
BEGIN
    CREATE TABLE NhomNC (
        MaNhom VARCHAR(10) PRIMARY KEY,
        TenNhom NVARCHAR(100) NOT NULL,
        TenPhong VARCHAR(10) NOT NULL
    );
    PRINT 'Site1_DB.NhomNC table created'
END
GO

-- Table: NhanVien (Employees)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NhanVien')
BEGIN
    CREATE TABLE NhanVien (
        MaNV VARCHAR(10) PRIMARY KEY,
        TenNV NVARCHAR(100) NOT NULL,
        NgaySinh DATE,
        DiaChi NVARCHAR(200),
        MaNhom VARCHAR(10),
        FOREIGN KEY (MaNhom) REFERENCES NhomNC(MaNhom)
    );
    PRINT 'Site1_DB.NhanVien table created'
END
GO

-- Table: DeAn (Projects)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DeAn')
BEGIN
    CREATE TABLE DeAn (
        MaDeAn VARCHAR(10) PRIMARY KEY,
        TenDeAn NVARCHAR(200) NOT NULL,
        KinhPhi DECIMAL(18, 2),
        NgayBD DATE,
        NgayKT DATE,
        MaNhom VARCHAR(10),
        FOREIGN KEY (MaNhom) REFERENCES NhomNC(MaNhom)
    );
    PRINT 'Site1_DB.DeAn table created'
END
GO

-- Table: ThamGia (Participation)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ThamGia')
BEGIN
    CREATE TABLE ThamGia (
        MaNV VARCHAR(10),
        MaDeAn VARCHAR(10),
        ThoiGian INT,
        PRIMARY KEY (MaNV, MaDeAn),
        FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
        FOREIGN KEY (MaDeAn) REFERENCES DeAn(MaDeAn)
    );
    PRINT 'Site1_DB.ThamGia table created'
END
GO

-- =============================================================================
-- 3. CREATE TABLES IN Site2_DB
-- =============================================================================

USE Site2_DB;
GO

-- Table: NhomNC (Research Groups)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NhomNC')
BEGIN
    CREATE TABLE NhomNC (
        MaNhom VARCHAR(10) PRIMARY KEY,
        TenNhom NVARCHAR(100) NOT NULL,
        TenPhong VARCHAR(10) NOT NULL
    );
    PRINT 'Site2_DB.NhomNC table created'
END
GO

-- Table: NhanVien (Employees)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NhanVien')
BEGIN
    CREATE TABLE NhanVien (
        MaNV VARCHAR(10) PRIMARY KEY,
        TenNV NVARCHAR(100) NOT NULL,
        NgaySinh DATE,
        DiaChi NVARCHAR(200),
        MaNhom VARCHAR(10),
        FOREIGN KEY (MaNhom) REFERENCES NhomNC(MaNhom)
    );
    PRINT 'Site2_DB.NhanVien table created'
END
GO

-- Table: DeAn (Projects)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DeAn')
BEGIN
    CREATE TABLE DeAn (
        MaDeAn VARCHAR(10) PRIMARY KEY,
        TenDeAn NVARCHAR(200) NOT NULL,
        KinhPhi DECIMAL(18, 2),
        NgayBD DATE,
        NgayKT DATE,
        MaNhom VARCHAR(10),
        FOREIGN KEY (MaNhom) REFERENCES NhomNC(MaNhom)
    );
    PRINT 'Site2_DB.DeAn table created'
END
GO

-- Table: ThamGia (Participation)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ThamGia')
BEGIN
    CREATE TABLE ThamGia (
        MaNV VARCHAR(10),
        MaDeAn VARCHAR(10),
        ThoiGian INT,
        PRIMARY KEY (MaNV, MaDeAn),
        FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
        FOREIGN KEY (MaDeAn) REFERENCES DeAn(MaDeAn)
    );
    PRINT 'Site2_DB.ThamGia table created'
END
GO

-- =============================================================================
-- 4. CREATE GLOBAL VIEWS IN Global_DB
-- =============================================================================

USE Global_DB;
GO

-- View: v_NhomNC (Global view for all research groups)
IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_NhomNC')
    DROP VIEW v_NhomNC;
GO

CREATE VIEW v_NhomNC AS
SELECT MaNhom, TenNhom, TenPhong FROM Site1_DB.dbo.NhomNC
UNION ALL
SELECT MaNhom, TenNhom, TenPhong FROM Site2_DB.dbo.NhomNC;
GO
PRINT 'Global view v_NhomNC created'
GO

-- View: v_NhanVien (Global view for all employees)
IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_NhanVien')
    DROP VIEW v_NhanVien;
GO

CREATE VIEW v_NhanVien AS
SELECT MaNV, TenNV, NgaySinh, DiaChi, MaNhom FROM Site1_DB.dbo.NhanVien
UNION ALL
SELECT MaNV, TenNV, NgaySinh, DiaChi, MaNhom FROM Site2_DB.dbo.NhanVien;
GO
PRINT 'Global view v_NhanVien created'
GO

-- View: v_DeAn (Global view for all projects)
IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_DeAn')
    DROP VIEW v_DeAn;
GO

CREATE VIEW v_DeAn AS
SELECT MaDeAn, TenDeAn, KinhPhi, NgayBD, NgayKT, MaNhom FROM Site1_DB.dbo.DeAn
UNION ALL
SELECT MaDeAn, TenDeAn, KinhPhi, NgayBD, NgayKT, MaNhom FROM Site2_DB.dbo.DeAn;
GO
PRINT 'Global view v_DeAn created'
GO

-- View: v_ThamGia (Global view for all participations)
IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_ThamGia')
    DROP VIEW v_ThamGia;
GO

CREATE VIEW v_ThamGia AS
SELECT MaNV, MaDeAn, ThoiGian FROM Site1_DB.dbo.ThamGia
UNION ALL
SELECT MaNV, MaDeAn, ThoiGian FROM Site2_DB.dbo.ThamGia;
GO
PRINT 'Global view v_ThamGia created'
GO

-- =============================================================================
-- 5. CREATE TRIGGERS FOR v_NhomNC
-- =============================================================================

-- INSTEAD OF INSERT trigger for v_NhomNC
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_insert_NhomNC')
    DROP TRIGGER trg_insert_NhomNC;
GO

CREATE TRIGGER trg_insert_NhomNC ON v_NhomNC
INSTEAD OF INSERT AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into Site1_DB for P1
    INSERT INTO Site1_DB.dbo.NhomNC (MaNhom, TenNhom, TenPhong)
    SELECT MaNhom, TenNhom, TenPhong
    FROM inserted
    WHERE TenPhong = 'P1';

    -- Insert into Site2_DB for P2
    INSERT INTO Site2_DB.dbo.NhomNC (MaNhom, TenNhom, TenPhong)
    SELECT MaNhom, TenNhom, TenPhong
    FROM inserted
    WHERE TenPhong = 'P2';

    PRINT 'Trigger trg_insert_NhomNC executed'
END;
GO
PRINT 'Trigger trg_insert_NhomNC created'
GO

-- INSTEAD OF UPDATE trigger for v_NhomNC
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_update_NhomNC')
    DROP TRIGGER trg_update_NhomNC;
GO

CREATE TRIGGER trg_update_NhomNC ON v_NhomNC
INSTEAD OF UPDATE AS
BEGIN
    SET NOCOUNT ON;

    -- Handle updates where TenPhong changes from P1 to P2
    -- First, copy data to Site2_DB
    INSERT INTO Site2_DB.dbo.NhomNC (MaNhom, TenNhom, TenPhong)
    SELECT i.MaNhom, i.TenNhom, i.TenPhong
    FROM inserted i
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P1' AND i.TenPhong = 'P2'
    AND NOT EXISTS (SELECT 1 FROM Site2_DB.dbo.NhomNC WHERE MaNhom = i.MaNhom);

    -- Move related NhanVien from Site1 to Site2
    INSERT INTO Site2_DB.dbo.NhanVien (MaNV, TenNV, NgaySinh, DiaChi, MaNhom)
    SELECT nv.MaNV, nv.TenNV, nv.NgaySinh, nv.DiaChi, nv.MaNhom
    FROM Site1_DB.dbo.NhanVien nv
    INNER JOIN inserted i ON nv.MaNhom = i.MaNhom
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P1' AND i.TenPhong = 'P2';

    -- Move related DeAn from Site1 to Site2
    INSERT INTO Site2_DB.dbo.DeAn (MaDeAn, TenDeAn, KinhPhi, NgayBD, NgayKT, MaNhom)
    SELECT da.MaDeAn, da.TenDeAn, da.KinhPhi, da.NgayBD, da.NgayKT, da.MaNhom
    FROM Site1_DB.dbo.DeAn da
    INNER JOIN inserted i ON da.MaNhom = i.MaNhom
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P1' AND i.TenPhong = 'P2';

    -- Move related ThamGia from Site1 to Site2
    INSERT INTO Site2_DB.dbo.ThamGia (MaNV, MaDeAn, ThoiGian)
    SELECT tg.MaNV, tg.MaDeAn, tg.ThoiGian
    FROM Site1_DB.dbo.ThamGia tg
    INNER JOIN Site1_DB.dbo.NhanVien nv ON tg.MaNV = nv.MaNV
    INNER JOIN inserted i ON nv.MaNhom = i.MaNhom
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P1' AND i.TenPhong = 'P2';

    -- Delete from Site1_DB
    DELETE tg FROM Site1_DB.dbo.ThamGia tg
    INNER JOIN Site1_DB.dbo.NhanVien nv ON tg.MaNV = nv.MaNV
    INNER JOIN inserted i ON nv.MaNhom = i.MaNhom
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P1' AND i.TenPhong = 'P2';

    DELETE FROM Site1_DB.dbo.DeAn
    WHERE MaNhom IN (
        SELECT i.MaNhom FROM inserted i
        INNER JOIN deleted d ON i.MaNhom = d.MaNhom
        WHERE d.TenPhong = 'P1' AND i.TenPhong = 'P2'
    );

    DELETE FROM Site1_DB.dbo.NhanVien
    WHERE MaNhom IN (
        SELECT i.MaNhom FROM inserted i
        INNER JOIN deleted d ON i.MaNhom = d.MaNhom
        WHERE d.TenPhong = 'P1' AND i.TenPhong = 'P2'
    );

    DELETE FROM Site1_DB.dbo.NhomNC
    WHERE MaNhom IN (
        SELECT i.MaNhom FROM inserted i
        INNER JOIN deleted d ON i.MaNhom = d.MaNhom
        WHERE d.TenPhong = 'P1' AND i.TenPhong = 'P2'
    );

    -- Handle updates where TenPhong changes from P2 to P1
    -- Similar logic for P2 to P1 migration
    INSERT INTO Site1_DB.dbo.NhomNC (MaNhom, TenNhom, TenPhong)
    SELECT i.MaNhom, i.TenNhom, i.TenPhong
    FROM inserted i
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P2' AND i.TenPhong = 'P1'
    AND NOT EXISTS (SELECT 1 FROM Site1_DB.dbo.NhomNC WHERE MaNhom = i.MaNhom);

    INSERT INTO Site1_DB.dbo.NhanVien (MaNV, TenNV, NgaySinh, DiaChi, MaNhom)
    SELECT nv.MaNV, nv.TenNV, nv.NgaySinh, nv.DiaChi, nv.MaNhom
    FROM Site2_DB.dbo.NhanVien nv
    INNER JOIN inserted i ON nv.MaNhom = i.MaNhom
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P2' AND i.TenPhong = 'P1';

    INSERT INTO Site1_DB.dbo.DeAn (MaDeAn, TenDeAn, KinhPhi, NgayBD, NgayKT, MaNhom)
    SELECT da.MaDeAn, da.TenDeAn, da.KinhPhi, da.NgayBD, da.NgayKT, da.MaNhom
    FROM Site2_DB.dbo.DeAn da
    INNER JOIN inserted i ON da.MaNhom = i.MaNhom
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P2' AND i.TenPhong = 'P1';

    INSERT INTO Site1_DB.dbo.ThamGia (MaNV, MaDeAn, ThoiGian)
    SELECT tg.MaNV, tg.MaDeAn, tg.ThoiGian
    FROM Site2_DB.dbo.ThamGia tg
    INNER JOIN Site2_DB.dbo.NhanVien nv ON tg.MaNV = nv.MaNV
    INNER JOIN inserted i ON nv.MaNhom = i.MaNhom
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P2' AND i.TenPhong = 'P1';

    DELETE tg FROM Site2_DB.dbo.ThamGia tg
    INNER JOIN Site2_DB.dbo.NhanVien nv ON tg.MaNV = nv.MaNV
    INNER JOIN inserted i ON nv.MaNhom = i.MaNhom
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P2' AND i.TenPhong = 'P1';

    DELETE FROM Site2_DB.dbo.DeAn
    WHERE MaNhom IN (
        SELECT i.MaNhom FROM inserted i
        INNER JOIN deleted d ON i.MaNhom = d.MaNhom
        WHERE d.TenPhong = 'P2' AND i.TenPhong = 'P1'
    );

    DELETE FROM Site2_DB.dbo.NhanVien
    WHERE MaNhom IN (
        SELECT i.MaNhom FROM inserted i
        INNER JOIN deleted d ON i.MaNhom = d.MaNhom
        WHERE d.TenPhong = 'P2' AND i.TenPhong = 'P1'
    );

    DELETE FROM Site2_DB.dbo.NhomNC
    WHERE MaNhom IN (
        SELECT i.MaNhom FROM inserted i
        INNER JOIN deleted d ON i.MaNhom = d.MaNhom
        WHERE d.TenPhong = 'P2' AND i.TenPhong = 'P1'
    );

    -- Handle normal updates (no site change)
    UPDATE Site1_DB.dbo.NhomNC
    SET TenNhom = i.TenNhom, TenPhong = i.TenPhong
    FROM inserted i
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P1' AND i.TenPhong = 'P1'
    AND Site1_DB.dbo.NhomNC.MaNhom = i.MaNhom;

    UPDATE Site2_DB.dbo.NhomNC
    SET TenNhom = i.TenNhom, TenPhong = i.TenPhong
    FROM inserted i
    INNER JOIN deleted d ON i.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P2' AND i.TenPhong = 'P2'
    AND Site2_DB.dbo.NhomNC.MaNhom = i.MaNhom;

    PRINT 'Trigger trg_update_NhomNC executed'
END;
GO
PRINT 'Trigger trg_update_NhomNC created'
GO

-- INSTEAD OF DELETE trigger for v_NhomNC
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_delete_NhomNC')
    DROP TRIGGER trg_delete_NhomNC;
GO

CREATE TRIGGER trg_delete_NhomNC ON v_NhomNC
INSTEAD OF DELETE AS
BEGIN
    SET NOCOUNT ON;

    -- Delete related ThamGia records from Site1_DB
    DELETE tg FROM Site1_DB.dbo.ThamGia tg
    INNER JOIN Site1_DB.dbo.NhanVien nv ON tg.MaNV = nv.MaNV
    INNER JOIN deleted d ON nv.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P1';

    -- Delete related DeAn records from Site1_DB
    DELETE FROM Site1_DB.dbo.DeAn
    WHERE MaNhom IN (SELECT MaNhom FROM deleted WHERE TenPhong = 'P1');

    -- Delete related NhanVien records from Site1_DB
    DELETE FROM Site1_DB.dbo.NhanVien
    WHERE MaNhom IN (SELECT MaNhom FROM deleted WHERE TenPhong = 'P1');

    -- Delete from Site1_DB
    DELETE FROM Site1_DB.dbo.NhomNC
    WHERE MaNhom IN (SELECT MaNhom FROM deleted WHERE TenPhong = 'P1');

    -- Delete related ThamGia records from Site2_DB
    DELETE tg FROM Site2_DB.dbo.ThamGia tg
    INNER JOIN Site2_DB.dbo.NhanVien nv ON tg.MaNV = nv.MaNV
    INNER JOIN deleted d ON nv.MaNhom = d.MaNhom
    WHERE d.TenPhong = 'P2';

    -- Delete related DeAn records from Site2_DB
    DELETE FROM Site2_DB.dbo.DeAn
    WHERE MaNhom IN (SELECT MaNhom FROM deleted WHERE TenPhong = 'P2');

    -- Delete related NhanVien records from Site2_DB
    DELETE FROM Site2_DB.dbo.NhanVien
    WHERE MaNhom IN (SELECT MaNhom FROM deleted WHERE TenPhong = 'P2');

    -- Delete from Site2_DB
    DELETE FROM Site2_DB.dbo.NhomNC
    WHERE MaNhom IN (SELECT MaNhom FROM deleted WHERE TenPhong = 'P2');

    PRINT 'Trigger trg_delete_NhomNC executed'
END;
GO
PRINT 'Trigger trg_delete_NhomNC created'
GO

-- =============================================================================
-- 6. CREATE TRIGGERS FOR v_NhanVien
-- =============================================================================

-- INSTEAD OF INSERT trigger for v_NhanVien
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_insert_NhanVien')
    DROP TRIGGER trg_insert_NhanVien;
GO

CREATE TRIGGER trg_insert_NhanVien ON v_NhanVien
INSTEAD OF INSERT AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into Site1_DB for groups in P1
    INSERT INTO Site1_DB.dbo.NhanVien (MaNV, TenNV, NgaySinh, DiaChi, MaNhom)
    SELECT i.MaNV, i.TenNV, i.NgaySinh, i.DiaChi, i.MaNhom
    FROM inserted i
    INNER JOIN Site1_DB.dbo.NhomNC n ON i.MaNhom = n.MaNhom
    WHERE n.TenPhong = 'P1';

    -- Insert into Site2_DB for groups in P2
    INSERT INTO Site2_DB.dbo.NhanVien (MaNV, TenNV, NgaySinh, DiaChi, MaNhom)
    SELECT i.MaNV, i.TenNV, i.NgaySinh, i.DiaChi, i.MaNhom
    FROM inserted i
    INNER JOIN Site2_DB.dbo.NhomNC n ON i.MaNhom = n.MaNhom
    WHERE n.TenPhong = 'P2';

    PRINT 'Trigger trg_insert_NhanVien executed'
END;
GO
PRINT 'Trigger trg_insert_NhanVien created'
GO

-- INSTEAD OF UPDATE trigger for v_NhanVien
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_update_NhanVien')
    DROP TRIGGER trg_update_NhanVien;
GO

CREATE TRIGGER trg_update_NhanVien ON v_NhanVien
INSTEAD OF UPDATE AS
BEGIN
    SET NOCOUNT ON;

    -- Update in Site1_DB
    UPDATE Site1_DB.dbo.NhanVien
    SET TenNV = i.TenNV,
        NgaySinh = i.NgaySinh,
        DiaChi = i.DiaChi,
        MaNhom = i.MaNhom
    FROM inserted i
    WHERE Site1_DB.dbo.NhanVien.MaNV = i.MaNV
    AND EXISTS (SELECT 1 FROM Site1_DB.dbo.NhanVien WHERE MaNV = i.MaNV);

    -- Update in Site2_DB
    UPDATE Site2_DB.dbo.NhanVien
    SET TenNV = i.TenNV,
        NgaySinh = i.NgaySinh,
        DiaChi = i.DiaChi,
        MaNhom = i.MaNhom
    FROM inserted i
    WHERE Site2_DB.dbo.NhanVien.MaNV = i.MaNV
    AND EXISTS (SELECT 1 FROM Site2_DB.dbo.NhanVien WHERE MaNV = i.MaNV);

    PRINT 'Trigger trg_update_NhanVien executed'
END;
GO
PRINT 'Trigger trg_update_NhanVien created'
GO

-- INSTEAD OF DELETE trigger for v_NhanVien
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_delete_NhanVien')
    DROP TRIGGER trg_delete_NhanVien;
GO

CREATE TRIGGER trg_delete_NhanVien ON v_NhanVien
INSTEAD OF DELETE AS
BEGIN
    SET NOCOUNT ON;

    -- Delete related ThamGia records first
    DELETE FROM Site1_DB.dbo.ThamGia
    WHERE MaNV IN (SELECT MaNV FROM deleted);

    DELETE FROM Site2_DB.dbo.ThamGia
    WHERE MaNV IN (SELECT MaNV FROM deleted);

    -- Delete from Site1_DB
    DELETE FROM Site1_DB.dbo.NhanVien
    WHERE MaNV IN (SELECT MaNV FROM deleted);

    -- Delete from Site2_DB
    DELETE FROM Site2_DB.dbo.NhanVien
    WHERE MaNV IN (SELECT MaNV FROM deleted);

    PRINT 'Trigger trg_delete_NhanVien executed'
END;
GO
PRINT 'Trigger trg_delete_NhanVien created'
GO

-- =============================================================================
-- 7. CREATE TRIGGERS FOR v_DeAn
-- =============================================================================

-- INSTEAD OF INSERT trigger for v_DeAn
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_insert_DeAn')
    DROP TRIGGER trg_insert_DeAn;
GO

CREATE TRIGGER trg_insert_DeAn ON v_DeAn
INSTEAD OF INSERT AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into Site1_DB for groups in P1
    INSERT INTO Site1_DB.dbo.DeAn (MaDeAn, TenDeAn, KinhPhi, NgayBD, NgayKT, MaNhom)
    SELECT i.MaDeAn, i.TenDeAn, i.KinhPhi, i.NgayBD, i.NgayKT, i.MaNhom
    FROM inserted i
    INNER JOIN Site1_DB.dbo.NhomNC n ON i.MaNhom = n.MaNhom
    WHERE n.TenPhong = 'P1';

    -- Insert into Site2_DB for groups in P2
    INSERT INTO Site2_DB.dbo.DeAn (MaDeAn, TenDeAn, KinhPhi, NgayBD, NgayKT, MaNhom)
    SELECT i.MaDeAn, i.TenDeAn, i.KinhPhi, i.NgayBD, i.NgayKT, i.MaNhom
    FROM inserted i
    INNER JOIN Site2_DB.dbo.NhomNC n ON i.MaNhom = n.MaNhom
    WHERE n.TenPhong = 'P2';

    PRINT 'Trigger trg_insert_DeAn executed'
END;
GO
PRINT 'Trigger trg_insert_DeAn created'
GO

-- INSTEAD OF UPDATE trigger for v_DeAn
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_update_DeAn')
    DROP TRIGGER trg_update_DeAn;
GO

CREATE TRIGGER trg_update_DeAn ON v_DeAn
INSTEAD OF UPDATE AS
BEGIN
    SET NOCOUNT ON;

    -- Update in Site1_DB
    UPDATE Site1_DB.dbo.DeAn
    SET TenDeAn = i.TenDeAn,
        KinhPhi = i.KinhPhi,
        NgayBD = i.NgayBD,
        NgayKT = i.NgayKT,
        MaNhom = i.MaNhom
    FROM inserted i
    WHERE Site1_DB.dbo.DeAn.MaDeAn = i.MaDeAn
    AND EXISTS (SELECT 1 FROM Site1_DB.dbo.DeAn WHERE MaDeAn = i.MaDeAn);

    -- Update in Site2_DB
    UPDATE Site2_DB.dbo.DeAn
    SET TenDeAn = i.TenDeAn,
        KinhPhi = i.KinhPhi,
        NgayBD = i.NgayBD,
        NgayKT = i.NgayKT,
        MaNhom = i.MaNhom
    FROM inserted i
    WHERE Site2_DB.dbo.DeAn.MaDeAn = i.MaDeAn
    AND EXISTS (SELECT 1 FROM Site2_DB.dbo.DeAn WHERE MaDeAn = i.MaDeAn);

    PRINT 'Trigger trg_update_DeAn executed'
END;
GO
PRINT 'Trigger trg_update_DeAn created'
GO

-- INSTEAD OF DELETE trigger for v_DeAn
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_delete_DeAn')
    DROP TRIGGER trg_delete_DeAn;
GO

CREATE TRIGGER trg_delete_DeAn ON v_DeAn
INSTEAD OF DELETE AS
BEGIN
    SET NOCOUNT ON;

    -- Delete related ThamGia records first
    DELETE FROM Site1_DB.dbo.ThamGia
    WHERE MaDeAn IN (SELECT MaDeAn FROM deleted);

    DELETE FROM Site2_DB.dbo.ThamGia
    WHERE MaDeAn IN (SELECT MaDeAn FROM deleted);

    -- Delete from Site1_DB
    DELETE FROM Site1_DB.dbo.DeAn
    WHERE MaDeAn IN (SELECT MaDeAn FROM deleted);

    -- Delete from Site2_DB
    DELETE FROM Site2_DB.dbo.DeAn
    WHERE MaDeAn IN (SELECT MaDeAn FROM deleted);

    PRINT 'Trigger trg_delete_DeAn executed'
END;
GO
PRINT 'Trigger trg_delete_DeAn created'
GO

-- =============================================================================
-- 8. CREATE TRIGGERS FOR v_ThamGia
-- =============================================================================

-- INSTEAD OF INSERT trigger for v_ThamGia
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_insert_ThamGia')
    DROP TRIGGER trg_insert_ThamGia;
GO

CREATE TRIGGER trg_insert_ThamGia ON v_ThamGia
INSTEAD OF INSERT AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into Site1_DB (based on where employee is located)
    INSERT INTO Site1_DB.dbo.ThamGia (MaNV, MaDeAn, ThoiGian)
    SELECT i.MaNV, i.MaDeAn, i.ThoiGian
    FROM inserted i
    WHERE EXISTS (SELECT 1 FROM Site1_DB.dbo.NhanVien WHERE MaNV = i.MaNV)
    AND EXISTS (SELECT 1 FROM Site1_DB.dbo.DeAn WHERE MaDeAn = i.MaDeAn);

    -- Insert into Site2_DB (based on where employee is located)
    INSERT INTO Site2_DB.dbo.ThamGia (MaNV, MaDeAn, ThoiGian)
    SELECT i.MaNV, i.MaDeAn, i.ThoiGian
    FROM inserted i
    WHERE EXISTS (SELECT 1 FROM Site2_DB.dbo.NhanVien WHERE MaNV = i.MaNV)
    AND EXISTS (SELECT 1 FROM Site2_DB.dbo.DeAn WHERE MaDeAn = i.MaDeAn);

    -- Handle cross-site participation (employee in Site1, project in Site2)
    INSERT INTO Site1_DB.dbo.ThamGia (MaNV, MaDeAn, ThoiGian)
    SELECT i.MaNV, i.MaDeAn, i.ThoiGian
    FROM inserted i
    WHERE EXISTS (SELECT 1 FROM Site1_DB.dbo.NhanVien WHERE MaNV = i.MaNV)
    AND EXISTS (SELECT 1 FROM Site2_DB.dbo.DeAn WHERE MaDeAn = i.MaDeAn)
    AND NOT EXISTS (SELECT 1 FROM Site1_DB.dbo.ThamGia WHERE MaNV = i.MaNV AND MaDeAn = i.MaDeAn);

    -- Handle cross-site participation (employee in Site2, project in Site1)
    INSERT INTO Site2_DB.dbo.ThamGia (MaNV, MaDeAn, ThoiGian)
    SELECT i.MaNV, i.MaDeAn, i.ThoiGian
    FROM inserted i
    WHERE EXISTS (SELECT 1 FROM Site2_DB.dbo.NhanVien WHERE MaNV = i.MaNV)
    AND EXISTS (SELECT 1 FROM Site1_DB.dbo.DeAn WHERE MaDeAn = i.MaDeAn)
    AND NOT EXISTS (SELECT 1 FROM Site2_DB.dbo.ThamGia WHERE MaNV = i.MaNV AND MaDeAn = i.MaDeAn);

    PRINT 'Trigger trg_insert_ThamGia executed'
END;
GO
PRINT 'Trigger trg_insert_ThamGia created'
GO

-- INSTEAD OF UPDATE trigger for v_ThamGia
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_update_ThamGia')
    DROP TRIGGER trg_update_ThamGia;
GO

CREATE TRIGGER trg_update_ThamGia ON v_ThamGia
INSTEAD OF UPDATE AS
BEGIN
    SET NOCOUNT ON;

    -- Update in Site1_DB
    UPDATE Site1_DB.dbo.ThamGia
    SET ThoiGian = i.ThoiGian
    FROM inserted i
    WHERE Site1_DB.dbo.ThamGia.MaNV = i.MaNV
    AND Site1_DB.dbo.ThamGia.MaDeAn = i.MaDeAn;

    -- Update in Site2_DB
    UPDATE Site2_DB.dbo.ThamGia
    SET ThoiGian = i.ThoiGian
    FROM inserted i
    WHERE Site2_DB.dbo.ThamGia.MaNV = i.MaNV
    AND Site2_DB.dbo.ThamGia.MaDeAn = i.MaDeAn;

    PRINT 'Trigger trg_update_ThamGia executed'
END;
GO
PRINT 'Trigger trg_update_ThamGia created'
GO

-- INSTEAD OF DELETE trigger for v_ThamGia
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_delete_ThamGia')
    DROP TRIGGER trg_delete_ThamGia;
GO

CREATE TRIGGER trg_delete_ThamGia ON v_ThamGia
INSTEAD OF DELETE AS
BEGIN
    SET NOCOUNT ON;

    -- Delete from Site1_DB
    DELETE FROM Site1_DB.dbo.ThamGia
    WHERE EXISTS (
        SELECT 1 FROM deleted d
        WHERE Site1_DB.dbo.ThamGia.MaNV = d.MaNV
        AND Site1_DB.dbo.ThamGia.MaDeAn = d.MaDeAn
    );

    -- Delete from Site2_DB
    DELETE FROM Site2_DB.dbo.ThamGia
    WHERE EXISTS (
        SELECT 1 FROM deleted d
        WHERE Site2_DB.dbo.ThamGia.MaNV = d.MaNV
        AND Site2_DB.dbo.ThamGia.MaDeAn = d.MaDeAn
    );

    PRINT 'Trigger trg_delete_ThamGia executed'
END;
GO
PRINT 'Trigger trg_delete_ThamGia created'
GO

-- =============================================================================
-- 9. INSERT SAMPLE DATA
-- =============================================================================

PRINT 'Inserting sample data...'
GO

USE Global_DB;
GO

-- Insert sample research groups via global view
INSERT INTO v_NhomNC (MaNhom, TenNhom, TenPhong) VALUES
('N01', N'Nhóm Trí Tuệ Nhân Tạo', 'P1'),
('N02', N'Nhóm Xử Lý Ngôn Ngữ Tự Nhiên', 'P1'),
('N03', N'Nhóm An Ninh Mạng', 'P2'),
('N04', N'Nhóm Cơ Sở Dữ Liệu Phân Tán', 'P2');
GO

PRINT 'Sample groups inserted'
GO

-- Insert sample employees via global view
INSERT INTO v_NhanVien (MaNV, TenNV, NgaySinh, DiaChi, MaNhom) VALUES
('NV001', N'Nguyễn Văn An', '1985-05-15', N'Hà Nội', 'N01'),
('NV002', N'Trần Thị Bình', '1990-08-20', N'Hà Nội', 'N01'),
('NV003', N'Lê Văn Cường', '1988-03-10', N'Đà Nẵng', 'N02'),
('NV004', N'Phạm Thị Dung', '1992-11-25', N'TP.HCM', 'N02'),
('NV005', N'Hoàng Văn Em', '1987-07-08', N'TP.HCM', 'N03'),
('NV006', N'Vũ Thị Phượng', '1991-12-15', N'Hải Phòng', 'N03'),
('NV007', N'Đỗ Văn Giang', '1989-09-30', N'Cần Thơ', 'N04'),
('NV008', N'Mai Thị Hoa', '1993-04-05', N'Nha Trang', 'N04');
GO

PRINT 'Sample employees inserted'
GO

-- Insert sample projects via global view
INSERT INTO v_DeAn (MaDeAn, TenDeAn, KinhPhi, NgayBD, NgayKT, MaNhom) VALUES
('DA001', N'Phát triển hệ thống chatbot thông minh', 500000000, '2024-01-01', '2024-12-31', 'N01'),
('DA002', N'Ứng dụng AI trong y tế', 800000000, '2024-02-01', '2025-01-31', 'N01'),
('DA003', N'Hệ thống dịch tự động tiếng Việt', 600000000, '2024-03-01', '2024-11-30', 'N02'),
('DA004', N'Phân tích sentiment mạng xã hội', 400000000, '2024-04-01', '2024-10-31', 'N02'),
('DA005', N'Xây dựng firewall thế hệ mới', 700000000, '2024-01-15', '2024-12-15', 'N03'),
('DA006', N'Hệ thống phát hiện xâm nhập', 550000000, '2024-05-01', '2025-04-30', 'N03'),
('DA007', N'Cơ sở dữ liệu phân tán cho BigData', 900000000, '2024-02-15', '2025-02-14', 'N04'),
('DA008', N'Tối ưu hóa truy vấn phân tán', 450000000, '2024-06-01', '2024-12-31', 'N04');
GO

PRINT 'Sample projects inserted'
GO

-- Insert sample participations via global view
-- Same-site participations
INSERT INTO v_ThamGia (MaNV, MaDeAn, ThoiGian) VALUES
('NV001', 'DA001', 160),
('NV002', 'DA001', 120),
('NV001', 'DA002', 100),
('NV003', 'DA003', 140),
('NV004', 'DA003', 130),
('NV004', 'DA004', 90),
('NV005', 'DA005', 150),
('NV006', 'DA005', 140),
('NV005', 'DA006', 110),
('NV007', 'DA007', 170),
('NV008', 'DA007', 160),
('NV008', 'DA008', 100);
GO

-- Cross-site participations (employees from one site working on projects from another site)
INSERT INTO v_ThamGia (MaNV, MaDeAn, ThoiGian) VALUES
('NV001', 'DA005', 80),  -- Employee from P1 working on P2 project
('NV005', 'DA002', 70),  -- Employee from P2 working on P1 project
('NV003', 'DA007', 60);  -- Employee from P1 working on P2 project
GO

PRINT 'Sample participations inserted'
GO

-- Insert a project without any participants (for Form 3 query)
INSERT INTO v_DeAn (MaDeAn, TenDeAn, KinhPhi, NgayBD, NgayKT, MaNhom) VALUES
('DA009', N'Nghiên cứu Blockchain trong giáo dục', 350000000, '2024-07-01', '2025-06-30', 'N01');
GO

PRINT 'Project without participants inserted'
GO

PRINT '=============================================================================';
PRINT 'DATABASE SETUP COMPLETED SUCCESSFULLY!';
PRINT '=============================================================================';
PRINT 'Site1_DB: Contains data for P1 (Phòng 1)';
PRINT 'Site2_DB: Contains data for P2 (Phòng 2)';
PRINT 'Global_DB: Contains global views and triggers for distributed access';
PRINT '=============================================================================';
GO
