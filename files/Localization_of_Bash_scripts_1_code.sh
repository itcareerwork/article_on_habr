#!/bin/bash

langset=ru


language_en=( "English" "Quit" "Main menu" "Git: add ALL files/commit" "Git init" "Change language" "Language selection" )
message_en=( "English" "Select item" "Wrong! This item does not exist" "Added all files" "Enter you commit" "Changes recorded" "Select a language" "The language has been changed to" "Start the program again" "There will be a menu for changing the language" )

language_ru=( "Русский" "Выход" "Основное меню" "Git: добавить ВСЕ файлы/коммит" "" "" "Выбор языка" )
message_ru=( "Русский" "Выберите пункт" "Неверно! Этого пункта не существует" "Добавление всех файлов" "Введите ваш коммит" "Изменения зарегистрированы" "Выберите язык" "Язык изменен на" "Запустите программу заново" "Здесь будет меню для смены языка" )

language_de=( "Deutsch" )
message_de=( "Deutsch" "" "" "" "" "" "" "" "Starten Sie das Programm neu" )

languages() {

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





main() {

	local menu0=([1]="${lng[3]}" "${lng[4]}" "${lng[5]} [$langset]" "${lng[1]}")
	
	while true ; do 
		echo
		echo "---${lng[2]}---"
		
		for op in "${!menu0[@]}" ; do 
			echo "$op ) ${menu0[$op]}"
		done
		
		echo ----------
		
		read -s -n1 -p "${msg[1]}: " item
		echo "[$item]->: ${menu0[$item]}"

		case $item in
			1 ) 	git add .
				read -p "${msg[4]}: " comm
				git commit -m "$comm"
				echo "${msg[5]}" ;;
			2 )	git init ;;
			3 )	echo "${msg[9]}" ;;
			4 )	exit ;;
			* )	echo "[$item]->: ${msg[2]}"; sleep 2 ;;
		esac			
		
	done

}

main

exit 0
