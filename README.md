# corebridge
way of doing hybrid using jsbridge iOS side 





only need to write a class extends basehandler and override the key and action method 





use memory dictionary to hold the router and the callback 

1增加在线加载h5资源的zip，然后解压到本地缓存，进行本地webview渲染。做一个初步的hotpatch

2增加bsdiff  增量更新资源包



使用方式，已经实现了将前端html压缩后，解压到本地渲染的逻辑，并且增加了patch版本控制的逻辑。下一步需要开发后端控制接口。