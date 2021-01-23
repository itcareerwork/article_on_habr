#!/bin/bash

langset=ru 


language_en=( "English" "Quit" "Main menu" "Git: add ALL files/commit" "Git init" "Change language" "Language selection" )
message_en=( "English" "Select item" "Wrong! This item does not exist" "Added all files" "Enter you commit" "Changes recorded" "Select a language" "The language has been changed to" "Start the program again" )

language_ru=( "Русский" "Выход" "Основное меню" "Git: добавить ВСЕ файлы/коммит" "" "" "Выбор языка" )
message_ru=( "Русский" "Выберите пункт" "Неверно! Этого пункта не существует" "Добавление всех файлов" "Введите ваш коммит" "Изменения зарегистрированы" "Выберите язык" "Язык изменен на" "Запустите программу заново" )

language_de=( "Deutsch" )
message_de=( "Deutsch" "" "" "" "" "" "" "" "Starten Sie das Programm neu" )

languages() {

	if [ "$1" == "set" ] ; then
		
		lng_sfx=(0 $(sed -r -n -e  "s/^\s?+language_(..).+/\1/p" "${0}"))
		unset lng_sfx[0]
		 		
		echo
		echo "---${lng[6]}---"

		for op in ${!lng_sfx[@]} ; do
			
			local d="language_${lng_sfx[$op]}"; d=${!d}
			echo "$op ) $d"
		done

		echo "$((${#lng_sfx[@]}+1)) ) ${lng[1]}"
		echo ----------
	
		read -s -n1 -p "${msg[6]}: " l_item	
	
		case $l_item in
			[1-${#lng_sfx[@]}] )		langset="${lng_sfx[$l_item]}"
							local df="language_$langset"
							echo "[ $l_item ]->: ${!df}"
							echo "${msg[7]} ${!df}. ${msg[8]}"
							languages
							echo "${msg[7]} ${lng[0]}. ${msg[8]}"
							sed  -i -r "/^langset=/s/langset=[\"\']?.*[\"\']?/langset=$langset/" "${0}"
							exit ;;
							
			$((${#lng_sfx[@]}+1)) )		echo "[ $l_item ]->: ${lng[1]}" ; exit ;;
			* )				echo "[ $l_item ]->: ${msg[2]}" ; sleep 2 ;;
		esac
				
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
		echo "[ $item ]->: ${menu0[$item]}" 

		case $item in
			1 ) 	git add .
				read -p "${msg[4]}: " comm
				git commit -m "$comm"
				echo "${msg[5]}" ;;
			2 )	git init ;;
			3 )	languages "set" ;;
			4 )	exit ;;
			* )	echo "[ $item ]->: ${msg[2]}"; sleep 2 ;;
		esac			
		
	done

}

main
