#!/bin/bash
langset=en

language_en=( "English" "Quit" "Options" "Main menu" "Git: add ALL files/commit" "Git init" "Change language" "Language selection" )
message_en=( "English" "Select item" "Wrong! This item does not exist" "Added all files" "Enter you commit" "Changes recorded" "Select a language" "The language has been changed to" "Start the program again" )

language_ru=( "Русский" "Выход" "Настройки" "Основное меню" "Git: добавить ВСЕ файлы/коммит" "" "" "Выбор языка" )
message_ru=( "Русский" "Выберите пункт" "Неверно! Этого пункта не существует" "Добавление всех файлов" "Введите ваш коммит" "Изменения зарегистрированы" "Выберите язык" "Язык изменен на" "Запустите программу заново" )

language_de=( "Deutsch" )
message_de=( "Deutsch" "" "" "" "" "" "" "" "Starten Sie das Programm neu" )

languages() {

	if [ "$1" == "set" ] ; then

		local lng_sfx=($(sed -r -n -e  "s/^\s?+language_(..).+/\1/p" "${0}"))
		
		local lng_menu=("${lng[7]};languages set")
		for a in ${lng_sfx[@]} ; do
			local d="language_$a[@]"; d=("${!d}")
			lng_menu+=("$d;languages setmenu $a")
		done
		
		lng_menu+=("${lng[1]};exit")
		
		prints "lng_menu[@]" "${msg[6]}"
		
	fi
	

	if [ "$1" == "setmenu" ] ; then
		
		langset="$2"
		local df="language_$langset"

		echo "${msg[7]} ${!df}. ${msg[8]}"
		languages
		echo "${msg[7]} ${lng[0]}. ${msg[8]}"
		#sed -i -r "/^langset=/s/langset=[\"\']?.*[\"\']?/langset=$langset/" "${0}"
		exit 
		
	fi

	lng="language_$langset[@]"; lng=("${!lng}")
	msg="message_$langset[@]"; msg=("${!msg}")

	for b in ${!language_en[@]} ${!message_en[@]} ; do
	
		if [[ ! ${lng[$b]} ]] ; then
			lng[$b]=${language_en[$b]}
		fi
		if [[ ! ${msg[$b]} ]] ; then
			msg[$b]=${message_en[$b]}
		fi
	done
}

languages

colors() {
	
	case "$1" in
		"tm" ) echo -e "\e[48;5;256;38;5;34;22m$2\e[0m" ;;
		"pt" ) echo -e "\e[48;5;24;38;5;15;1m$2\e[0m" ;;
		"fl" ) echo -e "\e[48;5;256;38;5;226;1m$2\e[0m" ;;
		"ok" ) echo -e "\e[48;5;256;38;5;34;1m$2\e[0m" ;;
		"err" ) echo -e "\e[48;5;256;38;5;160;1m$2\e[0m" ;;
		"title" ) echo -e "\e[48;5;256;38;5;226;22m$2\e[0m" ;;
		"item" ) echo -e "\e[48;5;256;38;5;15;22m$2\e[0m" ;;
	esac
	
}



pwds() {
	echo 
	echo ----------
	echo "$(colors 'tm' "[$(date +"%T")]") $(colors 'pt' "${PWD%/*}"/)$(colors 'fl'  "$(basename   "$PWD")")"
	echo ----------
}

prints() {
	
	if [[ "$1" == "text" ]] ; then
		echo "$2" | cut -d ";" -f 1
		return
	elif [[ "$1" == "command" ]] ; then
		echo "$2" | cut -d ";" -f 2
		return
	fi
	
	pwds
		
	local menu=("${!1}")
		
	colors "title" "---$(prints "text" "${menu[0]}")---"
	
	for (( op=1; op < "${#menu[@]}"; op++ )); do 

		colors "item" "$op ) $(prints "text" "${menu[$op]}")"
	done
	
	echo ----------

	read -s -n1 -p "$(colors "item" "$2: ")" item	
	
	case $item in
		[1-$((${#menu[@]}-1))] ) colors "ok" "[$item]->: $(prints "text" "${menu[$item]}")"
		$(prints "command" "${menu[$item]}") ;;
		"q" ) echo; exit;;
		* ) colors "err" "[$item]->: ${msg[2]}"; sleep 2 ;;
	esac	
}

gitinit() {
	git init
}




options() {

	local menu1=("${lng[2]};options" "${lng[7]} [$langset];languages set" "${lng[1]};exit")
	prints "menu1[@]" "${msg[1]}"
}


gitadd() {
	git add .
	echo "${msg[3]} ..."
	read -p "$(colors "item" "${msg[4]}: ")" comm
	git commit -m "$comm"
	colors "ok" "${msg[5]}"
	
} 

main() {
	local menu0=("${lng[3]};main" "${lng[4]};gitadd" "${lng[5]};gitinit" "${lng[2]};options" "${lng[1]};exit")

	while true ; do 
		prints "menu0[@]" "${msg[1]}"
	done
}

main
