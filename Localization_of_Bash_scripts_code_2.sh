#!/bin/bash
# Код языка
langset=ru

# Меню и сообщения
language_en=( "English" "Quit" "Options" "Main menu" "Git: add ALL files/commit" "Git init" "Change language" "Language selection" )
message_en=( "English" "Select item" "Wrong! This item does not exist" "Added all files" "Enter you commit" "Changes recorded" "Select a language" "The language has been changed to" "Start the program again" "Repository not found\nPlease, select Git init pepository" )

language_ru=( "Русский" "Выход" "Настройки" "Основное меню" "Git: добавить ВСЕ файлы/коммит" "" "" "Выбор языка" )
message_ru=( "Русский" "Выберите пункт" "Неверно! Этого пункта не существует" "Добавление всех файлов" "Введите ваш коммит" "Изменения зарегистрированы" "Выберите язык" "Язык изменен на" "Запустите программу заново" "Репозиторий не найден\nПожалуйста, инициализируйте репозиторий, выбрав Git init")

language_de=( "Deutsch" )
message_de=( "Deutsch" "" "" "" "" "" "" "" "Starten Sie das Programm neu" )


#Settings section

languages() {

	# Косвенные ссылки и создание нового массива
	lng="language_$langset[@]"; lng=("${!lng}")
	msg="message_$langset[@]"; msg=("${!msg}")

	# Сравнение массивов для проверки на пропущенные элементы
	for b in ${!language_en[@]} ${!message_en[@]} ; do
	
		if [[ ! ${lng[$b]} ]] ; then
			lng[$b]=${language_en[$b]}
		fi
		if [[ ! ${msg[$b]} ]] ; then
			msg[$b]=${message_en[$b]}
		fi
	done

	# Установка нового языка
	if [ "$1" == "set" ] ; then
		
		# Устанавливаем новый язык из входного параметра
		langset="$2"
		local df="language_$langset"
		
		# Выводим сообщение на текущем языке что язык изменен, 
		# пишем какой выбрали, предлагаем перезапустить программу
		echo "${msg[7]} ${!df}. ${msg[8]}"
		
		# Применяем настройки языка
		languages
		
		# Выводим сообщение на новом языке что язык изменен 
		# пишем какой выбрали, предлагаем перезапустить программу
		echo "${msg[7]} ${lng[0]}. ${msg[8]}"
		
		# Через регулярное сообщение путем изменения файла 
		# перезаписываем переменную langset= с кодом языка и выходим
		sed -i -r "/^langset=/s/langset=[\"\']?.*[\"\']?/langset=$langset/" "${0}"
		exit 
	fi
}

# Применяем настройки языка
languages


colors() {
	# Установка цвета текста и фона. Строки даны полностью,
	# чтобы можно было просто изменить цифры, ничего не дописывая
	# Здесь [48] - код расширенной палитры фона, [38] - текста. 
	# [5] - 8-битный формат цвета (0-255), [1] - жирный,
	# [22] - отменить жирный, [0] - сбросить все изменения
	case "$1" in
		# Текст: темно-зеленый (часы)
		"tm" ) echo -e "\e[48;5;256;38;5;34;22m$2\e[0m" ;;
		# Фон: светло-синий, текст: белый жирный (часть полного пути)
		"pt" ) echo -e "\e[48;5;24;38;5;15;1m$2\e[0m" ;;
		# Текст: светло-желтый жирный (текущая папка)
		"cf" ) echo -e "\e[48;5;256;38;5;226;1m$2\e[0m" ;;
		# Текст: темно-зеленый жирный (цвет успешной операции)
		"ok" ) echo -e "\e[48;5;256;38;5;34;1m$2\e[0m" ;;
		# Текст: красный жирный (цвет ошибки)
		"err" ) echo -e "\e[48;5;256;38;5;160;1m$2\e[0m" ;;
		# Текст: светло-желтый (шапка меню)
		"title" ) echo -e "\e[48;5;256;38;5;226;22m$2\e[0m" ;;
		# Текст: белый (пункты меню и строка приглашения)
		"item" ) echo -e "\e[48;5;256;38;5;15;22m$2\e[0m" ;;
	esac
	
}

pwds() {
	# Цветное отображение полного пути текущей директории и даты
	echo 
	echo ----------
	echo "$(colors 'tm' "[$(date +"%T")]") $(colors 'pt' "${PWD%/*}"/)$(colors 'cf'  "$(basename   "$PWD")")"
	echo ----------
}

prints() {
	
	# Разделение элемента массива на текст и команду, в качестве разделителя [;]
	if [[ "$1" == "text" ]] ; then
		echo "$2" | cut -d ";" -f 1
		return
	elif [[ "$1" == "command" ]] ; then
		echo "$2" | cut -d ";" -f 2
		return
	fi
	
	# Вывод даты и текущего пути 
	pwds
	
	# Задаем массив из массива, переданного в функцию	
	local menu=("${!1}")
	
	# Вывод названия меню желтым цветом, название берется 
	# из текстовой части 1 элемента массива 	
	colors "title" "---$(prints "text" "${menu[0]}")---"
	
	# Вывод меню на экран
	for (( op=1; op < "${#menu[@]}"; op++ )); do 
		
		# Вывод пунктов меню белым цветом, названия берутся
		# из текстовой части соответствующего элемента массива
		colors "item" "$op ) $(prints "text" "${menu[$op]}")"
	done
	
	echo ----------
	
	# Ожидание ввода значения, приглашение выводится белым цветом
	read -s -n1 -p "$(colors "item" "$2: ")" item	
	
	# Оператор выбора
	case $item in
		# Все числа от 1 до размера всего массива минус 1 (так как индексация массива с 0)
		# Вывод выбранного пункта меню зеленым цветом название берется
		# из текстовой части соответствующего элемента массива
		[1-$((${#menu[@]}-1))] ) colors "ok" "[$item]->: $(prints "text" "${menu[$item]}")"
		
		# Вызов функции с набором команд, имя функции берется 
		# из командной части соответствующего элемента массива
		$(prints "command" "${menu[$item]}") ;;
		
		# Немедленное завершение по [q]
		"q" ) echo; exit;;
		
		# Обработка остальных клавиш и вывод сообщения об ошибке красным цветом
		* ) colors "err" "[$item]->: ${msg[2]}"; sleep 2 ;;
	esac	
}


#Application section

gitinit() {
	# Для примера: набор команд для [git init]
	git init
}

gitadd() {
	# Для примера: набор команд для [git add] - добавить все файлы
	git add .
	# Обработка ошибок. Если статус завершения команды не равен [0] 
	# вывести сообщение об ошибке красным цветом и вернуться в меню
	if [[ "$?" != "0" ]] ; then 
		colors "err" "${msg[9]}" 
		sleep 1
		return 1 
	fi
	
	echo "${msg[3]} ..."
	# Приглашение и ввод коммита
	read -p "$(colors "item" "${msg[4]}: ")" comm
	git commit -m "$comm"
	# сообщение о завершении операции зеленим цветом
	colors "ok" "${msg[5]}"
	
} 


# Menu section

langmenu(){
	local lng_sfx=($(sed -r -n -e  "s/^\s?+language_(..).+/\1/p" "${0}"))
		
	local menu2=("${lng[7]};langmenu")
	for a in ${lng_sfx[@]} ; do
		local d="language_$a[@]"; d=("${!d}")
		menu2+=("$d;languages set $a")
	done
	
	menu2+=("${lng[1]};exit")
	
	prints "menu2[@]" "${msg[6]}"
}

options() {
	local menu1=("${lng[2]};options" "${lng[7]} [$langset];langmenu" "${lng[1]};exit")
	prints "menu1[@]" "${msg[1]}"
}

main() {
	local menu0=("${lng[3]};main" "${lng[4]};gitadd" "${lng[5]};gitinit" "${lng[2]};options" "${lng[1]};exit")

	while true ; do 
		prints "menu0[@]" "${msg[1]}"
	done
}

main
