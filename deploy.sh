#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

# 生成静态文件
npm run build

# 进入生成的文件夹
cd _book/

# 如果是发布到自定义域名
# echo 'www.example.com' > CNAME

git init
git add -A
git commit -m 'deploy'

# 如果发布到 https://<USERNAME>.github.io
# git push -f git@github.com:<USERNAME>/<USERNAME>.github.io.git master

# 如果发布到 https://<USERNAME>.github.io/<REPO>
git push -f git@github.com:xiaoshude/typescript-tutorial.git master:gh-pages

curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=852f667e-12cb-4688-bee7-672b6e1cf42e' \
   -H 'Content-Type: application/json' \
   -d '
   {
        "msgtype": "markdown",
        "markdown": {
            "content": "[typescript tutorial](http://fjywan.com/typescript-tutorial/) 更新完成",
            "mentioned_list":["@all"]
        }
   }'

cd -
