abstract class CommonString {
  static const String ERROR = "Lỗi!";
  static const String CONTINUE = "Tiếp Tục";
  static const String ERROR_MESSAGE = "Có lỗi! Vui lòng thử lại sau.";
  static const String ERROR_USER_NOT_FOUND =
      "Tài khoản không tồn tại trên hệ thống hoặc đã bị xóa.";
  static const String ERROR_WRONG_PASSWORD = "Mật khẩu không hợp lệ.";
  static const String ERROR_UNKNOWN = "Địa chỉ Email không được trống.";
  static const String CANCEL = "Hủy";
  static const String OK = "Chấp nhận";
  static const String SUCCESS = "Thành công";
  static const String SAVE = "Lưu";
  static const String EMAIL_MASSAGE =
      "Đã gửi email thành công.\n Vui lòng kiểm tra Email để Đổi mật khẩu mới.";
  static const String UPDATE_PASSWORD_MASSAGE =
      "Đã cập nhật mật khẩu thành công.";
  static const String ERROR_MASSAGE_UPDATE_VALUE_ASSET =
      "Nguyên Giá hoặc Thời gian sử dụng phải cập nhật mới";
}

abstract class MassageDbString {
  static const String ADD_ASSET_SUCCESS = "Thêm Tài Sản Thành Công";
  static const String ADD_ASSET_ERROR = "Thêm Tài Sản Thất Bại";
  static const String ADD_ASSET_ERROR_DUPLICATE = "Mã Tài Sản Đã Tồn Tại";
  static const String ADD_CONTRACT_SUCCESS = "Thêm Hợp Đồng Thành Công";
  static const String ADD_CONTRACT_ERROR = "Thêm Hợp Đồng Thất Bại";
  static const String ADD_CONTRACT_ERROR_DUPLICATE =
      "Mã Hợp Đồng Cùng Ngày Ký Đã Tồn Tại";
  static const String ADD_DEPARTMENT_SUCCESS = "Thêm Phòng Ban Thành Công";
  static const String ADD_DEPARTMENT_ERROR = "Thêm Phòng Ban Thất Bại";
  static const String ADD_DEPARTMENT_ERROR_DUPLICATE =
      "Mã Phòng Ban Đã Tồn Tại";
  static const String ADD_DIARY_SUCCESS = "Thêm Khấu Hao Thành Công";
  static const String ADD_DIARY_ERROR = "Thêm Khấu Hao Thất Bại";
  static const String ADD_HISTORY_ASSET_SUCCESS =
      "Thêm Lịch Sử Tài Sản Thành Công";
  static const String ADD_HISTORY_ASSET_ERROR = "Thêm Lịch Sử Tài Sản Thất Bại";
  static const String GET_ASSET_TO_ID_SUCCESS =
      "Lấy Thông Tin Tài Sản Thành Công";
  static const String GET_ASSET_TO_ID_ERROR = "Lấy Thông Tin Tài Sản Thất Bại";
  static const String GET_LIST_ASSET_SUCCESS =
      "Lấy Danh Sách Tài Sản Thành Công";
  static const String GET_LIST_ASSET_ERROR = "Lấy Danh Sách Tài Sản Thất Bại";
  static const String GET_LIST_CONTRACT_SUCCESS =
      "Lấy Danh Sách Hợp Đồng Thành Công";
  static const String GET_LIST_CONTRACT_ERROR =
      "Lấy Danh Sách Hợp Đồng Thất Bại";
  static const String GET_LIST_DEPARTMENT_SUCCESS =
      "Lấy Danh Sách Phòng Ban Thành Công";
  static const String GET_LIST_DEPARTMENT_ERROR =
      "Lấy Danh Sách Phòng Ban Thất Bại";
  static const String GET_LIST_DIARY_SUCCESS =
      "Lấy Danh Sách Khấu Hao Thành Công";
  static const String GET_LIST_DIARY_ERROR = "Lấy Danh Sách Khấu Hao Thất Bại";
  static const String GET_LIST_HISTORY_ASSET_SUCCESS =
      "Lấy Danh Sách Lịch Sử Tài Sản Thành Công";
  static const String GET_LIST_HISTORY_ASSET_ERROR =
      "Lấy Danh Sách Lịch Sử Tài Sản Thất Bại";
  static const String UPDATE_ASSET_SUCCESS = "Cập Nhật Tài Sản Thành Công";
  static const String UPDATE_ASSET_ERROR = "Cập Nhật Tài Sản Thất Bại";
  static const String UPDATE_CONTRACT_SUCCESS = "Cập Nhật Hợp Đồng Thành Công";
  static const String UPDATE_CONTRACT_ERROR = "Cập Nhật Hợp Đồng Thất Bại";
  static const String UPDATE_DEPARTMENT_SUCCESS =
      "Cập Nhật Phòng Ban Thành Công";
  static const String UPDATE_DEPARTMENT_ERROR = "Cập Nhật Phòng Ban Thất Bại";
  static const String UPDATE_DIARY_SUCCESS = "Cập Nhật Khấu Hao Thành Công";
  static const String UPDATE_DIARY_ERROR = "Cập Nhật Khấu Hao Thất Bại";
  static const String DELETE_ASSET_SUCCESS = "Xóa Tài Sản Thành Công";
  static const String DELETE_ASSET_ERROR = "Xóa Tài Sản Thất Bại";
  static const String DELETE_CONTRACT_SUCCESS = "Xóa Hợp Đồng Thành Công";
  static const String DELETE_CONTRACT_ERROR = "Xóa Hợp Đồng Thất Bại";
  static const String DELETE_DEPARTMENT_SUCCESS = "Xóa Phòng Ban Thành Công";
  static const String DELETE_DEPARTMENT_ERROR = "Xóa Phòng Ban Thất Bại";
  static const String DELETE_DIARY_SUCCESS = "Xóa Khấu Hao Thành Công";
  static const String DELETE_DIARY_ERROR = "Xóa Khấu Hao Thất Bại";
}

abstract class SplashString {
  static const String ASSET_MANAGER_VI = "Quản Lí Tài Sản";
  static const String ASSET_MANAGER_EN = "ASSETS MANAGER";
  static const String WELCOME = "Chào mừng bạn đến với ...";
  static const String START = "Bắt đầu trải nghiệm >>>";
  static const String HAPPY = "Chúc bạn trải nghiệm vui vẻ !!!";
}

abstract class LoginString {
  static const String LOCALIZED_REASON = "Đăng nhập bằng Vân tay/Khuôn mặt";
  static const String ASSET_MANAGER_VI = "Quản Lí Tài Sản";
  static const String HINT_TEXT_EMAIL = "quanlytaisan2023@gmail.com";
  static const String LABEL_TEXT_EMAIL = "Nhập Email *";
  static const String HINT_TEXT_PASSWORD = "Aa@123";
  static const String LABEL_TEXT_PASSWORD = "Nhập Mật Khẩu *";
  static const String HAVE_ACCOUNT = "Bạn đã có tài khoản? Nhưng quên Mật Khẩu";
  static const String LOGIN_TEXT_BUTTON = "Đăng Nhập";
  static const String CREATE_ACCOUNT_TEXT_BUTTON = "Tạo Tài Khoản Mới";
  static const String LOADING = "Đang tải....";
  static const String FACE_ID = "Khuôn Mặt";
  static const String FINGER_PRINT = "Vân Tay";
  static const String FORGOT_PASSWORD = "Quên Mật Khẩu";
  static const String CONTENT_FORGOT_PASS =
      "Vui lòng nhập thông tin chính xác đã cung cấp trước đó. Chúng tôi sẽ gửi 1 email đến địa chỉ email đã đăng ký để cung cấp đường dẫn đổi mật khẩu.\n";
}

abstract class HomeString {
  static const String TITLE = "QUẢN LÝ TÀI SẢN";
  static const String ASSET = "Tài Sản";
  static const String DEPARTMENT = "Phòng Ban";
  static const String DEPRECIATION = "Khấu Hao";
  static const String UTILITIES = "Thêm";
}

abstract class AssetString {
  static const String TITLE = "QUẢN LÝ TÀI SẢN";
  static const String INFO_TITLE = "Thẻ Thông Tin Tài sản";
  static const String EDIT_TITLE = "Thông Tin Tài sản";
  static const String CONVERT_TITLE = "Chuyển Đổi Tài sản";
  static const String HISTORY_TITLE = "Lịch Sử Sử Dụng";
  static const String LIQUIDATION_TITLE = "Xác Nhận Thanh Lý";
  static const String DEPRECIATION_TRACKING_TITLE = "Sổ Theo dõi Khấu hao";
  static const String ASSET = "Tài Sản";
  static const String DEPARTMENT = "Phòng Ban";
  static const String DEPARTMENTS = "Phòng Ban: ";
  static const String DEPRECIATION = "Khấu Hao";
  static const String DEPRECIATION_ASSETS = "Khấu Hao Tài Sản";
  static const String UTILITIES = "Thêm";
  static const String LABEL_TEXT_NAME_ASSETS = "Tên Tài sản";
  static const String LABEL_TEXT_CODE = "Mã Tài sản";
  static const String LABEL_TEXT_DEPRECIATION = "Khấu Hao";
  static const String CHOOSE_DEPARTMENT = "Chọn Phòng Ban";
  static const String YEAR_OF_MANUFACTURE = "Ngày sản xuất:   ";
  static const String PRODUCING_COUNTRY = "Nước sản xuất";
  static const String CHOOSE_ASSET_GROUP = "Chọn Nhóm Tài Sản";
  static const String CHOOSE_CONTRACT_NAME = "Chọn Hợp Đồng";
  static const String ORIGINAL_PRICE = "Nguyên Giá";
  static const String ORIGINAL_PRICES = "Nguyên Giá: ";
  static const String USER_TIME = "Thời gian sử dụng: ";
  static const String MONTH = " Tháng";
  static const String NUMBER_USER_TIME = "Số tháng sử dụng:  ";
  static const String START_DATE = "Ngày bắt đầu:  ";
  static const String END_DATE = "Ngày kết thúc:  ";
  static const String AMOUNT = "Số lượng";
  static const String AMOUNT_CONVERT = "Số lượng muốn chuyển";
  static const String STATUS = "Tình Trạng:  ";
  static const String CHOOSE_STATUS = "Chọn Tình Trạng";
  static const String DETAIL = "Lý Do:  ";
  static const String CHOOSE_DETAIL = "Chọn Lý Do";
  static const List<String> LIST_STATUS = [
    "Đang Sử Dụng",
    "Ngừng Sử Dụng",
    "Mất Mát",
    "Hư Hỏng"
  ];
  static const List<String> LIST_DETAIL = [
    "Nâng Cấp Tài Sản",
    "Định Lại Tài Sản",
    "Chuyển Đổi Phòng Ban"
  ];
  static const String PURPOSE_OF_USING = "Mục đích sử dụng";
  static const String REQUIRE_NAME_ASSETS = " Vui lòng nhập Tên Tài Sản";
  static const String REQUIRE_CHOOSE_ASSET_GROUP_NAME =
      " Vui lòng chọn Nhóm Tài Sản";
  static const String REQUIRE_DEPARTMENT_NAME = " Vui lòng chọn Tên Phòng Ban";
  static const String REQUIRE_PRODUCING_COUNTRY =
      " Vui lòng nhập Nước Sản Xuất";
  static const String REQUIRE_ORIGINAL_PRICE = " Vui lòng nhập Nguyên Giá";
  static const String REQUIRE_AMOUNT = " Vui lòng nhập Số Lượng";
  static const String REQUIRE_DETAIL = " Vui lòng Chọn Lý do";
  static const String REQUIRE_CHOOSE_CONTRACT_NAME = " Vui lòng chọn Hợp Đồng ";
  static const String REQUIRE_STATUS = " Vui lòng chọn Tình Trạng ";
  static const String REQUIRE_PURPOSE_OF_USING =
      " Vui lòng nhập Mục đích sử dụng";
  static const String SUCCESS_MASSAGE = "Thêm tài sản thành công.";
  static const String ERROR_MASSAGE = "Thêm tài sản thất bại.";
  static const String CONVERT_ASSET = "Chuyển tài sản";
  static const String CONTENT_CONVERT_ASSET =
      "Bạn muốn chuyển toàn bộ hay một phần số lượng tài sản.";
  static const String ALL_CONVERT_ASSET = "Tất Cả.";
  static const String PART_CONVERT_ASSET = "Một Phần.";
  static const String CONVERT_SUCCESS_MASSAGE =
      "Chuyển đổi tài sản thành công.";
  static const String CONVERT_ERROR_MASSAGE = "Chuyển đổi tài sản thất bại.";
  static const String UPDATE_SUCCESS_MASSAGE = "Cập nhật tài sản thành công.";
  static const String UPDATE_ERROR_MASSAGE = "Cập nhật tài sản thất bại.";
  static const String UPDATE_VALUE_SUCCESS_MASSAGE =
      "Nâng Cấp tài sản thành công.";
  static const String UPDATE_VALUE_ERROR_MASSAGE = "Nâng cấp tài sản thất bại.";
  static const String CONFIRM_CONVERT_SUCCESS_MASSAGE =
      "Xác nhận chuyển đổi thành công.";
  static const String CONFIRM_CONVERT_ERROR_MASSAGE =
      "Xác nhận chuyển đổi thất bại.";
  static const String CHOOSE_TO_DEPARTMENT = "Từ Phòng Ban";
  static const String CHOOSE_FROM_DEPARTMENT = "Chọn Phòng Ban đến";
  static const String QUESTION_AMOUNT_CONVERT = "Bạn muốn chuyển bao nhiêu?";
  static const String EMPTY_DEPARTMENT_VALUE_CHECK =
      "Phòng Ban Nhận Không được trống";
  static const String EMPTY_DEPARTMENT_VALUE_DUPLICATE =
      "Phòng Ban Chuyển Không được trống";
  static const String ERROR_DEPARTMENT_NO_DUPLICATES =
      "Phòng Ban chuyển và Nhận không được giống nhau.";
  static const String EMPTY_AMOUNT = "Số lượng Nhận Không được trống";
  static const String EMPTY_AMOUNT_CONVERT = "Số lượng Chuyển Không được trống";
  static const String ERROR_CHECK_AMOUNT =
      "Số lượng chuyển phải nhỏ hơn số lượng hiện có.";
  static const String TITLE_HISTORY = "Lịch Sử Sử Dụng";
  static const String CONTENT_CONFIRM_TITLE_HISTORY =
      "Bạn có muốn xem lịch sử sử dụng không?.";
  static const String TITLE_CONFIRM_DELETE = "Xóa Tài Sản";
  static const String DETAIL_CONFIRM_DELETE =
      "Bạn có chắc chắn muốn xóa tài sản không?";
  static const String INFO_NAME_ASSETS = "Tên Tài sản";
  static const String INFO_DEPARTMENT = "Phòng Ban";
  static const String INFO_YEAR_OF_MANUFACTURE = "Năm SX";
  static const String INFO_PRODUCING_COUNTRY = "Nước SX";
  static const String INFO_ASSET_GROUP = "Nhóm Tài Sản";
  static const String INFO_CONTRACT_NAME = "Hợp Đồng";
  static const String INFO_ORIGINAL_PRICE = "Nguyên Giá";
  static const String INFO_USER_TIME = "Thời Gian SD (Tháng)";
  static const String INFO_MONTH = " Tháng";
  static const String INFO_AMOUNT = "Số lượng";
  static const String INFO_STATUS = "Tình Trạng";
  static const String INFO_PURPOSE_OF_USING = "Mục đích SD";
  static const String INFO_USER_EMAIL = 'Email TK Cập Nhật';
  static const String INFO_USER_NAME = 'Tên TK Cập Nhật';
  static const String INFO_TIME_UPDATE = 'Thời Gian Cập Nhật';
  static const String INFO_START_DATE = 'Ngày Bắt Đầu';
  static const String INFO_END_DATE = 'Ngày Kết Thúc';
  static const String INFO_DETAIL = 'Lý Do';
  static const String INFO_DEPRECIATION = 'Mức Khấu Hao';
  static const String INFO_ASSET_PART = 'Phần Thông Tin Tài Sản';
  static const String INFO_DEPRECIATION_PART = 'Phần Thông Tin Khấu hao';
  static const String INFO_DEPRECIATION_MOUNT = 'Mức Khấu Hao Hàng Tháng';
  static const String INFO_ACCUMULATED_DEPRECIATION = 'Khấu Hao Lũy Kế';
  static const String INFO_RESIDUAL_VALUE = 'Giá Trị Còn Lại';
  static const String BUTTON_TEXT_UPDATE_ASSET = 'Nâng Cấp Tài Sản';
  static const String BUTTON_TEXT_LIQUIDATION = 'Xác Nhận Thanh Lý';
  static const String BUTTON_TEXT_CONTINUE = 'Tiếp Tục';
}

abstract class DepartmentString {
  static const String TITLE_LIST_PAGE = "Danh Sách Phòng Ban";
  static const String EDIT_TITLE = "Thông Tin Phòng Ban";
  static const String DEPARTMENT = "Phòng Ban";
  static const String HINT_NAME_SEARCH = "Nhập tên phòng ban....";
  static const String NAME = "Tên phòng ban: ";
  static const String PHONE = "Số điện thoại: ";
  static const String ADDRESS = "Địa Chỉ: ";
  static const String TITLE_CONFIRM_DELETE = "Xóa Phòng Ban";
  static const String DETAIL_CONFIRM_DELETE =
      "Bạn có chắc chắn muốn xóa phòng ban không?";
  static const String LABEL_TEXT_NAME = "Tên Phòng Ban";
  static const String LABEL_TEXT_CODE = "Mã Phòng Ban";
  static const String LABEL_TEXT_PHONE = "Số Điện Thoại";
  static const String LABEL_TEXT_ADDRESS = "Địa Chỉ";
  static const String REQUIRE_NAME = " Vui lòng nhập Tên Phòng Ban";
  static const String REQUIRE_CODE = " Vui lòng nhập Mã Phòng Ban";
  static const String REQUIRE_PHONE = " Vui lòng nhập Số điện thoại";
  static const String REQUIRE_ADDRESS = " Vui lòng nhập Địa chỉ";
  static const String REQUIRE_PHONE_VALID = "Số điện thoại không đúng";
  static const String SUCCESS_MASSAGE = "Thêm Phòng Ban thành công.";
  static const String ERROR_MASSAGE = "Thêm Phòng Ban thất bại.";
  static const String UPDATE_SUCCESS_MASSAGE = "Cập nhật Phòng Ban thành công.";
  static const String UPDATE_ERROR_MASSAGE = "Cập nhật Phòng Ban thất bại.";
}

abstract class ContractString {
  static const String TITLE_LIST_PAGE = "Danh Sách Hợp Đồng";
  static const String EDIT_TITLE = "Thông Tin Hợp Đồng";
  static const String CONTRACT = "Hợp Đồng";
  static const String NUMBER_CONTRACT = "Số Hợp Đồng";
  static const String NAME_CONTRACT = "Tên Hợp Đồng";
  static const String SIGNING_DATE = "Ngày Ký: ";
  static const String EXPIRATION_DATE = "Ngày Hết Hạn: ";
  static const String SUPPLIER_NAME = "Chọn Nhà Cung Cấp";
  static const String DETAIL = "Nội Dung Trọng Tâm";
  static const String REQUIRE_NAME_CONTRACT = " Vui lòng nhập Tên Hợp Đồng";
  static const String REQUIRE_NUMBER_CONTRACT = " Vui lòng nhập Số Hợp Đồng";
  static const String REQUIRE_SIGNING_DATE = " Vui lòng Chọn Ngày Ký";
  static const String REQUIRE_SUPPLIER_NAME = " Vui lòng Chọn Ngày Ký";
  static const String REQUIRE_EXPIRATION_DATE =
      " Vui lòng nhập Chọn Ngày Hết Hạn";
  static const String REQUIRE_DETAIL = " Vui lòng nhập Nội Dung Trọng Tâm";
  static const String INFO_NUMBER_CONTRACT = "Số Hợp Đồng: ";
  static const String INFO_NAME_CONTRACT = "Tên Hợp Đồng: ";
  static const String INFO_SIGNING_DATE = "Ngày Ký: ";
  static const String INFO_EXPIRATION_DATE = "Ngày Hết hạn: ";
  static const String INFO_DETAIL = "Nội Dung Trọng Tâm: ";
  static const String TITLE_CONFIRM_DELETE = "Xóa Hợp Đồng";
  static const String DETAIL_CONFIRM_DELETE =
      "Bạn có chắc chắn muốn xóa hợp đồng không?";
  static const String SUCCESS_MASSAGE = "Thêm Hợp đồng thành công.";
  static const String ERROR_MASSAGE = "Thêm Hợp đồng thất bại.";
  static const String UPDATE_SUCCESS_MASSAGE = "Cập nhật Hợp đồng thành công.";
  static const String UPDATE_ERROR_MASSAGE = "Cập nhật Hợp đồng thất bại.";
  static const String HINT_SEARCH = "Nhập tên Hợp đồng....";
  static const String ADD_CONTRACT = "Thêm Hợp đồng....";
}

abstract class AppString {
  static const String LOGOUT = "Đăng Xuất";
  static const String CONTENT_LOGOUT = "Bạn có chắc chắn muốn đăng xuất không?";
  static const String EMPTY = "Vui lòng điền các trường thông tin bắt buộc";
  static const String EMPTY_EMAIL = "Vui lòng nhập email của bạn";
  static const String EMPTY_TEL = "Vui lòng nhập số điện thoại";
  static const String VALID_EMAIL =
      "Nhập đúng địa chỉ email và không có khoảng trống";
  static const String VALID_TEL = "Số điện thoại không hợp lệ";
  static const String VALID_VNID =
      "Mã số Nu Skin bắt đầu bằng \"VN\" viết hoa và không có khoảng trống";
  static const String ERROR = "Lỗi!";
  static const String ERROR_MESSAGE = "Có lỗi! Vui lòng thử lại";
  static const String SAVE_REQUEST = "Đang lưu";
  static const String SENDING_REQUEST = "Đang gửi yêu cầu";
  static const String OK = "Chấp nhận";
  static const String CANCEL = "Hủy";
  static const String SUCCESS = "Thành công";
  static const String ENTER_TEL = "Nhập số điện thoại *";
  static const String ENTER_EMAIL = "Nhập Email *";
  static const String EMPTY_CONTENT =
      "Vui lòng nhập thông tin và yêu cầu hỗ trợ";
  static const String RESOURCES = "Câu hỏi thường gặp";
  static const String SEARCH = "Tìm kiếm";
  static const String REPLY = "Trả lời";
  static const String SEND = "Gửi";
  static const String CONTENT_FORGOT_PASS =
      "Vui lòng nhập thông tin chính xác đã cung cấp trước đó. Chúng tôi sẽ gửi 1 email đến địa chỉ email đã đăng ký để cung cấp đường dẫn lấy lại mật khẩu";

  static const String TITLE_IMAGE = "HÌNH ẢNH ĐÍNH KÈM";
  static const String TITLE_VIDEO = "VIDEO ĐÍNH KÈM";
  static const String DELETE_HINT = "Bạn có muốn xóa?";
  static const String NO = "NO";
  static const String YES = "YES";
  static const String OK_EN = "OK";
  static const String IMAGE_SELECT = "Hình ảnh đã chọn";
  static const String VIDEO_SELECT = "Video đã chọn";
}

abstract class Message {
  static const String VALID_C_PASSWORD = "Vui lòng nhập đúng mật khẩu";
  static const String VALID_PASSWORD =
      "Mật khẩu 8 ký tự bao gồm chữ hoa, chữ thường và ký tự đặc biệt";
  static const String REQUIRE_PASSWORD = "Vui lòng nhập mật khẩu";
  static const String REQUIRE_USERNAME = "Vui lòng nhập tên tài khoản";
}
