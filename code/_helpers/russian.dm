/proc/rhtml_encode(var/msg)
	msg = replacetext(msg, "<", "&lt;")
	msg = replacetext(msg, ">", "&gt;")
	msg = replacetext(msg, "ÿ", "&#255;")
	return msg

/proc/rhtml_decode(var/msg)
	msg = replacetext(msg, "&gt;", ">")
	msg = replacetext(msg, "&lt;", "<")
	msg = replacetext(msg, "&#255;", "ÿ")
	return msg


//UPPER/LOWER TEXT + RUS TO CP1251 TODO: OVERRIDE uppertext
/proc/ruppertext(text as text)
	text = uppertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 223)
			t += ascii2text(a - 32)
		else if (a == 184)
			t += ascii2text(168)
		else t += ascii2text(a)
	t = replacetext(t,"&#255;","ß")
	return t

/proc/rlowertext(text as text)
	text = lowertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if (a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	return t


//RUS CONVERTERS
/proc/russian_to_cp1251(var/msg)//CHATBOX
	return replacetext(msg, "ÿ", "&#255;")

/proc/russian_to_utf8(var/msg)//PDA PAPER POPUPS
	return replacetext(msg, "ÿ", "&#1103;")

/proc/utf8_to_cp1251(msg)
	return replacetext(msg, "&#1103;", "&#255;")

/proc/cp1251_to_utf8(msg)
	return replacetext(msg, "&#255;", "&#1103;")

//Prepare text for edit. Replace "y" with "\?" for edition. Don't forget to call post_edit().
/proc/edit_cp1251(msg)
	return replacetext(msg, "&#255;", "\\ß")

/proc/edit_utf8(msg)
	return replacetext(msg, "&#1103;", "\\ß")

/proc/post_edit_cp1251(msg)
	return replacetext(msg, "\\ß", "&#255;")

/proc/post_edit_utf8(msg)
	return replacetext(msg, "\\ß", "&#1103;")

//input

/proc/input_cp1251(var/mob/user = usr, var/message, var/title, var/default, var/type = "message")
	var/msg = ""
	switch(type)
		if("message")
			msg = input(user, message, title, edit_cp1251(default)) as message
		if("text")
			msg = input(user, message, title, default) as text
	msg = russian_to_cp1251(msg)
	return post_edit_cp1251(msg)

/proc/input_utf8(var/mob/user = usr, var/message, var/title, var/default, var/type = "message")
	var/msg = ""
	switch(type)
		if("message")
			msg = input(user, message, title, edit_utf8(default)) as message
		if("text")
			msg = input(user, message, title, default) as text
	msg = russian_to_utf8(msg)
	return post_edit_utf8(msg)


var/global/list/rkeys = list(
	"à" = "f", "â" = "d", "ã" = "u", "ä" = "l",
	"å" = "t", "ç" = "p", "è" = "b", "é" = "q",
	"ê" = "r", "ë" = "k", "ì" = "v", "í" = "y",
	"î" = "j", "ï" = "g", "ð" = "h", "ñ" = "c",
	"ò" = "n", "ó" = "e", "ô" = "a", "ö" = "w",
	"÷" = "x", "ø" = "i", "ù" = "o", "û" = "s",
	"ü" = "m", "ÿ" = "z"
)

//Transform keys from russian keyboard layout to eng analogues and lowertext it.
/proc/sanitize_key(t)
	t = rlowertext(t)
	if(t in rkeys) return rkeys[t]
	return (t)

//TEXT MODS RUS
/proc/capitalize_cp1251(var/t as text)
	var/s = 2
	if (copytext(t,1,2) == ";")
		s += 1
	else if (copytext(t,1,2) == ":")
		s += 2
	return ruppertext(copytext(t, 1, s)) + copytext(t, s)

/proc/intonation(text)
	if (copytext(text,-1) == "!")
		text = "<b>[text]</b>"
	return text

/proc/rustoutf(text)			//fucking tghui
	text = replacetext(text, "à", "&#x430;")
	text = replacetext(text, "á", "&#x431;")
	text = replacetext(text, "â", "&#x432;")
	text = replacetext(text, "ã", "&#x433;")
	text = replacetext(text, "ä", "&#x434;")
	text = replacetext(text, "å", "&#x435;")
	text = replacetext(text, "¸", "&#x451;")
	text = replacetext(text, "æ", "&#x436;")
	text = replacetext(text, "ç", "&#x437;")
	text = replacetext(text, "è", "&#x438;")
	text = replacetext(text, "é", "&#x439;")
	text = replacetext(text, "ê", "&#x43A;")
	text = replacetext(text, "ë", "&#x43B;")
	text = replacetext(text, "ì", "&#x43C;")
	text = replacetext(text, "í", "&#x43D;")
	text = replacetext(text, "î", "&#x43E;")
	text = replacetext(text, "ï", "&#x43F;")
	text = replacetext(text, "ð", "&#x440;")
	text = replacetext(text, "ñ", "&#x441;")
	text = replacetext(text, "ò", "&#x442;")
	text = replacetext(text, "ó", "&#x443;")
	text = replacetext(text, "ô", "&#x444;")
	text = replacetext(text, "õ", "&#x445;")
	text = replacetext(text, "ö", "&#x446;")
	text = replacetext(text, "÷", "&#x447;")
	text = replacetext(text, "ø", "&#x448;")
	text = replacetext(text, "ù", "&#x449;")
	text = replacetext(text, "ú", "&#x44A;")
	text = replacetext(text, "û", "&#x44B;")
	text = replacetext(text, "ü", "&#x44C;")
	text = replacetext(text, "ý", "&#x44D;")
	text = replacetext(text, "þ", "&#x44E;")
	text = replacetext(text, "ÿ", "&#x44F;")
	text = replacetext(text, "À", "&#x410;")
	text = replacetext(text, "Á", "&#x411;")
	text = replacetext(text, "Â", "&#x412;")
	text = replacetext(text, "Ã", "&#x413;")
	text = replacetext(text, "Ä", "&#x414;")
	text = replacetext(text, "Å", "&#x415;")
	text = replacetext(text, "¨", "&#x401;")
	text = replacetext(text, "Æ", "&#x416;")
	text = replacetext(text, "Ç", "&#x417;")
	text = replacetext(text, "È", "&#x418;")
	text = replacetext(text, "É", "&#x419;")
	text = replacetext(text, "Ê", "&#x41A;")
	text = replacetext(text, "Ë", "&#x41B;")
	text = replacetext(text, "Ì", "&#x41C;")
	text = replacetext(text, "Í", "&#x41D;")
	text = replacetext(text, "Î", "&#x41E;")
	text = replacetext(text, "Ï", "&#x41F;")
	text = replacetext(text, "Ð", "&#x420;")
	text = replacetext(text, "Ñ", "&#x421;")
	text = replacetext(text, "Ò", "&#x422;")
	text = replacetext(text, "Ó", "&#x423;")
	text = replacetext(text, "Ô", "&#x424;")
	text = replacetext(text, "Õ", "&#x425;")
	text = replacetext(text, "Ö", "&#x426;")
	text = replacetext(text, "×", "&#x427;")
	text = replacetext(text, "Ø", "&#x428;")
	text = replacetext(text, "Ù", "&#x429;")
	text = replacetext(text, "Ú", "&#x42A;")
	text = replacetext(text, "Û", "&#x42B;")
	text = replacetext(text, "Ü", "&#x42C;")
	text = replacetext(text, "Ý", "&#x42D;")
	text = replacetext(text, "Þ", "&#x42E;")
	text = replacetext(text, "ß", "&#x42F;")
	return text