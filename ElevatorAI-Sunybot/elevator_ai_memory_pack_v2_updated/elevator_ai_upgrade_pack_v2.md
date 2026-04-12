# Elevator AI / Sunybot — Project Upgrade Pack v2.0

## Mục tiêu của bản v2.0
Tài liệu này cập nhật toàn bộ project theo trạng thái mới nhất sau khi đã triển khai:

- CV service chạy riêng trên Jetson ở `8001`
- Main backend/UI chạy riêng ở `8000`
- LLM qua LAN từ Win11 là **phương án chính**
- LLM local trên Jetson là **phương án dự phòng**
- Có script vận hành tổng
- Có app-icon desktop
- Có managed mode / start-stop mode
- Có script Win11 để bật Ollama LAN

Tài liệu này được coi là **trạng thái mới nhất**, thay cho các bản mô tả cũ hơn.

---

# 1. Kiến trúc mới đã chốt

## 1.1 Kiến trúc production hiện tại

```text
Win11
  └─ Ollama LAN
     ├─ qwen2.5:3b-instruct
     └─ nomic-embed-text

Jetson Nano
  ├─ PostgreSQL
  │   ├─ elevator_cv
  │   └─ elevator_llm
  ├─ CV Service (port 8001)
  ├─ Main Backend/UI (port 8000)
  ├─ run_backend_auto.sh
  ├─ start_all.sh / stop_all.sh
  └─ app-icon desktop
```

## 1.2 Nguyên tắc kiến trúc
- Không gộp CV vào cùng process với backend/LLM.
- Không để LLM tự bịa dữ liệu camera.
- Câu hỏi CV phải đi qua DB/API CV.
- UI chính nằm ở backend `8000`.
- CV dashboard riêng chỉ dùng để debug khi cần.
- LAN mode là mode chính.
- Local mode là mode backup.

---

# 2. Runtime thật hiện tại

## 2.1 Win11
Win11 chỉ giữ vai trò:
- chạy Ollama
- bind LAN tại `0.0.0.0:11434`
- phục vụ Jetson qua mạng nội bộ

## 2.2 Jetson
Jetson chịu trách nhiệm:
- PostgreSQL
- CV service
- backend chính
- tool/query layer
- UI chính
- app-icon vận hành

## 2.3 Entry points
- CV:
  - `python -m uvicorn app.api:app --host 0.0.0.0 --port 8001`
- Main backend:
  - `python -m uvicorn backend.api:app --host 0.0.0.0 --port 8000`

---

# 3. Cấu hình đã chốt

## 3.1 `.env.cv.runtime`
Giữ theo hướng headless:
- `CV_DASHBOARD_ENABLED=0`
- `CV_BACKEND=trt`
- `ENABLE_POSE=true`
- `ENABLE_FACE=false`
- `YOLO_EVERY_N=2`
- `POSE_EVERY_N=4`
- `OVERLOAD_THRESHOLD=4`
- thêm rõ DB + API host/port

## 3.2 `.env.llm.lan`
Phương án chính:
- `OLLAMA_HOST=http://<WIN11_IP>:11434`
- `LLM_MODEL=qwen2.5:3b-instruct`
- `EMBED_MODEL=nomic-embed-text`

## 3.3 `.env.llm.local`
Phương án dự phòng:
- `OLLAMA_HOST=http://127.0.0.1:11434`
- khuyến nghị dùng model nhẹ hơn nếu fallback thực sự ổn định
- vẫn giữ `EMBED_MODEL=nomic-embed-text`

---

# 4. Script đã chốt

## 4.1 Trên Jetson
- `run_postgres.sh`
- `run_cv.sh`
- `run_backend_local.sh`
- `run_backend_lan.sh`
- `run_backend_auto.sh`
- `start_all.sh`
- `stop_all.sh`

## 4.2 Ý nghĩa
- `run_backend_auto.sh`:
  - hỏi/xác nhận IP LAN Win11
  - test LAN
  - nếu LAN OK -> dùng LAN
  - nếu LAN fail -> fallback local
- `start_all.sh`:
  - start PostgreSQL
  - start CV
  - start backend
- `stop_all.sh`:
  - stop CV/backend và process liên quan

---

# 5. App-icon desktop đã chốt

## 5.1 Chế độ 3 nút
- `ElevatorAI-Start.desktop`
- `ElevatorAI-Stop.desktop`
- `ElevatorAI-OpenProject.desktop`

## 5.2 Chế độ managed
- `ElevatorAI-Managed.desktop`

## 5.3 Hành vi đúng
### Start
- hỏi/xác nhận IP đang set trong `.env.llm.lan`
- cho phép nhập IP mới nếu cần
- test LAN trước khi vào backend
- start toàn bộ
- báo thành công
- chờ Enter rồi mới đóng terminal

### Stop
- stop toàn bộ
- kiểm tra lại `8000` và `8001`
- báo thành công
- chờ Enter rồi mới đóng terminal

### Open Project
- mở đúng `http://127.0.0.1:8000`

### Managed
- start toàn bộ
- mở project
- đóng cửa sổ project -> stop toàn bộ

---

# 6. Win11 Ollama LAN startup

## 6.1 Script chuẩn
- `start_ollama_lan.ps1`

## 6.2 Nhiệm vụ
- kill Ollama cũ nếu có
- set `OLLAMA_HOST=0.0.0.0:11434`
- mở firewall
- chạy `ollama serve`
- test `/api/tags`
- in IP hiện tại của Win11
- kiểm tra model generate + embedding

## 6.3 Khuyến nghị
- chạy bằng Task Scheduler khi login
- để Jetson luôn có sẵn server LLM LAN

---

# 7. Quy trình vận hành chuẩn mới

## 7.1 Trên Win11
1. bật máy
2. chạy `start_ollama_lan.ps1`
3. xác nhận:
   - `/api/tags` OK
   - IP hiện tại rõ ràng

## 7.2 Trên Jetson
1. bấm `ElevatorAI-Start.desktop`
2. xác nhận IP LAN hoặc nhập IP mới
3. backend test LAN
4. start toàn bộ hệ thống
5. mở project bằng:
   - `ElevatorAI-OpenProject.desktop`
   - hoặc `ElevatorAI-Managed.desktop`

## 7.3 Khi dừng
- bấm `ElevatorAI-Stop.desktop`
- hoặc đóng cửa sổ managed

---

# 8. Những gì đã được nâng cấp so với trạng thái cũ

## 8.1 Về kiến trúc
- Từ chỗ còn lẫn lộn runtime -> nay đã chốt rõ:
  - CV riêng
  - backend/UI riêng
  - LLM LAN riêng

## 8.2 Về hiệu năng
- Offload model nặng sang Win11
- Jetson giảm tải đáng kể
- CV mượt hơn, ít nguy cơ tràn RAM hơn

## 8.3 Về vận hành
- Có script startup/shutdown rõ ràng
- Có app-icon để dùng như app thật
- Có chế độ LAN/local fallback

## 8.4 Về độ ổn định
- Có cơ chế test LAN trước khi vào backend
- Có xác nhận IP trực tiếp
- Có stop wrapper để tránh “mở terminal rồi tắt liền”

---

# 9. Những gì được xem là đã hoàn thiện ở mức mạnh

## 9.1 CV
- kiến trúc service riêng
- DB PostgreSQL rõ
- stream/status/events/density
- runtime headless hợp lý cho Jetson

## 9.2 LLM/backend
- kiến trúc router + agent
- CV query tách khỏi FAQ/knowledge
- Ollama host cấu hình được
- LAN mode thực sự chạy được

## 9.3 Vận hành
- script tổng
- app-icon
- Win11 LAN startup
- fallback local

---

# 10. Những gì chưa nên coi là “done 100%”

## 10.1 Face recognition
- giữ trong code
- chưa phải runtime mặc định
- nên coi là future work hoặc optional demo

## 10.2 Frontend cleanup
- vẫn nên dọn tiếp phần legacy/source/build
- cần chốt UI nào là production rõ hơn nữa

## 10.3 Schema/runtime cleanup
- tiếp tục đối chiếu schema/chat_logs/prompts nếu cần
- khóa nốt flow chatbot production cho gọn hơn

## 10.4 Demo hardening
- nên test nhiều vòng:
  - Win11 online
  - Win11 offline
  - fallback local
  - restart sau khi đổi IP mạng

---

# 11. Đánh giá tiến độ mới (bản cập nhật)

## 11.1 CV
**85–88%**
- vì runtime, DB, API, headless mode, Jetson flow đã khá chắc
- phần còn lại là tuning và polishing

## 11.2 LLM / backend chính
**82–86%**
- vì LAN mode đã vào được hệ
- router/chatbot/DB/tool layer đã đúng hướng
- còn phần hardening và cleanup

## 11.3 Tích hợp tổng thể
**84–88%**
- vì CV + backend + LAN + UI + script vận hành đã gần thành một hệ
- còn phần test hồi quy và cleanup cuối

## 11.4 Toàn bộ project
**88–91%**
- đây là mức đánh giá mới sau khi đã hoàn thành:
  - vận hành LAN
  - fallback local
  - app-icon
  - start/stop wrapper
  - script Win11

---

# 12. Phiên bản mới nên được gọi là gì?

## Khuyến nghị đặt tên
**Elevator AI / Sunybot v2.0 — Hybrid LAN Runtime**

Tên này phản ánh đúng bản chất mới:
- Hybrid
- LAN-first
- Jetson + Win11
- CV service + backend service tách rõ

---

# 13. Checklist nghiệm thu v2.0

## Win11
- [ ] `start_ollama_lan.ps1` chạy OK
- [ ] `/api/tags` OK
- [ ] model generate OK
- [ ] embedding OK
- [ ] IP hiện tại được hiển thị đúng

## Jetson
- [ ] PostgreSQL start OK
- [ ] CV start OK
- [ ] backend start OK
- [ ] `run_backend_auto.sh` hỏi/xác nhận IP
- [ ] LAN thành công -> dùng LAN
- [ ] LAN fail -> fallback local

## UI
- [ ] Start icon hoạt động
- [ ] Stop icon hoạt động
- [ ] Open Project mở đúng `8000`
- [ ] Managed mode đóng cửa sổ là stop all

## Hệ thống
- [ ] `/health` OK
- [ ] `/api/integration/cv/status` OK
- [ ] chat API OK
- [ ] UI hiển thị đúng

---

# 14. Việc nên làm tiếp ngay sau v2.0

## Ưu tiên 1
- test hồi quy 3 mode:
  - LAN normal
  - LAN fail -> local fallback
  - restart full system

## Ưu tiên 2
- chụp/ghi lại toàn bộ:
  - ảnh UI
  - ảnh stream
  - ảnh event timeline
  - log backend
  - log CV
để phục vụ báo cáo và demo

## Ưu tiên 3
- dọn docs cũ, giữ v2.0 làm bản chuẩn chính

## Ưu tiên 4
- chốt bản báo cáo:
  - kiến trúc
  - công nghệ
  - tối ưu Jetson
  - mô hình hybrid LAN
  - lý do không chạy full local

---

# 15. Kết luận cuối

Project hiện tại đã vượt qua giai đoạn “ý tưởng / lắp ghép” và đã bước sang giai đoạn:

- có runtime thực
- có kiến trúc rõ
- có phương án vận hành thật
- có fallback
- có app-icon
- có mô hình hybrid đủ thuyết phục cho đồ án

Bản v2.0 này nên được xem là **mốc nâng cấp chính thức** của hệ thống.
