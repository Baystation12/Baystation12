
/*
	This should be in code/setup.dm

#define SANITIZE_CHAT 1
#define SANITIZE_BROWSER 2
#define SANITIZE_LOG 3
#define SANITIZE_TEMP 4

*/
/*
	The most used output way is text chat. So fatal letters by default should be transformed in chat version.
	Also, it`s easier to fix all browser() calls than search all possible "[src|usr|mob|any other var] <<" calls.
	Logs need a special letter, because watch normal text with ascii code insertions is weird.
	And sometimes we need special unique temp letter for input windows whitch allows to edit text.
	Like in custom event message, admin memo and VV.
*/

var/global/list/localisation = list()
/*	letters list filling in code/__HELPERS/global_lists.dm in /proc/makeDatumRefLists()		*/

/datum/letter
	var/letter = ""			//weird letter
	var/chat = ""			//chat letter
	var/browser = ""		//letter in browser windows
	var/log = ""			//letter for logs
	var/temp = ""			//temporatory letter for filled input windows
							//!!!temp must be unique for every letter!!!

	cyrillic_ya
		letter = "ÿ"
		chat = "&#255;"
		browser = "&#1103;"
		log = "ß"
		temp = "¶"

proc/sanitize_local(var/text, var/mode = SANITIZE_CHAT)
	for(var/datum/letter/L in localisation)
		switch(mode)
			if(SANITIZE_CHAT)		//only basic input goes to chat
				text = replace_characters(text, list(L.letter=L.chat, L.temp=L.chat))

			if(SANITIZE_BROWSER)	//browser takes everything
				text = replace_characters(text, list(L.letter=L.browser, L.temp=L.browser, L.chat=L.browser))

			if(SANITIZE_LOG)		//logs can get raw or prepared text
				text = replace_characters(text, list(L.letter=L.log, L.chat=L.log))

			if(SANITIZE_TEMP)		//same for input windows
				text = replace_characters(text, list(L.letter=L.temp, L.chat=L.temp))
	return text

/*
	Both encode and decode can break special symbol codes, so we need to replace them.
	Text letters always tuning into chat mode, and browser sanitization should be before every browser() call.
	I dunno, should every call be replaced, because maybe there some calls that isn`t used with users input.
*/

/proc/lhtml_encode(var/text)
	text = sanitize_local(text, SANITIZE_TEMP)
	text = html_encode(text)
	text = sanitize_local(text)
	return text

/proc/lhtml_decode(var/text)
	text = sanitize_local(text, SANITIZE_TEMP)
	text = html_decode(text)
	text = sanitize_local(text)
	return text