# Project Progress and Next Steps v2 — Elevator AI / Sunybot

_Cập nhật: 2026-04-12_

## Tiến độ mới nhất
### CV
**85–88%**
- service riêng
- Jetson/TensorRT rõ
- events/density/status/stream rõ
- headless mode tốt

### LLM / backend
**82–86%**
- router rõ
- LAN mode vào được hệ
- local backup có đường fallback
- app-icon/start-stop thực chiến

### Tích hợp tổng thể
**84–88%**
- Win11 + Jetson + CV + backend + UI + DB + scripts đã thành dòng chảy tương đối hoàn chỉnh

### Toàn project
**88–91%**

## Những gì đã hoàn thành thêm trong phiên gần đây
- Win11 Ollama LAN startup script
- Jetson `run_backend_auto.sh` có xác nhận IP LAN
- Start/Stop desktop wrappers
- app-icon mở project
- managed mode
- stop wrapper tránh hiện tượng terminal đóng liền
- thống nhất lại kiến trúc hybrid LAN runtime

## Next steps ưu tiên
### Ưu tiên 1 — Hồi quy hệ thống
- test LAN mode
- test local fallback
- test restart sau khi đổi IP mạng
- test start/stop bằng app-icon

### Ưu tiên 2 — Ổn định demo
- ghi lại ảnh/video demo
- chụp giao diện UI
- chụp event timeline / density / stream
- chụp Win11 Ollama LAN success
- chụp start/stop desktop flow

### Ưu tiên 3 — Dọn tài liệu cũ
- dùng v2 làm bản chuẩn
- giữ docs cũ như archive
- không tham chiếu nhầm trạng thái 60% cũ

### Ưu tiên 4 — Cleanup runtime
- rà lại file legacy/frontend source/dist
- chốt rõ file production
- dọn những phần không còn dùng trong bản demo chính

## Bản nộp mạnh nên thể hiện
- kiến trúc service tách rõ
- Jetson tối ưu headless CV
- LLM offload qua Win11 LAN
- local fallback
- app-icon vận hành như sản phẩm
- dữ liệu CV đi vào DB thật
- chatbot trả lời dựa trên DB/API thật

## Kết luận
Project đã ở giai đoạn hoàn thiện sản phẩm demo, không còn ở giai đoạn chọn hướng nữa.
