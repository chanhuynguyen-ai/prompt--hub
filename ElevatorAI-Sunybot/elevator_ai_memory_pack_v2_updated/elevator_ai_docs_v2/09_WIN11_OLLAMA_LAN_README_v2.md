# Win11 Ollama LAN README v2

_Cập nhật: 2026-04-12_

## Mục tiêu
Dùng Win11 làm LLM server qua LAN để Jetson gọi được.

## File chính
- `start_ollama_lan.ps1`

## Script này làm gì?
- dừng Ollama cũ nếu có
- set `OLLAMA_HOST=0.0.0.0:11434`
- mở firewall 11434
- chạy `ollama serve`
- test `/api/tags`
- in IPv4 hiện tại của Win11
- kiểm tra:
  - `qwen2.5:3b-instruct`
  - `nomic-embed-text`

## Cách chạy
```powershell
powershell -ExecutionPolicy Bypass -File C:\scripts\start_ollama_lan.ps1 -KeepWindowOpen
```

## Test trên Win11
```powershell
curl.exe http://127.0.0.1:11434/api/tags
```

## Test từ Jetson
```bash
curl http://<WIN11_IP>:11434/api/tags
curl -s http://<WIN11_IP>:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen2.5:3b-instruct","prompt":"Xin chao, ban la ai?","stream":false}'
```

## Khi đổi mạng
- IP Win11 có thể đổi
- Start desktop wrapper trên Jetson sẽ hỏi/xác nhận lại IP
- script sẽ tự cập nhật `.env.llm.lan`

## Khuyến nghị
Cho script chạy qua Task Scheduler khi login Windows.
