---
name: elevator-ai-project-memory-v2
summary: bộ nhớ dự án kiểu skill-style cho Elevator AI / Sunybot phiên bản hybrid LAN runtime
---

# Elevator AI / Sunybot — Project Skill-Style Memory v2

## Sự thật cốt lõi
- CV là service riêng ở `8001`
- Backend/UI chính ở `8000`
- Win11 chạy Ollama LAN
- Jetson gọi LLM qua LAN là chính
- Local chỉ là backup
- UI chính hiển thị dữ liệu CV
- Dashboard CV chỉ là công cụ debug

## Quy tắc làm việc bắt buộc
1. Hiểu runtime thật trước khi sửa.
2. Không gộp CV vào cùng process với backend/LLM.
3. Không dùng `localhost` để ám chỉ Win11 từ phía Jetson.
4. Không để chatbot đoán dữ liệu CV.
5. Không sửa build/cache nếu source gốc còn.

## Khi sửa phần vận hành
Phải đọc trước:
- `run_backend_auto.sh`
- `start_all.sh`
- `stop_all.sh`
- desktop launchers
- `start_ollama_lan.ps1`

## Khi sửa phần backend/chatbot
Phải đọc trước:
- `backend/api.py`
- `backend/chatbot_engine.py`
- `backend/embedding_service.py`
- `backend/ollama_service.py`

## Khi sửa phần CV
Phải đọc trước:
- `app/api.py`
- `app/camera_service.py`
- `app/config.py`
- `app/db.py`

## Output mong muốn
1. tóm tắt hiểu biết
2. file bắt buộc sửa
3. file có thể bị ảnh hưởng
4. file không nên sửa
5. code/script hoàn chỉnh nếu sửa

## Kết luận
Bản v2 phải được coi là trạng thái chuẩn mới của project.
