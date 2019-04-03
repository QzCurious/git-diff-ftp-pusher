git-diff-ftp-pusher
===================

*diffpush.sh* 為 bash script，使用時必須給 2 個 commit 為參數，
比較兩個 commit 的新舊後取有修改過的或新增的檔案上傳 ftp server

## 注意
若 ftp 根目錄與 git 專案目錄不同層級請勿使用

目前只在 manjaro 上測試過，其他作業是統尚未測試

## 依賴
此 script 需用到:
- git
- ftp (GNU inetutils)

### 安裝 ftp client
[macOS 安裝](http://osxdaily.com/2018/08/07/get-install-ftp-mac-os/):
`brew install tnftp`

[archlinux 安裝](https://wiki.archlinux.org/index.php/List_of_applications/Internet#FTP):
`pacman -S inetutils`

## 使用方法
1. 下載 *diffpush.sh* 放至 git repo 資料夾
2. 終端機 `cd` 到 git repo
3. 編輯 *diffpush.sh*，設置輸入 ftp 資訊，如:
```
ftp_server="54.64.230.135"  # ftp 主機位址
ftp_user="sleepaer"  # ftp 帳號
ftp_pass="dlfdaliena3"  # ftp 密碼
```
4. `chmod +x diffpush.sh`
5. `./diffpush.sh <commmit-older> <commit-newer>`; 以 commit id 取代 `<commit-xxx>`

## 已知問題
- 無法指定 ftp 資料夾