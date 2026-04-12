# App Icon Guide v2 — Elevator AI / Sunybot

_Cập nhật: 2026-04-12_

## Mục tiêu
Đưa project vào chế độ dùng như app:
- có nút Start
- có nút Stop
- có nút Open Project
- có nút Managed

## Mở project nghĩa là gì?
Mở project = mở đúng UI tại:
```text
http://127.0.0.1:8000
```

## Phương án 1 — 3 nút
### `ElevatorAI-Start.desktop`
- gọi `start_project_desktop.sh`
- hỏi/xác nhận IP LAN
- start toàn bộ
- báo thành công
- chờ Enter rồi mới đóng terminal

### `ElevatorAI-Stop.desktop`
- gọi `stop_project_desktop.sh`
- stop toàn bộ
- kiểm tra lại `8000` và `8001`
- báo thành công
- chờ Enter rồi mới đóng terminal

### `ElevatorAI-OpenProject.desktop`
- chỉ mở `http://127.0.0.1:8000`

## Phương án 2 — Managed
### `ElevatorAI-Managed.desktop`
- start toàn bộ
- mở project
- khi đóng cửa sổ project -> stop all

## Quy tắc icon
- Start nên dùng icon “on”
- Stop nên dùng icon “off”
- sau khi sửa `.desktop`, chạy lại:
```bash
chmod +x ~/Desktop/TenFile.desktop
gio set ~/Desktop/TenFile.desktop metadata::trusted true
```

## Kết luận
Phương án 3 nút phù hợp để debug.
Phương án managed phù hợp để demo.
