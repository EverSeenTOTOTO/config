#!/usr/bin/env zx

const LogFile = '.cache/boot.log';

within(async () => {
  await $`echo ---------------------------------------------------- >> ${LogFile}`;
  await $`date >> ${LogFile}`;

  await $`pm2 start -n clash "clash-party" --interpreter bash`;

  // await $`pm2 start -n fcitx5 "fcitx5"`;
  // await $`pm2 start -n hidden "v2ray" -- run --config .config/v2ray/config-hidden.json`;

  await $`rsync ./ftp/pdf/ $TSS:~/ftp/pdf -azrv --progress --ignore-existing --exclude=".*" 2<&1 | tee ${LogFile}`;
})
