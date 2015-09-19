var/ja_temp_ascii = text2ascii(JA_TEMP)

/*
* Подготавливаем текст, уже прошедший sanitize(), для вывода в чате или всплывающем окне.
* Не нужны, если текст с "я" уже в нужной кодировке
*/
/proc/sanitize_chat(var/text)
	#ifdef DEBUG_CYRILLIC
	world << "\magenta DEBUG: \red <b>sanitize_chat() entered, text:</b> <i>[text]</i>"
	#endif

	text = replace_characters(text, list(JA_TEMP=JA_CHAT, JA_POPUP=JA_CHAT))

	#ifdef DEBUG_CYRILLIC
	world << "\magenta DEBUG: \blue <b>sanitize_chat() finished, text:</b> <i>[text]</i>"
	#endif
	return text

/proc/sanitize_popup(var/text)
	#ifdef DEBUG_CYRILLIC
	world << "\magenta DEBUG: \red <b>sanitize_popup() entered, text:</b> <i>[text]</i>"
	#endif

	text = replace_characters(text, list(JA_TEMP=JA_POPUP, JA_CHAT=JA_POPUP))

	#ifdef DEBUG_CYRILLIC
	world << "\magenta DEBUG: \blue <b>sanitize_popup() finished, text:</b> <i>[text]</i>"
	#endif
	return text

/*
* В некоторых местах необходимо возвращать "я" в нормальный вид, для окон редактирования прошедшего
* sanitize() текста (к примеру редактирование флавора), или для файлов логов.
* К сожалению, я не нашел способа обхитрить бьенд и выводить нормальную "я", пока довольствуемся "¶".
* Используется для приведения к нужному виду данных из файла сохранения.
*/
/proc/revert_ja(var/text)
	#ifdef DEBUG_CYRILLIC
	world << "\magenta DEBUG: \red <b>revert_ja() entered, text:</b> <i>[text]</i>"
	#endif

	text = replace_characters(text, list(JA_CHAT=JA_TEMP, JA_POPUP=JA_TEMP, JA=JA_TEMP))

	#ifdef DEBUG_CYRILLIC
	world << "\magenta DEBUG: \blue <b>revert_ja() finished, text:</b> <i>[text]</i>"
	#endif
	return text

/*
* Замена стандартным lowertext() и uppertext(), которые не умеют в кириллицу.
* Предполагается, что используется для текста с "я" в виде JA_TEMP
*/
/proc/lowertext_alt(var/text)
	var/lenght = length(text)
	var/new_text = null
	var/lcase_letter
	var/letter_ascii

	var/p = 1
	while(p <= lenght)
		lcase_letter = copytext(text, p, p + 1)
		letter_ascii = text2ascii(lcase_letter)

		if((letter_ascii >= 65 && letter_ascii <= 90) || (letter_ascii >= 192 && letter_ascii < 223))
			lcase_letter = ascii2text(letter_ascii + 32)
		else if(letter_ascii == 223)
			lcase_letter = JA_TEMP

		new_text += lcase_letter
		p++

	return new_text

/proc/uppertext_alt(var/text)
	var/lenght = length(text)
	var/new_text = null
	var/ucase_letter
	var/letter_ascii

	var/p = 1
	while(p <= lenght)
		ucase_letter = copytext(text, p, p + 1)
		letter_ascii = text2ascii(ucase_letter)

		if((letter_ascii >= 97 && letter_ascii <= 122) || (letter_ascii >= 224 && letter_ascii < 255))
			ucase_letter = ascii2text(letter_ascii - 32)
		else if(letter_ascii == ja_temp_ascii)
			ucase_letter = "Я"

		new_text += ucase_letter
		p++

	return new_text