#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
# Created By: Charles Wong 2024-07-07T03:16:01+08:00 Asia/Shanghai
# Repository: https://github.com/xwlc/mini-repo

THIS_AFP="$(realpath "${0}")"        # 当前文件绝对路径(含名)
THIS_FNO="$(basename "${THIS_AFP}")" # 仅包含当前文件的文件名
THIS_DIR="$(dirname  "${THIS_AFP}")" # 当前文件所在的绝对路径
source "${THIS_DIR}/common.sh"

# 组件包 https://terser.org
# 在线工具 https://minify-js.com
no-cmd npm && exit 101

function noCommandFoundExit() {
  echo "$(@R3 'ERROR:') not found $(@G3 terser) command"
  exit 102
}

TerserCmd=terser
npm list -g --depth 0 | grep terser
[[ $? -ne 0 ]] && noCommandFoundExit

if no-cmd terser; then
  unset -v TerserCmd
  for it in $(echo "${NODE_PATH}" | sed 's/:/\n/g'); do
    if [[ -x "${it}/terser/bin/terser" ]]; then
      TerserCmd="${it}/terser/bin/terser"
    fi
  done
fi
[[ -z "${TerserCmd}" ]] && noCommandFoundExit

for it in $@; do
  FileJS="${THIS_DIR}/${it}"
  [[ -z "${it}" || ! -f "${FileJS}" ]] && continue

  # https://terser.org/docs/cli-usage
  # https://www.w3schools.com/Js/js_versions.asp
  ${TerserCmd} "${FileJS}" --ecma 2015 --compress --mangle \
    --comments "/SPDX/" --output "${FileJS%.js}.min.js"
done
