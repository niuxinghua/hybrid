# -*- coding: utf-8 -*-

import os
import sys
import random
import string
import oss2




# 首先初始化AccessKeyId、AccessKeySecret、Endpoint等信息。
# 通过环境变量获取，或者把诸如“<你的AccessKeyId>”替换成真实的AccessKeyId等。
access_key_id = 'xxxx'
access_key_secret =  'xxxx'
bucket_name = 'haier-app'
endpoint = 'http://oss-cn-qingdao.aliyuncs.com'


# 创建Bucket对象，所有Object相关的接口都可以通过Bucket对象来进行
bucket = oss2.Bucket(oss2.Auth(access_key_id, access_key_secret), endpoint, bucket_name)


filename = sys.argv[1]

destfile = sys.argv[2] + '/' + sys.argv[3]

# 断点续传一：因为文件比较小（小于oss2.defaults.multipart_threshold），
# 所以实际上用的是oss2.Bucket.put_object
try:
   result=oss2.resumable_upload(bucket, destfile, filename)

except:
      print("exception")
else:
     if result.resp.status == 200:
        #修改数据库记录上传成功
        print("success")
     else:
        print("fail")


# 请求ID。请求ID是请求的唯一标识，强烈建议在程序日志中添加此参数。
#print('request_id: {0}'.format(result.request_id))
## ETag是put_object方法返回值特有的属性。
#print('ETag: {0}'.format(result.etag))
# HTTP响应头部。
#print('date: {0}'.format(result.headers['date']))os.remove(filename)
