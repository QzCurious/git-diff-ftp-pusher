# !/bin/sh
# ---- configuration ----
ftp_server=""  # ftp 主機位址
ftp_user=""  # ftp 帳號
ftp_pass=""  # ftp 密碼

# pre-check
if [ $# -ne 2 ]; then
    echo "請輸入主機目前的 commit、要上傳的 commit"
    exit 1
fi

if [ -z ftp_server ] || [ -z ftp_user ] || [ -z ftp_pass ]; then
    echo "請編輯此檔案填入 ftp 資訊"
    exit 2
fi

# ---- variable ----
from=$(git rev-parse --short $1)
to=$(git rev-parse --short $2)
# order input commits by commiting sequence
if [ $(git merge-base --is-ancestor $from $to) ]; then
    temp=$from; from=$to; to=$temp;
fi
upload_files=$(git diff $from $to --name-only)
workdir=/tmp/diffpush_${from}_${to}
ftp_cmds_file="$workdir/ftp_cmds"

# ---- function ----
ftp_init () {
    echo "quote USER $ftp_user" > $ftp_cmds_file
    echo "quote PASS $ftp_pass" >> $ftp_cmds_file
}

ftp_prepare_cmds () {
    echo $1 >> $ftp_cmds_file
}

ftp_send_cmd () {
    ftp_output="$(ftp -in $ftp_server <<EOF
    $(cat $ftp_cmds_file)
EOF
)"
}

# mkdir -p
# @param string $1 Path to directory
ftp_mkdir_p () {
    levels=($1)
    p=$1
    while [ $(dirname $p) != . ]
    do
        p=$(dirname $p)
        levels=($p ${levels[@]})
    done

    for level in ${levels[@]}
    do
        ftp_prepare_cmds "mkdir $level"
    done
}

# ---- main ----
# prepare files to be push
mkdir -p $workdir
git archive -o $workdir/diff.zip $to ${upload_files}
cd $workdir
unzip -o $workdir/diff.zip > /dev/null
rm $workdir/diff.zip

# for each file, make directory for it in ftp server
for file in $upload_files; do
    ftp_mkdir_p "$(dirname $file)"
done

ftp_init
ftp_prepare_cmds "mput $(echo $upload_files)"
ftp_send_cmd

exit 0;
