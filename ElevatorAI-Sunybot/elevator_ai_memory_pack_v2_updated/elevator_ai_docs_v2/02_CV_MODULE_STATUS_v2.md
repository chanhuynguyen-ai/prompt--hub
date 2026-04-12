# CV Module Status v2 — Elevator CV Service trên Jetson Nano

_Cập nhật: 2026-04-12_

## Bản chất module CV hiện tại
CV hiện tại là một **service realtime độc lập** chạy trên Jetson Nano.

Nó chịu trách nhiệm:
- đọc camera CSI qua GStreamer
- detect person / bottle
- tracking
- pose logic cho lying / fall
- overload / occupancy
- ghi dữ liệu vào PostgreSQL `elevator_cv`
- expose API:
  - `/api/cv/status`
  - `/api/cv/stream`
  - `/api/cv/events`
  - `/api/cv/density`

## Những gì CV KHÔNG làm
- không làm knowledge/FAQ của chatbot
- không làm orchestration toàn bộ hệ
- không làm frontend chính cho người dùng cuối

## Chế độ vận hành đã chốt
### Headless mode
- `CV_DASHBOARD_ENABLED=0`
- UI chính xem dữ liệu CV qua backend/UI ở `8000`
- dashboard riêng của CV chỉ dùng để debug

## Scope feature chính của bản nộp
Ưu tiên:
- person
- bottle
- fall
- lying
- overload
- occupancy

Không lấy:
- face recognition realtime
- identity nâng cao
- sitting làm feature chính

## File lõi
- `main.py`
- `app/api.py`
- `app/camera_service.py`
- `app/config.py`
- `app/db.py`
- `app/runtime_trt.py`
- `app/posture.py`
- `app/tracker.py`

## Trạng thái thực tế
### Đã mạnh
- service hoá rõ
- TensorRT/Jetson flow rõ
- detect person / bottle
- events API
- density API
- PostgreSQL `elevator_cv`
- headless mode hợp lý
- tích hợp được vào UI chính

### Chưa nên coi là final 100%
- face registration/recognition realtime
- snapshot timeline đẹp
- tuning sâu hơn cho fall/lying
- polishing trực quan

## Cấu hình runtime gợi ý
```bash
export CV_DASHBOARD_ENABLED=0
export CV_BACKEND=trt
export ENABLE_POSE=true
export ENABLE_FACE=false

export DET_IMGSZ=320
export POSE_IMGSZ=384

export YOLO_EVERY_N=2
export POSE_EVERY_N=4
export OVERLOAD_THRESHOLD=4

export API_HOST=0.0.0.0
export API_PORT=8001
```

## Lệnh chạy thật
```bash
source ~/venvs/elevcv_36/bin/activate
cd ~/elevator_cv_jetson_bundle
source .env.cv.runtime
python -m uvicorn app.api:app --host 0.0.0.0 --port 8001
```

## Checklist test
- [ ] `/api/cv/status` OK
- [ ] `/api/cv/stream` OK
- [ ] `/api/cv/events` OK
- [ ] `/api/cv/density` OK
- [ ] `camera_events` tăng dòng
- [ ] `camera_occupancy_samples` tăng dòng

## Đánh giá tiến độ
CV hiện ở mức: **85–88%**

## Kết luận
CV đã đủ mạnh để trở thành module demo chính của đề tài, với trọng tâm là ổn định runtime và tích hợp vào hệ tổng.
