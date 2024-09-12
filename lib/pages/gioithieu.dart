import 'package:assets_manager/component/background.dart';
import 'package:flutter/material.dart';

class GioiThieu extends StatelessWidget {
  const GioiThieu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giới Thiệu Quản Lí Tài Sản"),
      ),
      body: SafeArea(
        child: Background(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Đơn Vị Thực Hiện:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 24,
                  ),
                ),
                Divider(color: Colors.grey),
                Container(
                  padding: EdgeInsets.all(12.0),
                  width: double.infinity,
                  height: 200,
                  child: Image.asset('assets/images/logo3.png'),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  width: double.infinity,
                  child: Text(
                    "ĐẠI HỌC TRẦN ĐẠI NGHĨA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 24,
                    ),
                  ),
                ),
                Text(
                  "Sinh Viên Thực Hiện: "
                  "\n\t\t\t\t\t\tHọ và Tên:Võ Nguyễn Xuân Hào"
                  "\n\t\t\t\t\t\tMSSV: 17DDS0703109"
                  "\n\t\t\t\t\t\tLớp: 17DDS07031"
                  "\n\t\t\t\t\t\tKhoa: Công Nghệ Thông Tin"
                  "\n\t\t\t\t\t\tTrường Đại Học Trần Đại Nghĩa",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Divider(color: Colors.grey),
                Text(
                  "Giảng Viên Hướng Dẫn: "
                  "\n\t\t\t\t\t\tTS. Phùng Thế Bảo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Ứng Dụng:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 24,
                  ),
                ),
                Divider(color: Colors.grey),
                Container(
                  padding: EdgeInsets.all(12.0),
                  width: double.infinity,
                  height: 200,
                  child: Image.asset('assets/images/Logo.png'),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 12.0),
                  width: double.infinity,
                  child: Text(
                    "QUẢN LÍ TÀI SẢN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 24,
                    ),
                  ),
                ),
                Text(
                  "\t\t\t\t\t\tNgày nay, cùng với sự phát triển của đất nước, ngành Công nghệ thông tin đã có những bước phát triển mạnh mẽ không ngừng và tin học đã trở thành chiếc chìa khóa dẫn đến thành công cho nhiều cá nhân trong nhiều lĩnh vực, hoạt động. Với những ứng dụng của mình, ngành Công nghệ thông tin đã góp phần mang lại nhiều lợi ích mà không ai có thể phủ nhận được. Đặc biệt là trong lĩnh vực quản lý tài sản, tin học đã góp phần tạo ra sự thay đổi nhanh chóng cho bộ mặt xã hội. Nhất là khi việc tin học hóa vào công tác quản lý, nói chung và quản lý tài sản cố định cho một cơ quan doanh nghiệp là một trong những yêu cầu cần thiết hiện nay."
                  "\n\t\t\t\t\t\tCông tác quản lý tài sản cố định hiện nay cần rất nhiều giấy tờ, sổ sách, biên bản. Vì vậy kéo theo một khối lượng công việc lớn và phức tạp. Khi xây dựng một hệ thống quản lý thì toàn bộ các quy trình sẽ được tự động hóa. Khi sử dụng chương trình quản lý tài sản cố định thì các đối tượng sẽ được giảm thiểu các thao tác phải làm và thu được hiệu quả cao một cách nhanh chóng."
                  "\n\t\t\t\t\t\tNgười quản lý tài sản cố định dễ dàng trong việc nhập tài sản cố định cũng như bàn giao và luân chuyển tài sản cố định về các phòng ban. Dễ dàng trong việc quản lý, bảo trì và sữa chữa tài sản cố định. Tiến hành kiểm kê và đưa ra các báo cáo một cách nhanh chóng, chính xác cho lãnh đạo cơ quan, doanh nghiệp."
                  "\n\t\t\t\t\t\tĐối với lãnh đạo cơ quan doanh nghiệp trong việc quản lý tài sản cố định sẽ nhanh chóng biết được hiện trạng, tình hình sử dụng của tài sản cố định để đưa ra các kế hoạch bảo hành, bảo trì sữa chữa bổ dung. Qua đó đảm bảo việc sử dụng tài chính một cách tiết kiệm, có hiệu quả nhất, nâng cao khả năng sử dụng tài sản cố định."
                  "\n\t\t\t\t\t\tTừ những ứng dụng quản lý giúp cho công việc quản lý tài sản cố định trở nên nhanh chóng và dễ dàng. Chính vì lợi ích của ứng dụng mang lại mà các cơ quan, doanh nghiệp đã áp dụng nó để phát triển công việc quản lý, bảo trì và vận hành tài sản. Do vậy, em lựa chọn đề tài xây dựng ứng dụng quản lý tài sản cố định nhằm đưa đến cho khách hàng một chương trình quản lý, bảo trì, vận hành và thanh lí tài sản một cách có hiệu quả nhất.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Kết Luận:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 24,
                  ),
                ),
                Divider(color: Colors.grey),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  "\t\t\t\t\t\tNội dung của đồ án bao gồm nghiên cứu lý thuyết và xây dựng ứng dụng di động. Về lý thuyết, Phần tổng quan trình bày về kiến thức cơ bản của hệ điều hành Android và công nghệ Flutter. Phần phân tích thiết kế hệ thống thì trình bày phân tích hiện trạng, phân tích, thiết kế chức năng và dữ liệu của hệ thống. Về xây dựng ứng dụng di động:\n",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Kết Quả: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "\t\t\t\t\t\t-	Hoàn thành cơ bản các chức năng của bài toán quản lý tài sản cố định."
                  "\n\t\t\t\t\t\t-	Hiển thị danh sách các danh mục từ điển: tài sản, phòng ban, hợp đồng, …"
                  "\n\t\t\t\t\t\t-	Chuyển đổi tài sản giữa các phòng ban."
                  "\n\t\t\t\t\t\t-	Xây dựng được chức năng tính khấu hao và giá trị thanh lý tài sản."
                  "\n\t\t\t\t\t\t-	Thống kê tình trạng sử dụng."
                  "\n\t\t\t\t\t\t-	Xuất các báo cáo ra file PDF."
                  "\n\t\t\t\t\t\t-	Xây dựng các chức năng cơ bản cho người dùng như đăng kí, đăng nhập, quên mật khẩu, đổi mật khẩu, …"
                  "\n\t\t\t\t\t\t",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Song, cũng có vài hạn chế như sau:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "\t\t\t\t\t\t-	Chưa quản lý tài sản theo danh mục từ điển."
                  "\n\t\t\t\t\t\t-	Chưa tạo được hóa đơn xuất/ nhập, chuyển đổi danh sách tài sản giữa các phòng ban."
                  "\n\t\t\t\t\t\t-	Phân quyền chưa chi tiết với người sử dụng, xác thực người dùng còn kém.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "\nHướng Phát Triển",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "\t\t\t\t\t\tHiện nay các doanh nghiệp đang có kế hoạch sử dụng phần mềm tin học ứng dụng trong quản lý TSCĐ. Trong ứng dụng công nghệ thông tin, quản lý TSCĐ là một trong những chương trình có tính thực tế cao. Chính vì thế, em sẽ cố gắng khắc phục những nhược điểm, thêm những chức năng ưu việt và chỉnh sửa cho chương trình trở nên chuyên nghiệp hơn. Hoàn thiện chương trình để chương trình có tính khả thi cao, áp dụng rộng rãi trong doanh nghiệp.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
