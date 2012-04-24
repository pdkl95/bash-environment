#!/bin/bash


declare -a UA

# Googlebot (ALWAYS FIRST!!!)
UA[1]='Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'

# Googlebot impersonating Safari on iPhone
UA[2]='Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3 (compatible; Googlebot-Mobile/2.1; +http://www.google.com/bot.html)'
# Baido
UA[3]='Baiduspider+(+http://www.baidu.com/search/spider.htm)'
# Yandex.ru
UA[4]='YandexSomething/1.0'
# Bing
UA[5]='msnbot-webmaster/1.0 (+http://search.msn.com/msnbot.htm)'

# Firefox 11, win7
UA[6]='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20100101 Firefox/11.0'
# Firefox 10, win7
UA[7]='Nozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20100101 Firefox/10.0.2'
# Firefox  9, win7
UA[8]='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
# firefox 10, winXP 32bit
UA[9]='Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20100101 Firefox/10.0.2'

# Chrome 17, Win7
UA[10]='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11'
# Safari 5, OSX
UA[11]='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/534.52.7 (KHTML, like Gecko) Version/5.1.2 Safari/534.52.7'
# IE 9, Win7
UA[12]='Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091102 Firefox/3.5.5'
# IE 6, winXP    (LOL)
UA[13]='Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)'
# iPad/iPhone, OSX
UA[14]='Mozilla/5.0 (iPad; CPU OS 5_0_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A405 Safari/7534.48.3'


# print the chosen useragent! finally!
echo "${UA[${N:-1}]}"

unset UA
return 0


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
