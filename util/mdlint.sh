#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
# Created By: Charles Wong 2024-06-30T15:48:33+08:00 Asia/Shanghai
# Repository: https://github.com/xwlc/mini-repo

THIS_AFP="$(realpath "${0}")"        # 当前文件绝对路径(含名)
THIS_FNO="$(basename "${THIS_AFP}")" # 仅包含当前文件的文件名
THIS_DIR="$(dirname  "${THIS_AFP}")" # 当前文件所在的绝对路径

function has-cmd() {  command -v "$1" > /dev/null; }
function no-cmd() { ! command -v "$1" > /dev/null; }

# https://github.com/DavidAnson/markdownlint-cli2
# 全局安装 $ npm install --global markdownlint-cli2
no-cmd npm && exit 1

npm list -g --depth 0 | grep markdownlint-cli2
[[ $? -ne 0 ]] && exit 2

for it in $(echo ${NODE_PATH} | sed 's/:/\n/g'); do
  if [[ -f "${it}/markdownlint-cli2/markdownlint-cli2.js" ]]; then
    mdlint="${it}/markdownlint-cli2/markdownlint-cli2.js"
  fi
done

[[ -z "${mdlint}" ]] && exit 3
REPO_ROOT_DIR="${THIS_DIR%/*}"

for it in $(find "${REPO_ROOT_DIR}" -type f -name '*.md' -print); do
  [[ ! "${it}" =~ *node_modules* ]] && ${mdlint} ${it}
done
