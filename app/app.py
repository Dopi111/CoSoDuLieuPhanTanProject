"""
Flask Application for Distributed Database System
Hệ thống quản lý nhóm nghiên cứu và đề án khoa học
"""

from flask import Flask, request, jsonify
import pyodbc
import os
import time

app = Flask(__name__)

# Database connection configuration
DB_SERVER = os.getenv('DB_SERVER', 'db')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'Your_S@trong_P@ssword1')
DB_USER = 'sa'
DB_NAME = 'Global_DB'

def get_db_connection():
    """Create and return a database connection"""
    max_retries = 5
    retry_delay = 2

    for attempt in range(max_retries):
        try:
            connection_string = (
                f'DRIVER={{ODBC Driver 17 for SQL Server}};'
                f'SERVER={DB_SERVER};'
                f'DATABASE={DB_NAME};'
                f'UID={DB_USER};'
                f'PWD={DB_PASSWORD}'
            )
            conn = pyodbc.connect(connection_string)
            return conn
        except pyodbc.Error as e:
            if attempt < max_retries - 1:
                print(f"Connection attempt {attempt + 1} failed. Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
            else:
                raise e

def dict_from_row(row, cursor):
    """Convert database row to dictionary"""
    return dict(zip([column[0] for column in cursor.description], row))

# =============================================================================
# HEALTH CHECK
# =============================================================================

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        cursor.close()
        conn.close()
        return jsonify({
            'status': 'healthy',
            'database': 'connected',
            'message': 'Distributed Database System is running'
        }), 200
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'database': 'disconnected',
            'error': str(e)
        }), 500

# =============================================================================
# CRUD OPERATIONS FOR NhomNC (Research Groups)
# =============================================================================

@app.route('/nhomnc', methods=['GET'])
def get_all_nhomnc():
    """Get all research groups"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM v_NhomNC")
        rows = cursor.fetchall()
        result = [dict_from_row(row, cursor) for row in rows]
        cursor.close()
        conn.close()
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/nhomnc/<manhom>', methods=['GET'])
def get_nhomnc(manhom):
    """Get a specific research group by ID"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM v_NhomNC WHERE MaNhom = ?", manhom)
        row = cursor.fetchone()
        if row:
            result = dict_from_row(row, cursor)
            cursor.close()
            conn.close()
            return jsonify(result), 200
        else:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Research group not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/nhomnc', methods=['POST'])
def create_nhomnc():
    """Create a new research group"""
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO v_NhomNC (MaNhom, TenNhom, TenPhong) VALUES (?, ?, ?)",
            data['MaNhom'], data['TenNhom'], data['TenPhong']
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Research group created successfully', 'data': data}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/nhomnc/<manhom>', methods=['PUT'])
def update_nhomnc(manhom):
    """Update a research group"""
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE v_NhomNC SET TenNhom = ?, TenPhong = ? WHERE MaNhom = ?",
            data['TenNhom'], data['TenPhong'], manhom
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Research group updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/nhomnc/<manhom>', methods=['DELETE'])
def delete_nhomnc(manhom):
    """Delete a research group"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM v_NhomNC WHERE MaNhom = ?", manhom)
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Research group deleted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# =============================================================================
# CRUD OPERATIONS FOR NhanVien (Employees)
# =============================================================================

@app.route('/nhanvien', methods=['GET'])
def get_all_nhanvien():
    """Get all employees"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM v_NhanVien")
        rows = cursor.fetchall()
        result = [dict_from_row(row, cursor) for row in rows]
        cursor.close()
        conn.close()
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/nhanvien/<manv>', methods=['GET'])
def get_nhanvien(manv):
    """Get a specific employee by ID"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM v_NhanVien WHERE MaNV = ?", manv)
        row = cursor.fetchone()
        if row:
            result = dict_from_row(row, cursor)
            cursor.close()
            conn.close()
            return jsonify(result), 200
        else:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Employee not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/nhanvien', methods=['POST'])
def create_nhanvien():
    """Create a new employee"""
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO v_NhanVien (MaNV, TenNV, NgaySinh, DiaChi, MaNhom) VALUES (?, ?, ?, ?, ?)",
            data['MaNV'], data['TenNV'], data.get('NgaySinh'), data.get('DiaChi'), data['MaNhom']
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Employee created successfully', 'data': data}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/nhanvien/<manv>', methods=['PUT'])
def update_nhanvien(manv):
    """Update an employee"""
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE v_NhanVien SET TenNV = ?, NgaySinh = ?, DiaChi = ?, MaNhom = ? WHERE MaNV = ?",
            data['TenNV'], data.get('NgaySinh'), data.get('DiaChi'), data['MaNhom'], manv
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Employee updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/nhanvien/<manv>', methods=['DELETE'])
def delete_nhanvien(manv):
    """Delete an employee"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM v_NhanVien WHERE MaNV = ?", manv)
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Employee deleted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# =============================================================================
# CRUD OPERATIONS FOR DeAn (Projects)
# =============================================================================

@app.route('/dean', methods=['GET'])
def get_all_dean():
    """Get all projects"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM v_DeAn")
        rows = cursor.fetchall()
        result = [dict_from_row(row, cursor) for row in rows]
        cursor.close()
        conn.close()
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/dean/<madean>', methods=['GET'])
def get_dean(madean):
    """Get a specific project by ID"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM v_DeAn WHERE MaDeAn = ?", madean)
        row = cursor.fetchone()
        if row:
            result = dict_from_row(row, cursor)
            cursor.close()
            conn.close()
            return jsonify(result), 200
        else:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Project not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/dean', methods=['POST'])
def create_dean():
    """Create a new project"""
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO v_DeAn (MaDeAn, TenDeAn, KinhPhi, NgayBD, NgayKT, MaNhom) VALUES (?, ?, ?, ?, ?, ?)",
            data['MaDeAn'], data['TenDeAn'], data.get('KinhPhi'),
            data.get('NgayBD'), data.get('NgayKT'), data['MaNhom']
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Project created successfully', 'data': data}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/dean/<madean>', methods=['PUT'])
def update_dean(madean):
    """Update a project"""
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE v_DeAn SET TenDeAn = ?, KinhPhi = ?, NgayBD = ?, NgayKT = ?, MaNhom = ? WHERE MaDeAn = ?",
            data['TenDeAn'], data.get('KinhPhi'), data.get('NgayBD'),
            data.get('NgayKT'), data['MaNhom'], madean
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Project updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/dean/<madean>', methods=['DELETE'])
def delete_dean(madean):
    """Delete a project"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM v_DeAn WHERE MaDeAn = ?", madean)
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Project deleted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# =============================================================================
# CRUD OPERATIONS FOR ThamGia (Participation)
# =============================================================================

@app.route('/thamgia', methods=['GET'])
def get_all_thamgia():
    """Get all participations"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM v_ThamGia")
        rows = cursor.fetchall()
        result = [dict_from_row(row, cursor) for row in rows]
        cursor.close()
        conn.close()
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/thamgia/<manv>/<madean>', methods=['GET'])
def get_thamgia(manv, madean):
    """Get a specific participation"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM v_ThamGia WHERE MaNV = ? AND MaDeAn = ?", manv, madean)
        row = cursor.fetchone()
        if row:
            result = dict_from_row(row, cursor)
            cursor.close()
            conn.close()
            return jsonify(result), 200
        else:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Participation not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/thamgia', methods=['POST'])
def create_thamgia():
    """Create a new participation"""
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO v_ThamGia (MaNV, MaDeAn, ThoiGian) VALUES (?, ?, ?)",
            data['MaNV'], data['MaDeAn'], data.get('ThoiGian')
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Participation created successfully', 'data': data}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/thamgia/<manv>/<madean>', methods=['PUT'])
def update_thamgia(manv, madean):
    """Update a participation"""
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE v_ThamGia SET ThoiGian = ? WHERE MaNV = ? AND MaDeAn = ?",
            data['ThoiGian'], manv, madean
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Participation updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/thamgia/<manv>/<madean>', methods=['DELETE'])
def delete_thamgia(manv, madean):
    """Delete a participation"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM v_ThamGia WHERE MaNV = ? AND MaDeAn = ?", manv, madean)
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Participation deleted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# =============================================================================
# SPECIAL QUERIES (According to project01.html)
# =============================================================================

@app.route('/query/form1/<manhom>', methods=['GET'])
def query_form1(manhom):
    """
    Form 1: Đề án có nhân viên từ nhóm nghiên cứu khác tham gia
    (Projects with employees from other research groups participating)
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Query to find projects that have participants from different groups
        query = """
        SELECT DISTINCT d.MaDeAn, d.TenDeAn, d.MaNhom as MaNhomChuDe,
               nv.MaNV, nv.TenNV, nv.MaNhom as MaNhomNhanVien
        FROM v_DeAn d
        INNER JOIN v_ThamGia tg ON d.MaDeAn = tg.MaDeAn
        INNER JOIN v_NhanVien nv ON tg.MaNV = nv.MaNV
        WHERE d.MaNhom = ? AND nv.MaNhom != d.MaNhom
        ORDER BY d.MaDeAn, nv.MaNV
        """

        cursor.execute(query, manhom)
        rows = cursor.fetchall()
        result = [dict_from_row(row, cursor) for row in rows]
        cursor.close()
        conn.close()

        return jsonify({
            'message': f'Projects of group {manhom} with participants from other groups',
            'count': len(result),
            'data': result
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/query/form2', methods=['PUT'])
def query_form2():
    """
    Form 2: Cập nhật phòng của nhóm nghiên cứu
    (Update department/room of a research group)
    Input: {"MaNhom": "N01", "TenPhongMoi": "P2"}
    """
    try:
        data = request.json
        manhom = data.get('MaNhom')
        tenphongmoi = data.get('TenPhongMoi')

        if not manhom or not tenphongmoi:
            return jsonify({'error': 'MaNhom and TenPhongMoi are required'}), 400

        conn = get_db_connection()
        cursor = conn.cursor()

        # Get current group info
        cursor.execute("SELECT * FROM v_NhomNC WHERE MaNhom = ?", manhom)
        row = cursor.fetchone()
        if not row:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Research group not found'}), 404

        old_data = dict_from_row(row, cursor)

        # Update the group's department
        cursor.execute(
            "UPDATE v_NhomNC SET TenPhong = ? WHERE MaNhom = ?",
            tenphongmoi, manhom
        )
        conn.commit()

        # Get updated data
        cursor.execute("SELECT * FROM v_NhomNC WHERE MaNhom = ?", manhom)
        row = cursor.fetchone()
        new_data = dict_from_row(row, cursor)

        cursor.close()
        conn.close()

        return jsonify({
            'message': f'Research group {manhom} department updated successfully',
            'old_data': old_data,
            'new_data': new_data
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/query/form3', methods=['GET'])
def query_form3():
    """
    Form 3: Đề án chưa có nhân viên tham gia
    (Projects without any employee participation)
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        query = """
        SELECT d.*
        FROM v_DeAn d
        WHERE NOT EXISTS (
            SELECT 1 FROM v_ThamGia tg WHERE tg.MaDeAn = d.MaDeAn
        )
        ORDER BY d.MaDeAn
        """

        cursor.execute(query)
        rows = cursor.fetchall()
        result = [dict_from_row(row, cursor) for row in rows]
        cursor.close()
        conn.close()

        return jsonify({
            'message': 'Projects without any employee participation',
            'count': len(result),
            'data': result
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/query/form4/<manhom>', methods=['PUT'])
def query_form4(manhom):
    """
    Form 4: Cập nhật phòng của nhóm từ P1 sang P2
    (Update research group department from P1 to P2)
    This demonstrates the automatic data migration via triggers
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Get current group info
        cursor.execute("SELECT * FROM v_NhomNC WHERE MaNhom = ?", manhom)
        row = cursor.fetchone()
        if not row:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Research group not found'}), 404

        old_data = dict_from_row(row, cursor)
        old_phong = old_data['TenPhong']

        if old_phong != 'P1':
            cursor.close()
            conn.close()
            return jsonify({
                'error': f'Group is currently in {old_phong}, not P1. This operation is specifically for P1 -> P2 migration.'
            }), 400

        # Get counts before migration
        cursor.execute("SELECT COUNT(*) as count FROM v_NhanVien WHERE MaNhom = ?", manhom)
        nhanvien_count = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) as count FROM v_DeAn WHERE MaNhom = ?", manhom)
        dean_count = cursor.fetchone()[0]

        cursor.execute("""
            SELECT COUNT(*) as count FROM v_ThamGia tg
            INNER JOIN v_NhanVien nv ON tg.MaNV = nv.MaNV
            WHERE nv.MaNhom = ?
        """, manhom)
        thamgia_count = cursor.fetchone()[0]

        # Update from P1 to P2 (trigger will handle the data migration)
        cursor.execute(
            "UPDATE v_NhomNC SET TenPhong = 'P2' WHERE MaNhom = ?",
            manhom
        )
        conn.commit()

        # Get updated data
        cursor.execute("SELECT * FROM v_NhomNC WHERE MaNhom = ?", manhom)
        row = cursor.fetchone()
        new_data = dict_from_row(row, cursor)

        cursor.close()
        conn.close()

        return jsonify({
            'message': f'Successfully migrated group {manhom} from P1 to P2',
            'old_data': old_data,
            'new_data': new_data,
            'migrated_records': {
                'employees': nhanvien_count,
                'projects': dean_count,
                'participations': thamgia_count
            },
            'info': 'All related employees, projects, and participations have been automatically moved from Site1_DB to Site2_DB via triggers'
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# =============================================================================
# ADDITIONAL UTILITY ENDPOINTS
# =============================================================================

@app.route('/stats', methods=['GET'])
def get_stats():
    """Get database statistics"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        stats = {}

        # Count groups by department
        cursor.execute("""
            SELECT TenPhong, COUNT(*) as count
            FROM v_NhomNC
            GROUP BY TenPhong
        """)
        stats['groups_by_department'] = [dict_from_row(row, cursor) for row in cursor.fetchall()]

        # Total counts
        cursor.execute("SELECT COUNT(*) as count FROM v_NhomNC")
        stats['total_groups'] = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) as count FROM v_NhanVien")
        stats['total_employees'] = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) as count FROM v_DeAn")
        stats['total_projects'] = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) as count FROM v_ThamGia")
        stats['total_participations'] = cursor.fetchone()[0]

        # Projects without participants
        cursor.execute("""
            SELECT COUNT(*) as count FROM v_DeAn d
            WHERE NOT EXISTS (SELECT 1 FROM v_ThamGia tg WHERE tg.MaDeAn = d.MaDeAn)
        """)
        stats['projects_without_participants'] = cursor.fetchone()[0]

        cursor.close()
        conn.close()

        return jsonify(stats), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/', methods=['GET'])
def home():
    """Home endpoint with API documentation"""
    return jsonify({
        'message': 'Distributed Database System - Research Group & Project Management',
        'version': '1.0',
        'endpoints': {
            'health': 'GET /health',
            'stats': 'GET /stats',
            'crud_operations': {
                'research_groups': {
                    'get_all': 'GET /nhomnc',
                    'get_one': 'GET /nhomnc/<manhom>',
                    'create': 'POST /nhomnc',
                    'update': 'PUT /nhomnc/<manhom>',
                    'delete': 'DELETE /nhomnc/<manhom>'
                },
                'employees': {
                    'get_all': 'GET /nhanvien',
                    'get_one': 'GET /nhanvien/<manv>',
                    'create': 'POST /nhanvien',
                    'update': 'PUT /nhanvien/<manv>',
                    'delete': 'DELETE /nhanvien/<manv>'
                },
                'projects': {
                    'get_all': 'GET /dean',
                    'get_one': 'GET /dean/<madean>',
                    'create': 'POST /dean',
                    'update': 'PUT /dean/<madean>',
                    'delete': 'DELETE /dean/<madean>'
                },
                'participations': {
                    'get_all': 'GET /thamgia',
                    'get_one': 'GET /thamgia/<manv>/<madean>',
                    'create': 'POST /thamgia',
                    'update': 'PUT /thamgia/<manv>/<madean>',
                    'delete': 'DELETE /thamgia/<manv>/<madean>'
                }
            },
            'special_queries': {
                'form1': 'GET /query/form1/<manhom> - Projects with participants from other groups',
                'form2': 'PUT /query/form2 - Update group department (Body: {MaNhom, TenPhongMoi})',
                'form3': 'GET /query/form3 - Projects without any participants',
                'form4': 'PUT /query/form4/<manhom> - Migrate group from P1 to P2'
            }
        },
        'database_architecture': {
            'Site1_DB': 'Contains data for department P1',
            'Site2_DB': 'Contains data for department P2',
            'Global_DB': 'Contains global views with INSTEAD OF triggers for automatic data routing'
        }
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
