# Prompt hồ sơ dự án v2 — Elevator AI / Sunybot

_Cập nhật: 2026-04-12_

## Prompt chuẩn cho chat mới
```text
Đây là project Elevator AI / Sunybot ở trạng thái v2.

Sự thật cốt lõi:
- CV là service riêng ở 8001.
- Backend/UI chính ở 8000.
- Win11 chạy Ollama LAN là phương án chính.
- Jetson local LLM là phương án backup.
- Không dùng dashboard CV làm UI chính.
- Dữ liệu camera phải lấy từ elevator_cv hoặc CV API thật.

Hãy làm theo quy tắc:
1) xác định runtime thật trước
2) chỉ ra file bắt buộc sửa
3) chỉ ra file có thể bị ảnh hưởng
4) chỉ ra file không nên sửa
5) nếu sửa code thì trả full file hoặc patch rõ ràng
6) nếu sửa phần vận hành thì phải đọc script start/stop/app-icon trước
7) không sửa dist/build/cache nếu source gốc còn
```

## Khi task liên quan LAN
Yêu cầu chat xác minh:
- IP Win11 hiện tại
- `OLLAMA_HOST` đang set trong `.env.llm.lan`
- `run_backend_auto.sh`
- `start_ollama_lan.ps1`

## Khi task liên quan Start/Stop
Yêu cầu chat đọc:
- `start_project_desktop.sh`
- `stop_project_desktop.sh`
- `ElevatorAI-Start.desktop`
- `ElevatorAI-Stop.desktop`
