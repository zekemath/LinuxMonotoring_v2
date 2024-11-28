#!/bin/bash

if [ "$#" -ne 1 ]; 
then
    echo "ОШИБКА: Количество аргументов должно быть равно одному"
    exit 1
fi

if [ $1 -eq 1 ];
then
    echo "Введите путь к лог-файлу"
    read log
    if [ ! -e $log ]; then
        echo "Ошибка: Файл $log не существует"
    else
        while IFS= read -r line
        do
            if [[ "$line" == *"/"* ]]; then
                line=$(echo "$line" | /bin/awk '{print $1}')
                echo "Удаляется: $line"
                rm -rf $line
            fi
        done < $log
        echo "Очистка выполнена успешно"
    fi
elif [ $1 -eq 2 ];
then
    pattern='[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}'
    file_name='[a-z]+_[0-9]{6}'
    echo "Введите начальное время поиска в формате ГГГГ-ММ-ДД ЧЧ:ММ"
    read time_start
    echo "Введите конечное время поиска в формате ГГГГ-ММ-ДД ЧЧ:ММ"
    read time_end
    if [[ $time_start =~ $pattern ]] && [[ $time_end =~ $pattern ]]; then
        for var in $(find /home -type d -newerct "$time_start" ! -newerct "$time_end")
        do
            if [[ $var =~ $file_name ]]; then
                echo "Удаляется: $var"
                rm -rf $var
            fi
        done
        echo "Очистка выполнена успешно"
    else
        echo "Неверный формат даты"
    fi
elif [ $1 -eq 3 ];
then
    echo "Введите шаблон поиска"
    read pattern
    letters=$(echo "${pattern%_*}" | sed 's/\S/&+/g')
    date=${pattern#*_}
    pattern="${letters}_${date}"
    for var in $(find /home | grep -E "$letters_$date")
    do
        echo "Удаляется: $var"
        rm -rf $var
    done
    echo "Очистка выполнена успешно"
else
    echo "ОШИБКА: Неподдерживаемый тип аргумента"
fi