# LLM and Main Project Runtime v2 — Elevator AI / Sunybot

_Cập nhật: 2026-04-12_

## Runtime thật đã chốt
### Backend chính
```bash
python -m uvicorn backend.api:app --host 0.0.0.0 --port 8000
```

### CV service
```bash
python -m uvicorn app.api:app --host 0.0.0.0 --port 8001
```

## Mô hình mới
- CV ở `8001`
- backend/UI chính ở `8000`
- Win11 chạy Ollama LAN
- Jetson gọi LLM qua `OLLAMA_HOST`
- local LLM là backup

## Luồng chính
```text
User
  -> backend/api.py
  -> ChatbotEngine.handle()
  -> router/customer/maintenance
  -> tool/query DB hoặc semantic/LLM
  -> trả lời
```

## Quy tắc router đã chốt
- `customer`: không trả dữ liệu camera nhạy cảm
- `maintenance`: được phép hỏi CV analytics
- CV query phải đi qua DB/API thật
- FAQ/project knowledge đi qua knowledge DB/semantic layer
- fallback cuối mới gọi LLM

## Cấu hình môi trường quan trọng
- `OLLAMA_HOST`
- `LLM_MODEL`
- `EMBED_MODEL`
- `CV_SERVICE_BASE_URL`
- `PGHOST`
- `PGPORT`
- `PGDATABASE` / DB names logic liên quan

## `OLLAMA_HOST` hiện dùng thế nào
- LAN mode: `http://<WIN11_IP>:11434`
- Local backup: `http://127.0.0.1:11434`

## LLM mode
### LAN mode — chính
- model generate: `qwen2.5:3b-instruct`
- model embedding: `nomic-embed-text`

### Local mode — backup
- khuyến nghị model generate nhẹ hơn nếu cần fallback thực sự ổn định
- vẫn giữ `nomic-embed-text`

## Tool/query layer
Nên có và tiếp tục giữ:
- `get_today_fall_count`
- `get_recent_cv_events`
- `get_peak_hour`
- `get_daily_density`
- `get_latest_person_seen`
- `tool_answer_cv_query`

## Kết nối đúng với CV
Backend chính không nhét CV vào cùng process.
Nó gọi:
- CV API qua `CV_SERVICE_BASE_URL`
- và/hoặc query `elevator_cv` bằng SQL khi cần

## UI chính
UI production của người dùng cuối là UI từ backend `8000`, không phải dashboard riêng của CV.

## Đánh giá tiến độ
LLM/backend hiện ở mức: **82–86%**

## Kết luận
Trạng thái v2 đã đưa project từ chatbot FAQ + CV rời rạc sang một runtime hybrid rõ ràng:
- CV riêng
- backend riêng
- LLM LAN riêng
- local fallback
