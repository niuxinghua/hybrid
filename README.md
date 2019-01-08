# corebridge
way of doing hybrid using jsbridge iOS side 





only need to write a class extends basehandler and override the key and action method 





use memory dictionary to hold the router and the callback 

1增加在线加载h5资源的zip，然后解压到本地缓存，进行本地webview渲染。做一个初步的hotpatch

2增加bsdiff  增量更新资源包



使用方式，已经实现了将前端html压缩后，解压到本地渲染的逻辑，并且增加了patch版本控制的逻辑。

接口已经部署到内网环境，需要等待外网服务。

基本完成hybrid app的增量 全量下载，与jsbridge。todo 给前端调试做一个webstorm的插件，将前端修改的页面实时同步到app内加载调试。
