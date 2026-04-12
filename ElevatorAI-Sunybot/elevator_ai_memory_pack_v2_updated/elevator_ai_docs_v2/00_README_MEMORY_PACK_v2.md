# Elevator AI / Sunybot — Memory Pack v2

_Cập nhật: 2026-04-12_

## Mục đích
Bộ tài liệu này là phiên bản nâng cấp của memory pack cũ, phản ánh trạng thái mới nhất của project sau khi đã chốt:

- CV chạy thành **service riêng** trên Jetson ở port `8001`
- backend/UI chính chạy ở port `8000`
- LLM qua **LAN từ Win11** là phương án chính
- LLM local trên Jetson là **phương án dự phòng**
- đã có script vận hành, app-icon desktop, và wrapper start/stop rõ ràng

## Sự thật cốt lõi đã chốt
1. **CV không chạy chung process với backend/LLM**.
2. **Dữ liệu camera/realtime phải lấy từ `elevator_cv` hoặc CV API**, không để LLM tự suy đoán.
3. **UI chính là UI ở `8000`**, không dùng dashboard CV làm frontend chính.
4. **LAN-first, local-backup** là mô hình vận hành chính thức hiện tại.
5. **App-icon đã là một phần của runtime vận hành**, không còn chỉ là phụ trợ.

## Thứ tự đọc khuyến nghị
1. `00_README_MEMORY_PACK_v2.md`
2. `03_LLM_AND_PROJECT_RUNTIME_v2.md`
3. `02_CV_MODULE_STATUS_v2.md`
4. `01_DATABASE_MASTER_GUIDE_v2.md`
5. `04_PROJECT_PROGRESS_AND_NEXT_STEPS_v2.md`
6. `07_OPERATIONAL_CHEAT_SHEET_v2.md`
7. `08_APP_ICON_GUIDE_v2.md`
8. `09_WIN11_OLLAMA_LAN_README_v2.md`
9. `10_PROJECT_FILE_MAP_v2.md`
10. `11_PROJECT_PROMPT_v2.md`
11. `05_CLAUDECODE_STYLE_CHAT_GUIDE_v2.md`
12. `06_PROJECT_SKILL_STYLE_MEMORY_v2.md`

## Nếu mở chat mới
Hãy dán prompt sau:

```text
Đây là bộ memory pack v2 của project Elevator AI / Sunybot.
Hãy đọc theo thứ tự:
1) 00_README_MEMORY_PACK_v2.md
2) 03_LLM_AND_PROJECT_RUNTIME_v2.md
3) 02_CV_MODULE_STATUS_v2.md
4) 01_DATABASE_MASTER_GUIDE_v2.md
5) 04_PROJECT_PROGRESS_AND_NEXT_STEPS_v2.md
6) 07_OPERATIONAL_CHEAT_SHEET_v2.md
7) 08_APP_ICON_GUIDE_v2.md
8) 09_WIN11_OLLAMA_LAN_README_v2.md
9) 10_PROJECT_FILE_MAP_v2.md
10) 11_PROJECT_PROMPT_v2.md
11) 05_CLAUDECODE_STYLE_CHAT_GUIDE_v2.md
12) 06_PROJECT_SKILL_STYLE_MEMORY_v2.md

Quy tắc:
- Ưu tiên hiểu runtime thật trước khi sửa.
- CV là service riêng ở 8001.
- Backend/UI chính ở 8000.
- LLM chính chạy qua LAN từ Win11.
- Local LLM chỉ là backup.
- Không sửa dist/build/cache nếu source gốc còn.
- Với dữ liệu camera, phải query SQL/API CV thật.
```

## Tóm tắt hiện trạng
- CV: gần mức demo mạnh, tập trung person / bottle / fall / lying / overload / occupancy
- LLM/backend: đã có LAN mode, fallback local, router/tool/query rõ hơn
- UI/vận hành: đã có `start_all.sh`, `stop_all.sh`, app-icon Start/Stop/Open/Managed
- Win11: đã có `start_ollama_lan.ps1` để bật Ollama LAN nhanh

## Ghi chú
Bản v2 này nên được xem là **trạng thái chuẩn mới** của project.
