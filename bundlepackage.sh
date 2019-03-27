#判断是否是全量打包
rm -rf bundlesource
git clone 'https://git.haier.net/yidongkaifa/mintui' bundlesource

if [ "`ls -A bundlesource`" = "" ]; then
echo "clone失败"
#回调数据库编译失败

else
echo "clone成功"
cd bundlesource
pwd
rm -rf dist
npm install
npm run build
#判断build是否成功
if [ "`ls -A dist`" = "" ]; then
echo "build失败"
else
echo "build成功"
cd dist
zip -r dist.zip ./*
mv dist.zip ../../
cd ..
cd ..
s=`python3 upload.py "dist.zip" "hwork" "dist.zip"`
#python3 upload.py "hwork" "dist.zip"
echo "${s}"

if [ $s = "success" ];then
echo "打包bundle上传成功"
#开始打原生包 https://git.haier.net/yidongkaifa/GoHaier
git clone 'https://git.haier.net/yidongkaifa/GoHaier' GoHaier
cd GoHaier
cd GoHaier
pwd
sh package.sh 5324nxh050622 COSMOIM haierios COSMOIM com.haier.imapp hwork 8.1 release 10
if [ "`ls -A build/GoHaier.ipa`" = "" ]; then
echo "打包native失败"
else
mv build/GoHaier.ipa/GoHaier.ipa  ../../
cd ..
cd ..
s=`python3 upload.py "GoHaier.ipa" "GoHaier" "GoHaier_v1.ipa"`
echo "${s}"
if [ $s = "success" ];then
echo "上传native成功"
else
echo "上传native失败"
fi
fi
else
echo "打包bundle失败"

fi
fi
fi
