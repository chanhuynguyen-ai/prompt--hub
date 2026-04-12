# Operational Cheat Sheet v2 — Elevator AI / Sunybot

_Cập nhật: 2026-04-12_

## Kiến trúc vận hành
### Win11
- chạy Ollama LAN
- `qwen2.5:3b-instruct`
- `nomic-embed-text`

### Jetson
- PostgreSQL
- CV service `8001`
- backend/UI `8000`

## File env
- `.env.cv.runtime`
- `.env.llm.local`
- `.env.llm.lan`

## Script chính
- `run_postgres.sh`
- `run_cv.sh`
- `run_backend_auto.sh`
- `start_all.sh`
- `stop_all.sh`

## Script desktop
- `start_project_desktop.sh`
- `stop_project_desktop.sh`
- `open_project_link.sh`
- `open_project_managed.sh`

## Win11
### Bật Ollama LAN
```powershell
powershell -ExecutionPolicy Bypass -File C:\scripts\start_ollama_lan.ps1 -KeepWindowOpen
```

### Test Win11
```powershell
curl.exe http://127.0.0.1:11434/api/tags
```

## Jetson
### Start full stack
```bash
cd ~/elevator_ai_project
./start_all.sh
```

### Stop full stack
```bash
cd ~/elevator_ai_project
./stop_all.sh
```

### Health
```bash
curl http://127.0.0.1:8000/health
curl http://127.0.0.1:8001/api/cv/status
```

## App-icon
### 3 nút
- Start Project
- Stop Project
- Open Project

### 1 nút managed
- Start -> open project -> close window -> stop all

## Khi IP Win11 đổi
- chạy Start desktop wrapper
- script sẽ hiện IP đang set
- Enter nếu đúng
- hoặc nhập IP mới
- script tự cập nhật `.env.llm.lan`
- test LAN rồi mới start backend

## Kết luận
Bản v2 đã có quy trình vận hành như một sản phẩm demo thực sự.
