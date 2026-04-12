# Bộ câu hỏi tổng hợp để test full chức năng chatbot Sunybot

## 1. Mục tiêu của tài liệu
Tài liệu này tổng hợp các câu hỏi để test **toàn bộ chức năng chatbot** của hệ thống Sunybot theo 2 nhóm:

1. **Chatbot cho người dùng / khách hàng**
2. **Chatbot cho kỹ thuật viên / maintenance console**

Mục tiêu là để bạn có thể:
- test nhanh toàn bộ feature;
- phát hiện câu nào bị route sai;
- kiểm tra phần FAQ, trạng thái thang máy, gọi thang, an toàn, CV analytics, và debug kỹ thuật;
- dùng làm checklist trước khi demo hoặc nộp đồ án.

---

## 2. Cách dùng tài liệu này

### 2.1. Khi test chatbot cho người dùng
Nên gọi đúng endpoint / mode dành cho customer:
- scope: `customer`
- persona: `customer_assistant`

Mục tiêu của chatbot customer:
- trả lời FAQ về thang máy;
- hướng dẫn sử dụng;
- trả lời trạng thái công khai của thang máy;
- hỗ trợ lệnh gọi thang;
- hướng dẫn an toàn;
- **không** cung cấp dữ liệu camera nhạy cảm / nhận diện người / lịch sử giám sát.

### 2.2. Khi test chatbot cho kỹ thuật viên
Nên gọi đúng endpoint / mode dành cho maintenance:
- endpoint nên dùng: `/api/chat/maintenance`
- scope: `maintenance`
- persona: `maintenance_console`
- nếu cần debug: bật `include_trace = true`

Mục tiêu của chatbot maintenance:
- đọc dữ liệu từ `elevator_cv`;
- trả lời các câu hỏi về event, density, fall, lying, overload, occupancy;
- hỗ trợ debug agent, trace tool, memory, citations;
- hỗ trợ FAQ kỹ thuật và bảo trì.

---

## 3. Mẫu bảng ghi kết quả test
Bạn nên log theo mẫu sau:

| STT | Câu hỏi | Mode | Intent trả về | Source trả về | Đúng/Sai | Ghi chú |
|---|---|---|---|---|---|---|

---

# PHẦN A — BỘ CÂU HỎI CHO CHATBOT NGƯỜI DÙNG

## A1. Chào hỏi / small talk trong domain
1. Xin chào
2. Chào bạn
3. Hello Sunybot
4. Bạn là ai?
5. Bạn làm được gì?
6. Cảm ơn bạn
7. Tạm biệt

**Kỳ vọng:**
- trả lời lịch sự, ngắn gọn;
- không lan man ngoài domain;
- không nhảy sang trạng thái thang máy.

---

## A2. Định nghĩa / kiến thức cơ bản về thang máy
8. Thang máy là gì?
9. Bạn biết gì về thang máy?
10. Cấu tạo của thang máy gồm những gì?
11. Nguyên lý hoạt động của thang máy là gì?
12. Cabin là gì?
13. Cửa tầng và cửa cabin khác nhau như thế nào?
14. Quá tải trong thang máy là gì?
15. Cảm biến cửa thang máy dùng để làm gì?
16. Vì sao thang máy cần bảo trì định kỳ?
17. Hệ thống thang máy thông minh là gì?

**Kỳ vọng:**
- đi vào FAQ / knowledge;
- không trả về trạng thái hiện tại;
- không trả lời kiểu “không có dữ liệu tham chiếu” nếu FAQ đã có.

---

## A3. Hướng dẫn sử dụng
18. Cách sử dụng thang máy như thế nào?
19. Làm sao để gọi thang máy?
20. Làm sao để chọn tầng?
21. Khi vào thang máy cần chú ý điều gì?
22. Có nên chèn cửa thang máy không?
23. Khi thang đang đông người thì nên làm gì?
24. Nếu tôi muốn đi lên tầng 7 thì làm thế nào?
25. Muốn xuống tầng 1 thì thao tác ra sao?
26. Khi mất điện thì thang máy xử lý thế nào?
27. Thang máy có tự dừng khi quá tải không?

**Kỳ vọng:**
- trả lời theo vai trò trợ lý hướng dẫn sử dụng;
- không nhảy sang emergency trừ khi câu hỏi thực sự là khẩn cấp;
- không trả lời ngoài phạm vi.

---

## A4. Trạng thái công khai của thang máy
28. Thang đang ở tầng mấy?
29. Thang máy 1 đang ở đâu?
30. Cửa đang mở hay đóng?
31. Hiện tại có bao nhiêu người trong thang?
32. Tình trạng quá tải hiện tại thế nào?
33. Thang đang đi lên hay đi xuống?
34. Trạng thái hiện tại của thang máy là gì?
35. Bây giờ thang máy có bình thường không?
36. Thang có đang quá tải không?
37. Cửa thang bây giờ mở hay đóng?

**Kỳ vọng:**
- phải đi đúng `elevator_status`;
- trả về floor / direction / door / people_count / overload hợp lý;
- không bị trả lời bằng FAQ chung chung.

---

## A5. Gọi thang / điều hướng cabin
38. Gọi thang tại tầng 3
39. Gọi tôi lên tầng 7
40. Đưa tôi tới tầng 5
41. Cho thang xuống tầng 1
42. Thang máy 1 đưa tôi đến tầng 9
43. Gọi cabin tại tầng 2
44. Tôi muốn đi lên tầng 6
45. Tôi muốn xuống tầng trệt
46. Gọi thang giúp tôi
47. Cho thang tới tầng 4

**Kỳ vọng:**
- đi đúng `call_elevator`;
- hiểu được target_floor / from_floor theo cách nói tự nhiên;
- nếu thiếu thông tin thì hỏi lại hợp lý, không hỏi lại vô lý.

---

## A6. An toàn / sự cố / hướng dẫn khẩn cấp
48. Nếu bị kẹt trong thang máy thì phải làm gì?
49. Khi té ngã trong thang máy thì nên làm gì?
50. Khi thang máy quá tải thì nên xử lý thế nào?
51. Để an toàn khi đi thang máy thì nên làm gì?
52. Nút SOS dùng để làm gì?
53. Nếu cửa thang không mở thì phải làm gì?
54. Nếu mất điện khi đang đi thang thì sao?
55. Nếu có người ngất trong thang máy thì xử lý thế nào?
56. Khi có khói trong thang máy cần làm gì?
57. Cách giữ an toàn cho trẻ em khi đi thang máy là gì?

**Kỳ vọng:**
- trả lời như FAQ an toàn hoặc emergency guidance;
- không chặn nhầm thành truy cập CV;
- chỉ vào `emergency_support` khi đúng là tình huống khẩn cấp thực sự.

---

## A7. Liên hệ hỗ trợ / bảo trì
58. Cho tôi liên hệ bộ phận bảo trì
59. Nếu thang bị lỗi tôi cần liên hệ ai?
60. Khi có sự cố thì báo cho ai?
61. Tôi muốn gọi kỹ thuật viên
62. Cần hỗ trợ bảo trì thì làm thế nào?

**Kỳ vọng:**
- trả lời điều hướng hỗ trợ hợp lý;
- không nói kiểu mâu thuẫn “tôi sẽ liên lạc ngay” nếu hệ thống chưa có action thật.

---

## A8. Câu hỏi ngoài domain để test từ chối
63. Con chó có mấy chân?
64. Con mèo có mấy chân?
65. 1 năm có bao nhiêu ngày?
66. Bạn biết gì về xe tăng?
67. Bạn thích hoa không?
68. Hôm nay đội bóng nào thắng?
69. Cách nấu phở bò là gì?
70. Thời tiết ngày mai thế nào?

**Kỳ vọng:**
- từ chối lịch sự và nhất quán;
- không trả lời lung tung ngoài domain;
- không bị nhảy sang emergency hay elevator_status.

---

# PHẦN B — BỘ CÂU HỎI CHO CHATBOT KỸ THUẬT VIÊN / MAINTENANCE

## B1. Chào hỏi và xác nhận vai trò kỹ thuật viên
1. Xin chào kỹ thuật viên
2. Bạn đang ở chế độ nào?
3. Bạn có thể hỗ trợ gì cho bảo trì?
4. Hãy cho tôi biết các công cụ bạn có thể dùng
5. Cho tôi debug agent

**Kỳ vọng:**
- bot xác nhận mode maintenance;
- nếu bật trace thì có thể hiện tool / summary hợp lý.

---

## B2. Trạng thái CV realtime hiện tại
6. Trạng thái CV hiện tại là gì?
7. Camera hiện tại có online không?
8. Camera nào đang hoạt động?
9. Hiện tại có bao nhiêu người?
10. Hiện tại có bao nhiêu người chưa nhận diện?
11. Hiện tại có ai đang nằm không?
12. Hiện tại có cảnh báo té ngã không?
13. Có đang quá tải không?
14. FPS hiện tại là bao nhiêu?
15. Event gần nhất của camera là gì?

**Kỳ vọng:**
- lấy từ `camera_occupancy_samples` hoặc status CV;
- source nên là `CV_DB` / tool CV, không rơi về general_llm.

---

## B3. Event gần đây / timeline sự kiện
16. Sự kiện CV gần nhất là gì?
17. Cho tôi 5 sự kiện gần nhất
18. Có những cảnh báo nào vừa xảy ra?
19. Event FALL gần nhất là khi nào?
20. Event LYING gần nhất là khi nào?
21. Có event BOTTLE gần đây không?
22. Hãy liệt kê các event CROWD gần nhất
23. Camera 1 vừa ghi nhận gì?
24. Trong 24 giờ qua có event bất thường nào?
25. Có cảnh báo nào lặp lại nhiều lần không?

**Kỳ vọng:**
- bot query `camera_events`;
- câu trả lời phải gắn event_type, timestamp, cam_id nếu có.

---

## B4. Té ngã / lying / cảnh báo nguy hiểm
26. Hôm nay có bao nhiêu lần té ngã?
27. Hôm nay camera 1 có bao nhiêu lần té ngã?
28. Có bao nhiêu sự kiện lying hôm nay?
29. Té ngã xuất hiện nhiều nhất ở camera nào?
30. Lần té ngã gần nhất diễn ra lúc mấy giờ?
31. Có cảnh báo nguy hiểm nào cần ưu tiên xử lý?
32. Lỗi nổi bật hôm nay là gì?
33. Cảnh báo nào xuất hiện nhiều nhất hôm nay?
34. Cảnh báo nào nghiêm trọng nhất trong ngày?
35. Có ai đang ở trạng thái nguy hiểm không?

**Kỳ vọng:**
- đây là nhóm câu cực quan trọng;
- bot phải đọc được DB CV hoặc ít nhất route đúng sang tool CV;
- không trả lời kiểu customer assistant.

---

## B5. Density / peak hour / phân tích mật độ
36. Khung giờ đông nhất hôm nay là khi nào?
37. Camera 1 đông nhất lúc nào?
38. Mật độ 7 ngày gần đây thế nào?
39. Trung bình mỗi ngày có bao nhiêu người?
40. Đỉnh people_count lớn nhất là bao nhiêu?
41. Ngày nào đông nhất trong tuần qua?
42. Có xu hướng đông người vào khung giờ nào?
43. Cho tôi phân tích density 3 ngày gần đây
44. Mức độ quá tải xuất hiện vào thời điểm nào?
45. So sánh mật độ hôm nay với hôm qua

**Kỳ vọng:**
- đi đúng sang density / peak hour tool;
- trả lời từ `camera_occupancy_samples`.

---

## B6. Nhận diện người / registry / face-related (nếu có dữ liệu)
46. Người được nhận diện gần nhất là ai?
47. Camera vừa nhận diện ai?
48. Có bao nhiêu người đã được đăng ký trong registry?
49. Trong event gần đây có person_name nào không?
50. Có ai chưa được gán person_name không?
51. Có unknown person gần đây không?
52. Sự kiện nhận diện gần nhất xảy ra khi nào?
53. Có bản ghi face embedding nào mới không?
54. Person registry hiện có những ai?
55. Person nào xuất hiện gần nhất ở camera?

**Kỳ vọng:**
- nếu DB có dữ liệu thì trả lời từ DB;
- nếu chưa có dữ liệu thì nói rõ là chưa có dữ liệu, không bịa.

---

## B7. Debug agent / tool trace / citations / memory
56. Hãy debug agent cho truy vấn này
57. Tool nào đã được gọi cho câu hỏi vừa rồi?
58. Cho tôi xem tool trace của phiên hiện tại
59. Citation của câu trả lời vừa rồi là gì?
60. Memory summary hiện tại là gì?
61. Intent vừa rồi là gì?
62. Vì sao câu hỏi này lại rơi vào general_llm?
63. Hãy cho tôi biết source thật của câu trả lời này
64. Truy vết vì sao không đọc được DB CV
65. Hãy hiển thị chi tiết trace để debug

**Kỳ vọng:**
- chỉ dùng tốt khi gọi maintenance endpoint và bật `include_trace = true`;
- phù hợp cho kỹ thuật viên debug agent/router/tool.

---

## B8. Tích hợp chatbot với DB / service
66. CV service hiện có sẵn không?
67. Có kết nối được tới elevator_cv không?
68. DB elevator_cv đang có những bảng nào?
69. camera_events có dữ liệu mới không?
70. camera_occupancy_samples có đang tăng dữ liệu không?
71. Hệ thống đang đọc trạng thái từ CV service hay fallback?
72. people_count hiện lấy từ source nào?
73. Nếu CV service down thì hệ thống có fallback không?
74. health hiện tại của backend và CV service ra sao?
75. Công cụ nào đang dùng để đọc dữ liệu CV?

**Kỳ vọng:**
- hỗ trợ kỹ thuật viên kiểm tra tích hợp;
- không nên trả lời mơ hồ.

---

# PHẦN C — BỘ CÂU HỎI ĐẶC BIỆT ĐỂ TEST CÁC LỖI DỄ SAI

## C1. Các câu từng dễ bị nhảy sai intent
1. Thang máy là gì?
2. Cấu tạo của thang máy
3. Nếu bị kẹt trong thang máy thì phải làm gì?
4. Khi té ngã nên làm gì?
5. 1 năm có bao nhiêu ngày?
6. Con mèo có mấy chân?
7. Gọi tôi lên tầng 7
8. Tình trạng quá tải?
9. Cửa đang mở hay đóng?
10. Lỗi nào xuất hiện nhiều nhất?

**Mục tiêu:**
- xác nhận bot không còn route sai như trước.

---

# PHẦN D — KỊCH BẢN TEST THEO CHUỖI HỘI THOẠI

## D1. Kịch bản cho người dùng
1. Xin chào
2. Bạn là ai?
3. Thang máy là gì?
4. Thang đang ở tầng mấy?
5. Cửa đang mở hay đóng?
6. Gọi tôi lên tầng 7
7. Nếu bị kẹt trong thang máy thì phải làm gì?
8. Cảm ơn bạn

**Kỳ vọng:**
- hội thoại trơn tru;
- không lẫn FAQ với status;
- không lẫn safety với CV policy.

## D2. Kịch bản cho kỹ thuật viên
1. Xin chào kỹ thuật viên
2. Trạng thái CV hiện tại là gì?
3. Hôm nay có bao nhiêu lần té ngã?
4. Sự kiện gần nhất là gì?
5. Khung giờ đông nhất hôm nay là khi nào?
6. Cảnh báo nào cần ưu tiên xử lý?
7. Tool nào vừa được gọi?
8. Citation của câu vừa rồi là gì?

**Kỳ vọng:**
- maintenance route đúng;
- có trace / citation nếu bật debug;
- câu trả lời bám `elevator_cv`.

---

# PHẦN E — CHECKLIST ĐÁNH GIÁ CUỐI

## E1. Với chatbot người dùng
- [ ] Chào hỏi đúng
- [ ] FAQ đúng
- [ ] Hướng dẫn sử dụng đúng
- [ ] Trạng thái thang máy đúng
- [ ] Gọi thang đúng
- [ ] An toàn đúng
- [ ] Từ chối ngoài domain đúng
- [ ] Không lộ dữ liệu CV nhạy cảm

## E2. Với chatbot kỹ thuật viên
- [ ] Đọc được `elevator_cv`
- [ ] Trả lời được event gần nhất
- [ ] Trả lời được fall count
- [ ] Trả lời được peak hour
- [ ] Trả lời được density
- [ ] Trả lời được current occupancy
- [ ] Có trace tool khi cần
- [ ] Có citation khi cần
- [ ] Không rơi nhầm sang customer mode

---

# PHẦN F — GỢI Ý THỨ TỰ TEST NHANH TRƯỚC KHI DEMO

## Gói test nhanh 10 câu cho người dùng
1. Xin chào
2. Bạn là ai?
3. Thang máy là gì?
4. Cách sử dụng thang máy như thế nào?
5. Thang đang ở tầng mấy?
6. Cửa đang mở hay đóng?
7. Gọi tôi lên tầng 7
8. Nếu bị kẹt trong thang máy thì phải làm gì?
9. Nút SOS dùng để làm gì?
10. Con chó có mấy chân?

## Gói test nhanh 10 câu cho kỹ thuật viên
1. Xin chào kỹ thuật viên
2. Trạng thái CV hiện tại là gì?
3. Hiện tại có bao nhiêu người?
4. Hôm nay có bao nhiêu lần té ngã?
5. Sự kiện gần nhất là gì?
6. Lỗi nào xuất hiện nhiều nhất?
7. Cảnh báo nào cần ưu tiên xử lý?
8. Khung giờ đông nhất hôm nay là khi nào?
9. Tool nào vừa được gọi?
10. Citation của câu vừa rồi là gì?

---

## 4. Kết luận
Bộ câu hỏi này đủ để test gần như toàn bộ chức năng chính của chatbot Sunybot theo cả 2 mode:
- **người dùng**
- **kỹ thuật viên**

Bạn có thể dùng tài liệu này như:
- checklist test nội bộ;
- checklist demo trước hội đồng;
- checklist debug khi vá router / tool / DB integration;
- checklist regression sau mỗi lần sửa code.
