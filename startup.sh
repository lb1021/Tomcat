#!/bin/sh

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -----------------------------------------------------------------------------
# Start Script for the CATALINA Server
# -----------------------------------------------------------------------------

#os400是 IBM的AIX
#darwin是MacOSX 操作环境的操作系统成份
#Darwin是windows平台上运行的类UNIX模拟环境
#判断操作系统
#uname打印系统信息

# Better OS/400 detection: see Bugzilla 31132
os400=false
case "`uname`" in
OS400*) os400=true;;
esac


# $0脚本名，即startup.sh
# -h:表示判断一个文件存在并且是一个软链接
# expr 表示要根据某个模式去匹配字符串并返回所匹配到的字符串
# 或根据某个模式去计算匹配到的字符数。使用方式一般为： expr value : expression
# '.*-> \(.*\)$' 这部分是一个正则表达式, .* 部分表示任意字符, -> 是实际的两个字符， Linux 中的软链接会在使用 ls -al 命令列出文件的时候，以 "软链接 -> 真实文件" 的方式显示出软链接与其所链接的真实文件。
# $ 在这里表示行结束 \( 就是 (, 因为 ( shell 中属于特殊符号, 所以需要使用转义； \) 同样是转义为 )
# expr "$link" : '/.*' > /dev/null 是否是目录
# dirname 获取目录

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

PRGDIR=`dirname "$PRG"`
EXECUTABLE=catalina.sh

# -x 判断文件是否是一个可执行文件

# Check that target executable exists
if $os400; then
  # -x will Only work on the os400 if the files are:
  # 1. owned by the user
  # 2. owned by the PRIMARY group of the user
  # this will not work if the user belongs in secondary groups
  eval
else
  if [ ! -x "$PRGDIR"/"$EXECUTABLE" ]; then
    echo "Cannot find $PRGDIR/$EXECUTABLE"
    echo "The file is absent or does not have execute permission"
    echo "This file is needed to run this program"
    exit 1
  fi
fi

# 脚本名称叫test.sh 入参三个: 1 2 3
# 运行test.sh 1 2 3后
# $*为"1 2 3"（一起被引号包住）
# $@为"1" "2" "3"（分别被包住）
# $#为3（参数数量）
# $@ 为空

exec "$PRGDIR"/"$EXECUTABLE" start "$@"
