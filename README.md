Về bối cảnh chho một bài toán thực tế, ta sẽ quản lý "Doanh số bán hàng và Dịch vụ hậu mãi" cho một công ty bán du thuyền. Công ty sẽ bán nhiều loại du thuyền và cung cấp dịch vụ hậu mãi như bảo trì, sửa chữa động cơ, tùy chỉnh, và bảo dưỡng mùa đông.

Danh mục các Table trong Database:

1.Sales: Lưu trữ dữ liệu bán hàng từ 01/01/2021 đến 01/02/2025. 
  + Partition (RANGE) theo năm từ 2021 -> 2023

2.Boats: Chứa thông tin chi tiết về du thuyền (Phân loại, Lớp, Hãng sản xuất, Ngày sản xuất, Trọng tải,... trong đó, ngày sản xuất sẽ nằm trong khoảng 01/01/2020 -> 01/05/2024
  + Sử dụng Composite Partition, kết hợp giữa INTERVAL PARTITION trên cột " Ngày sản xuất " đi kèm với LIST SUBPARTITION trên cột " Phân loại "

3.Dịch vụ hậu mãi: Lưu trữ lịch sử về các loại hình dịch vụ đã thực hiện (Ngày thực hiện, Loại hình dịch vụ, Giá)
  + Sử dụng Composite Partition, sử dụng 2 lần RANGE PARTITION trên cột " Ngày thực hiện " để phân vùng theo các năm, và mỗi năm sẽ được chia thành 4 quý

4.Inventory: Theo dõi lượng tồn kho của từng loại du thuyền 

5.Quản lý nhân viên: Theo dõi thông tin nhân viên, bao gồm tên, số điện thoại, và ngày sinh.
