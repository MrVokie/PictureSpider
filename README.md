#MeiZiTu Spider

输入一个图片类网站的网址，会自动爬取所有的链接图片并使用瀑布流的形式展示出来，前提是图片链接是完整的地址(`http://xxx/xxx.jpeg`)，如果是根域名拼接的形式(`/images/xxxx.jpeg`)，则无法正常获取到图片。

并自动缓存当前爬取过的网站的链接地址，并留在下一个页面的爬取时使用。

使用了图片地址去重、网页地址去重，防止爬取重复的网址。

支持浏览爬取的图片，下载，放大查看等功能。
