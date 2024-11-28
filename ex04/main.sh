!/bin/bash

# Names code_status
	# 200 - OK 
	# 201 - Created
	# 400 - Bad Request 
	# 401 - Unauthorized 
	# 403 - Forbidden 
	# 404 - Not Found 
	# 500 - Internal Server Error
	# 501 - Not Implemented 
	# 502 - Bad Gateway
	# 503 - Service Unavailable 

CODE_STATUS=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
METHODS=("GET" "POST" "PUT" "PATCH" "DELETE")
AGENT=("Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"
       "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
       "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36 OPR/38.0.2220.41"
       "Mozilla/5.0 (iPhone; CPU iPhone OS 13_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.1 Mobile/15E148 Safari/604.1"
       "Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0)"
       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59"
       "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
       "PostmanRuntime/7.26.5v"
       "curl/7.64.1")

generate_url() {
    if [ $1 -eq 1 ]; then
        echo "google$(($RANDOM%100+1)).com"
    elif [ $1 -eq 2 ]; then
        echo "ya$(($RANDOM%100+1)).ru"
    elif [ $1 -eq 3 ]; then
        echo "apple$(($RANDOM%100+1)).com"
    elif [ $1 -eq 4 ]; then
        echo "amazon$(($RANDOM%100+1)).com"
    else
        echo ""
    fi
}

generate_data() {
    if [ $1 -eq 1 ]; then
        echo "$(($RANDOM%31+1))/Jan/"
    elif [ $1 -eq 2 ]; then
        echo "$(($RANDOM%28+1))/Feb/"
    elif [ $1 -eq 3 ]; then
        echo "$(($RANDOM%31+1))/Mar/"
    elif [ $1 -eq 4 ]; then
        echo "$(($RANDOM%30+1))/Apr/"
    elif [ $1 -eq 5 ]; then
        echo "$(($RANDOM%31+1))/May/"
    elif [ $1 -eq 6 ]; then
        echo "$(($RANDOM%30+1))/Jun/"
    elif [ $1 -eq 7 ]; then
        echo "$(($RANDOM%31+1))/Jul/"
    elif [ $1 -eq 8 ]; then
        echo "$(($RANDOM%31+1))/Aug/"
    elif [ $1 -eq 9 ]; then
        echo "$(($RANDOM%30+1))/Sep/"
    elif [ $1 -eq 10 ]; then
        echo "$(($RANDOM%31+1))/Oct/"
    elif [ $1 -eq 11 ]; then
        echo "$(($RANDOM%30+1))/Nov/"
    else
        echo "$(($RANDOM%31+1))/Dec/"
    fi
}

create=("" "" "" "")
for (( i=1; i<=5; i++ )) 
do
    file_name="log$i.log"
    touch $file_name
    amount_line=0
    while [ "$amount_line" -le 100 ]
		do
			amount_line=$(($RANDOM%1000))
		done
    count=0
    month=$(($RANDOM%12))
    data="[$(generate_data $month)$(date "+%Y:%T %z]")"
    for (( j=0; j<$count; j++ )) 
		do
			if [ "$data" == "${create[$j]}" ]; then
				month=$(($RANDOM%12))
				data="[$(generate_data $month)$(date "+%Y:%T %z]")"
				j=-1
			fi
		done
    for (( k=0; k<$amount_line; k++ )) 
		do
			ip="$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256))"
			code=${CODE_STATUS[$(($RANDOM%10))]}
			method=${METHODS[$(($RANDOM%5))]}
			url="/$(generate_url $(($RANDOM%5)))HTTP/1.1"
			agent=${AGENT[$(($RANDOM%9))]}
			echo "$ip - - $data \"$method $url\" $code \"$agent\"" >> $file_name
		done
    create[$count]=$data
    count=$((count+1))
done