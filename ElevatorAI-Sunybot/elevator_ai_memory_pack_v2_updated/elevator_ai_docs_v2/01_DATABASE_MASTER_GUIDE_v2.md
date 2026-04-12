# Database Master Guide v2 — Elevator AI / Sunybot

_Cập nhật: 2026-04-12_

## Mục tiêu
Tài liệu này chốt lại database theo trạng thái vận hành mới nhất.

## Kiến trúc DB hiện tại
Project hiện tách theo hai cụm dữ liệu chính:

### 1) `elevator_cv` — PostgreSQL cho CV realtime
Dùng cho:
- `camera_events`
- `camera_occupancy_samples`
- `person_registry`
- `face_embeddings` (giữ như future work/optional)

### 2) `elevator_llm` — PostgreSQL cho backend/chatbot vận hành mới
Dùng cho:
- knowledge/FAQ
- prompt-answer logic
- embeddings text
- chat/runtime support data nếu cần

## Quy tắc sử dụng
- Hỏi về camera / density / fall / overload -> `elevator_cv`
- Hỏi FAQ / nghiệp vụ / chatbot -> `elevator_llm`
- Không trộn logic CV và knowledge trong cùng bảng nếu không thật sự cần

## Bảng CV chính
### `camera_events`
Lưu:
- `event_ts`
- `cam_id`
- `event_type`
- `track_id`
- `person_name`
- `bbox`
- `people_count`
- `confidence`
- `extra`

### `camera_occupancy_samples`
Lưu:
- `sample_ts`
- `cam_id`
- `people_count`
- `unknown_count`
- `lying_count`
- `fall_count`
- `extra`

### `person_registry`
Giữ cho registry định danh, nhưng hiện tại không phải trọng tâm runtime.

### `face_embeddings`
Giữ cho future work / optional demo.

## Schema CV gọn khuyến nghị
```sql
CREATE TABLE IF NOT EXISTS person_registry (
    person_id SERIAL PRIMARY KEY,
    person_code TEXT UNIQUE,
    full_name TEXT NOT NULL,
    department TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS face_embeddings (
    embedding_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL REFERENCES person_registry(person_id) ON DELETE CASCADE,
    embedding FLOAT8[] NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS camera_events (
    event_id BIGSERIAL PRIMARY KEY,
    event_ts TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    cam_id TEXT NOT NULL,
    event_type TEXT NOT NULL,
    track_id TEXT,
    person_id INT,
    person_name TEXT,
    bbox JSONB,
    posture TEXT,
    people_count INT,
    confidence REAL,
    snapshot_path TEXT,
    extra JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS camera_occupancy_samples (
    sample_id BIGSERIAL PRIMARY KEY,
    sample_ts TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    cam_id TEXT NOT NULL,
    people_count INT NOT NULL DEFAULT 0,
    unknown_count INT NOT NULL DEFAULT 0,
    sitting_count INT NOT NULL DEFAULT 0,
    lying_count INT NOT NULL DEFAULT 0,
    fall_count INT NOT NULL DEFAULT 0,
    extra JSONB DEFAULT '{}'::jsonb
);
```

## User / database khuyến nghị
```sql
CREATE ROLE elevator_ai WITH LOGIN PASSWORD 'elevator123';
ALTER ROLE elevator_ai CREATEDB;

CREATE DATABASE elevator_cv OWNER elevator_ai;
CREATE DATABASE elevator_llm OWNER elevator_ai;
```

## Cách kiểm tra nhanh
### Vào DB CV
```bash
psql -h 127.0.0.1 -p 5432 -U elevator_ai -d elevator_cv
```

### Vào DB LLM
```bash
psql -h 127.0.0.1 -p 5432 -U elevator_ai -d elevator_llm
```

### Xem bảng
```sql
\dt
```

### Xem 20 event mới nhất
```sql
SELECT event_ts, cam_id, event_type, person_name, people_count
FROM camera_events
ORDER BY event_ts DESC
LIMIT 20;
```

### Xem occupancy mới nhất
```sql
SELECT sample_ts, cam_id, people_count, lying_count, fall_count
FROM camera_occupancy_samples
ORDER BY sample_ts DESC
LIMIT 20;
```

### Đếm số lần FALL hôm nay
```sql
SELECT COUNT(*) AS so_lan_te_nga
FROM camera_events
WHERE event_type = 'FALL'
  AND event_ts::date = CURRENT_DATE;
```

## Vận hành DB hằng ngày
- backup `elevator_cv`
- backup `elevator_llm`
- test vài câu SQL sau mỗi lần start hệ thống
- trước khi reset DB phải backup

## Backup nhanh
```bash
pg_dump -h 127.0.0.1 -p 5432 -U elevator_ai -Fc -d elevator_cv -f elevator_cv.dump
pg_dump -h 127.0.0.1 -p 5432 -U elevator_ai -Fc -d elevator_llm -f elevator_llm.dump
```

## Kết luận
Ở v2:
- `elevator_cv` là nguồn sự thật cho CV realtime
- `elevator_llm` là DB logic riêng của chatbot/backend vận hành
