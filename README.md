# Draw-Julia-Set — 用 ARM 組合語言畫出 Julia Set 碎形動畫

> 在 Raspberry Pi 上以 ARM 組合語言直接操作 Linux frame buffer，逐格計算並繪製 Julia Set 碎形動畫。
> 中原大學「組合語言與嵌入式系統」課堂期末專案。

![Language: ARM Assembly](https://img.shields.io/badge/language-ARM%20Assembly-blue)
![Language: C](https://img.shields.io/badge/language-C-555555)
![Platform: Raspberry Pi](https://img.shields.io/badge/platform-Raspberry%20Pi%20(armhf)-c51a4a)
![License: 未指定](https://img.shields.io/badge/license-未指定-lightgrey)

---

## 問題（這個程式做什麼）

這支程式在 **Raspberry Pi（ARM / Linux）** 上做兩件事:

1. **印出小組成員資料** — 透過命令列輸出隊名、成員姓名、輸入並加總三位成員的學號。
2. **繪製 Julia Set 碎形動畫** — 直接把畫面寫進 Linux 的 frame buffer 裝置 `/dev/fb0`,逐格改變碎形參數,在螢幕上播放一段連續變化的 Julia Set 碎形動畫。

它的重點不在「畫出漂亮的數學圖形」,而是把整段繪圖核心改用 **ARM 組合語言** 親手實作,藉此練習底層的記憶體配置、二維陣列定址與 frame buffer 操作。

## 方法與技術

這個專案是一個 **C 與 ARM 組合語言混合連結** 的程式:`main.c` 用 C 撰寫主流程與 frame buffer I/O,真正的運算與輸出核心則由 `.s` 組語檔提供,並由 C 呼叫。

底層 showcase 的重點:

- **直接操作 Linux frame buffer**
  `main.c` 以 `open("/dev/fb0", O_RDWR | O_SYNC)` 打開畫面裝置,把整張 `640 × 480` 的 RGB16(每像素 `int16_t`)畫格 `write()` 進去,再用 `lseek(fd, 0, SEEK_SET)` 把寫入位置歸零,迴圈下一格,形成動畫。

- **二維陣列的記憶體配置與手動定址(組語核心)**
  畫格在記憶體中是 `int16_t frame[480][640]` 的連續區塊。在 `drawJuliaSet.s` 的 `julia` 函式裡,像素位址是手動算出來的:`base + 1280*y + x*2`(一列 640 個像素 × 2 bytes = 1280 bytes),再用 `strh`(store halfword)寫入 16-bit 顏色值。這正是「掌握 ARM 記憶體配置與二維陣列位置計算」的具體展現。

- **整數定點運算實作 Julia Set 迭代**
  Julia Set 本來是複數浮點迭代 `z = z² + c`。這裡全部改用 **整數定點數** 近似(程式中以放大整數值與固定除數模擬小數),避免使用浮點數;除法則呼叫 ARM EABI 的 `__aeabi_idiv` 完成。每個像素最多迭代 255 次,依逃逸速度決定顏色。

- **ARM 組語慣用技巧**
  原始碼中刻意示範並以註解標記了多種題材:`stmfd/ldmfd` 進出堆疊保存暫存器、`__aeabi_idiv` 整數除法、條件執行(conditional execution)、多種定址模式(addressing mode)、第二運算元(operand2)的位移用法等。

- **以組語處理文字 I/O**
  `name.s`、`id.s` 直接呼叫 C 標準函式庫的 `printf` / `scanf`,在組語層完成姓名輸出、學號讀取與加總,並用條件執行處理「兩個學號相等時」的特殊加總邏輯。

### 檔案結構

| 檔案 | 角色 |
| --- | --- |
| `final/main.c` | C 主程式:呼叫各組語函式、開啟 `/dev/fb0`、跑動畫迴圈 |
| `final/drawJuliaSet.s` | **核心組語**:`julia` 函式,逐像素計算 Julia Set 並寫入畫格(2D 陣列定址 + frame buffer) |
| `final/name.s` | 組語:輸出隊名與成員姓名 |
| `final/id.s` | 組語:讀取/加總學號、`printmain`、`happy`(結尾賀詞)等輸出函式 |
| `final/drawJuliaSet.c` | C 版本的繪圖參考實作(對照組語邏輯用) |
| `final/name.c`、`final/id.c` | Project 1 的 dummy/範本 C 函式,僅供對照,未連結進最終程式 |
| `final/final.cbp`、`*.layout`、`*.depend` | Code::Blocks 專案/暫存檔(部分已列入 `.gitignore`) |

> 註:`main.c` 實際呼叫的是組語版的 `printname` / `id` / `printmain` / `happy` / `julia`;`name.c`、`id.c` 內的函式是課程範本,並非程式真正執行的版本。

## 結果

成功在 Raspberry Pi 上以組語繪出 Julia Set 並播成動畫。執行時:

1. 先在終端機印出小組資訊與學號加總。
2. 提示 `***** Please enter p to draw Julia Set animation *****`,使用者輸入 `p` 後開始繪圖。
3. 程式把碎形參數 `cY` 從 `400` 每次遞減 `5` 直到 `270`,逐格重畫 frame buffer,於螢幕上呈現連續變化的碎形動畫。
4. 動畫結束後印出結尾賀詞(`Happy New Year`)。

命令列輸出示意(節錄):

```
Function1: Name
*****Print Name*****
Team   16
WeiLun Chou
Henry  Wu
ZiCen  Deng
*****End   Print*****

Function2: ID
*****Input ID*****
** Please  Enter   Member  1   Id:**
...

***** Please enter p to draw Julia Set animation *****
```

碎形畫面成果可參考 repo 內的 `圖.png`,以及下方 placeholder 連結中的展示圖。

<!-- TODO: 下列為原始 README 的 GitHub 附件圖,請確認連結是否仍有效;失效請改放 repo 內圖片或重新上傳 -->
![成果展示 1](https://user-images.githubusercontent.com/95120819/192147135-69d4537d-ff49-4582-86a7-db53ba1a4a08.png)
![成果展示 2](https://user-images.githubusercontent.com/95120819/192147169-d05b7096-c11b-4210-afa8-c045c70358d9.png)

## 如何 build 與執行

> 這是一支 **ARM / Linux 程式**,需在 Raspberry Pi(或其他 `armhf` ARM Linux 環境)上編譯與執行,並需要可寫入的 frame buffer 裝置 `/dev/fb0`。
> 由編譯產物(`final/bin/Debug/final` 為 `ELF 32-bit LSB executable, ARM, EABI5, GNU/Linux`)與 `final.depend` 中的來源路徑 `/home/pi/Desktop/Final/` 判斷,本專案原先是在 **Raspberry Pi 上以 Code::Blocks(原生 GCC 工具鏈)** 直接編譯。

### 方式 A:在 Raspberry Pi 上用原生工具鏈手動編譯(建議)

需要 `gcc`(會自動帶起 `as` 組譯器與連結器):

```bash
cd final

# 編譯 + 組譯 + 連結(C 與組語混合)
gcc -o final main.c drawJuliaSet.s name.s id.s

# 執行(寫入 /dev/fb0 通常需要權限)
sudo ./final
```

說明:
- `main.c` 需與 `drawJuliaSet.s`(提供 `julia`)、`name.s`(提供 `printname` 等)、`id.s`(提供 `id` / `printmain` / `happy`)一起連結。
- `drawJuliaSet.c`、`name.c`、`id.c` 是參考/範本檔,**不要**和對應的 `.s` 一起連結,以免符號重複定義。
- 執行需在能存取 `/dev/fb0` 的環境(實機螢幕或對應的 framebuffer console);若 `Frame Buffer Device Open Error!!`,代表沒有可用的 frame buffer 或權限不足。
- 程式啟動後依提示輸入 `p` 才會開始畫動畫。

### 方式 B:在 Code::Blocks 開啟專案

repo 內含 Code::Blocks 的工作檔(`final/final.layout`、`final/final.depend`;`.cbp` 專案檔已被 `.gitignore` 排除)。在 Raspberry Pi 上以 Code::Blocks 開啟 `final` 專案,選 **Debug** target 後 Build & Run 即可。<!-- TODO: 若 .cbp 不在版本庫中,請使用方式 A 的指令重建,或自行重新建立 Code::Blocks 專案 -->

### 在非 ARM 機器上(交叉編譯,選用)

若想在 x86 開發機上交叉編譯,可使用 `arm-none-linux-gnueabihf-gcc`(或樹莓派對應的 `arm-linux-gnueabihf-gcc`)工具鏈,將 `gcc` 換成交叉編譯器即可;但最終仍需在實際具備 `/dev/fb0` 的 ARM Linux 裝置上執行。<!-- TODO: 此交叉編譯路徑未在本機驗證,實際使用前請確認工具鏈名稱與環境 -->

## 已知限制

- **平台綁定**:只能在具有 Linux frame buffer(`/dev/fb0`)的 ARM Linux 裝置上正確執行;一般桌面環境(X11/Wayland、或無對應 framebuffer)會開啟失敗或看不到輸出。
- **解析度寫死**:畫格固定為 `640 × 480`、RGB16;若實機 frame buffer 的解析度或色深不同,畫面會錯位或失真,且程式不會自動調整。
- **碎形參數寫死**:Julia Set 的常數與動畫範圍(`cY` 由 400 到 270、step -5)寫死在原始碼中,需改碼重編才能換圖。
- **定點數近似**:以整數定點運算取代浮點數,精度與邊緣細節不如浮點版本。
- **需要權限**:寫入 `/dev/fb0` 通常要 `sudo` 或將使用者加入 `video` 群組。
- **範本檔混雜**:`name.c` / `id.c` 為課程 dummy 範本,內容(隊名、學號)非真實資料,容易與組語版混淆。
- **授權未指定**:repo 內未含 LICENSE,預設保留所有權利;若要開放重用請補上授權條款。

---

### 備註

中原大學 組合語言與嵌入式系統 期末專案 — Team 16

| 學號 | 姓名 | 分工 |
| --- | --- | --- |
| 10827129 | 周暐倫 | `name.s`、`id.s`、`drawJuliaSet.s` 撰寫、註解 |
| 10827133 | 鄧梓岑 | 問題釐清、程式說明、說明文件與程式說明製作 |
| 10827157 | 吳添聖 | Bug 測試、說明文件與程式結果製作 |

完整書面報告請參考 repo 內的 `組語報告 Final.docx`。
