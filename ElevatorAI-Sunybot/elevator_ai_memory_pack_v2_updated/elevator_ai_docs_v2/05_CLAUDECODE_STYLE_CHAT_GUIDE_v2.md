# ClaudeCode-Style Chat Guide v2

_Cập nhật: 2026-04-12_

## Mục tiêu
Hướng dẫn cách làm việc với LLM khi project đã có:
- CV service riêng
- backend riêng
- LAN/runtime hybrid
- nhiều tài liệu memory pack

## Quy tắc bắt buộc
1. Ưu tiên đọc runtime thật trước.
2. Không giả định `localhost` trên Jetson là Win11.
3. Với LLM LAN, luôn xác minh:
   - IP Win11 hiện tại
   - Ollama đang bind `0.0.0.0:11434`
   - firewall đã mở
4. Không để LLM tự bịa dữ liệu camera.
5. Nếu có app-icon/script, phải bám đúng file wrapper đang dùng thật.

## Cách giao task tốt nhất
Ví dụ tốt:
- “Đọc `run_backend_auto.sh`, `start_all.sh`, `ElevatorAI-Start.desktop` và sửa flow hỏi IP LAN.”
- “Đọc `app/api.py`, `camera_service.py`, `app/config.py`; tối ưu headless mode cho Jetson.”
- “Đọc `backend/api.py` và các route CV integration, chỉ ra file production và file legacy.”

## Khi làm việc với project hiện tại, nên yêu cầu LLM chỉ ra:
1. file bắt buộc sửa
2. file có thể bị ảnh hưởng
3. file không nên sửa
4. giả định nào đang dùng
5. output cuối là code, `.md`, shell script hay checklist

## Sai lầm cần tránh
- sửa dist thay vì source
- sửa `start_all.sh` để hỏi IP trong khi backend đang chạy background
- quên wrapper desktop
- nhầm dashboard CV là UI chính
- nhầm IP cũ ở công ty với IP mới ở nhà

## Kết luận
Ở v2, LLM nên được dùng như kỹ sư đồng hành:
- chẩn đoán runtime
- patch script
- chuẩn hóa tài liệu
- tạo checklist test
