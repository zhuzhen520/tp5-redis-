#!/bin/bash  
#静态结算,每次1万
for((i=1;i<=10;i++));  
do
	/www/server/php/70/bin/php /www/wwwroot/fhq.zengliangkeji.com/fhq/public/index.php /count/index/member_list/page/$i>>/home/fhq.txt
done 
#静态金币释放
/www/server/php/70/bin/php /www/wwwroot/fhq.zengliangkeji.com/fhq/public/index.php /count/index/static_gold_rid>>/home/static_gold_rid.txt
