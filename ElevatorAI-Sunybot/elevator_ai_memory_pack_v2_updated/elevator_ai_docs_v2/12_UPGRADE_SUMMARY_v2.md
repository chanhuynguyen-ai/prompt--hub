# Upgrade Summary v2 — Elevator AI / Sunybot

_Cập nhật: 2026-04-12_

## Từ trạng thái cũ sang v2
### Trước đây
- CV và backend còn dễ bị nhìn như một khối
- LLM local nặng trên Jetson là hướng gây áp lực tài nguyên
- vận hành còn thủ công
- app-icon chưa hoàn chỉnh

### Bây giờ
- CV service riêng ở `8001`
- backend/UI riêng ở `8000`
- Win11 Ollama LAN là primary
- local Jetson là backup
- có start/stop wrappers
- có app-icon
- có managed mode
- có script Win11 startup

## Ý nghĩa nâng cấp
- giảm tải Jetson
- làm demo mượt hơn
- có cơ chế fallback
- vận hành giống sản phẩm hơn

## Tên bản hiện tại
**Elevator AI / Sunybot v2.0 — Hybrid LAN Runtime**
