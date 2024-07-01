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

function @R3() { builtin printf "\e[0;31m%s\e[0m" "$*"; } # Red
function @G3() { builtin printf "\e[0;32m%s\e[0m" "$*"; } # Green
function @Y3() { builtin printf "\e[0;33m%s\e[0m" "$*"; } # Yellow
function @B3() { builtin printf "\e[0;34m%s\e[0m" "$*"; } # Blue
function @P3() { builtin printf "\e[0;35m%s\e[0m" "$*"; } # Purple
function @C3() { builtin printf "\e[0;36m%s\e[0m" "$*"; } # Cyan

function @D9() { builtin printf "\e[0;90m%s\e[0m" "$*"; } # Grey

function @R9() { builtin printf "\e[0;91m%s\e[0m" "$*"; } # Red
function @G9() { builtin printf "\e[0;92m%s\e[0m" "$*"; } # Green
function @Y9() { builtin printf "\e[0;93m%s\e[0m" "$*"; } # Yellow
function @B9() { builtin printf "\e[0;94m%s\e[0m" "$*"; } # Blue
function @P9() { builtin printf "\e[0;95m%s\e[0m" "$*"; } # Purple
function @C9() { builtin printf "\e[0;96m%s\e[0m" "$*"; } # Cyan

# https://github.com/DavidAnson/markdownlint-cli2
# 全局安装 $ npm install --global markdownlint-cli2
no-cmd npm && exit 101

MdLintCmd=markdownlint-cli2
npm list -g --depth 0 | grep markdownlint-cli2
if [[ $? -ne 0 ]]; then
  echo "$(@R3 'ERROR:') not found $(@G3 markdownlint-cli2) command"
  exit 102
fi

if no-cmd markdownlint-cli2; then
  for it in $(echo ${NODE_PATH} | sed 's/:/\n/g'); do
    if [[ -f "${it}/markdownlint-cli2/markdownlint-cli2.js" ]]; then
      MdLintCmd="${it}/markdownlint-cli2/markdownlint-cli2.js"
    fi
  done
fi

for it in $(find "${THIS_DIR%/*}" -type f -name '*.md' -print); do
  [[ ! "${it}" =~ *node_modules* ]] && ${MdLintCmd} --no-globs ${it}
done
