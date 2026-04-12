# Project File Map v2 — Elevator AI / Sunybot

_Cập nhật: 2026-04-12_

## Các file production cần ưu tiên hiểu
### Backend chính
- `backend/api.py`
- `backend/chatbot_engine.py`
- `backend/embedding_service.py`
- `backend/ollama_service.py`

### CV
- `app/api.py`
- `app/camera_service.py`
- `app/config.py`
- `app/db.py`

### Runtime vận hành
- `run_postgres.sh`
- `run_cv.sh`
- `run_backend_auto.sh`
- `start_all.sh`
- `stop_all.sh`
- `start_project_desktop.sh`
- `stop_project_desktop.sh`
- `open_project_link.sh`
- `open_project_managed.sh`
- `start_ollama_lan.ps1`

## File entrypoint thật
- backend: `backend/api.py`
- CV: `app/api.py`

## File không nên sửa nếu source gốc còn
- `gui/web/dist/*`
- `__pycache__/*`
- `*.pyc`

## Logic v2 cần nhớ
- `start_all.sh` là script lõi, không nên hỏi IP tương tác
- hỏi IP phải nằm ở desktop wrapper
- `run_backend_auto.sh` chịu trách nhiệm chọn LAN/local
- Win11 script chịu trách nhiệm bật Ollama LAN

## Kết luận
Khi sửa project ở v2, phải hiểu thêm tầng “runtime script/app-icon”, không chỉ hiểu code backend/frontend như trước.
