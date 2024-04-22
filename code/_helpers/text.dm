/*
 * Holds procs designed to help with filtering text
 * Contains groups:
 *			SQL sanitization
 *			Text sanitization
 *			Text searches
 *			Text modification
 *			Misc
 */


/*
 * SQL sanitization
 */

// Run all strings to be used in an SQL query through this proc first to properly escape out injection attempts.
/proc/sanitizeSQL(t as text)
	var/sqltext = dbcon.Quote(t);
	return copytext(sqltext, 2, length(sqltext));//Quote() adds quotes around input, we already do that

/*
 * Text sanitization
 */

//Used for preprocessing entered text
//Added in an additional check to alert players if input is too long
/proc/sanitize(input, max_length = MAX_MESSAGE_LEN, encode = 1, trim = 1, extra = 1)
	if(!input)
		return

	if (max_length)
		var/len = length_char(input)
		if (len > max_length)
			to_chat(usr, SPAN_WARNING("Your message is too long by [len - max_length] char\s."))
			return
		input = copytext_char(input, 1, max_length + 1)

	if(extra)
		input = replace_characters(input, list("\n"=" ","\t"=" "))

	if(encode)
		// The below \ escapes have a space inserted to attempt to enable unit testing of span class usage. Please do not remove the space.
		//In addition to processing html, html_encode removes byond formatting codes like "\ red", "\ i" and other.
		//It is important to avoid double-encode text, it can "break" quotes and some other characters.
		//Also, keep in mind that escaped characters don't work in the interface (window titles, lower left corner of the main window, etc.)
		input = html_encode(input)
	else
		//If not need encode text, simply remove < and >
		//note: we can also remove here byond formatting codes: 0xFF + next byte
		input = replace_characters(input, list("<"=" ", ">"=" "))

	if(trim)
		//Maybe, we need trim text twice? Here and before copytext?
		input = trimtext(input)

	return input

//Run sanitize(), but remove <, >, " first to prevent displaying them as &gt; &lt; &34; in some places, after html_encode().
//Best used for sanitize object names, window titles.
//If you have a problem with sanitize() in chat, when quotes and >, < are displayed as html entites -
//this is a problem of double-encode(when & becomes &amp;), use sanitize() with encode=0, but not the sanitizeSafe()!
/proc/sanitizeSafe(input, max_length = MAX_MESSAGE_LEN, encode = 1, trim = 1, extra = 1)
	return sanitize(replace_characters(input, list(">"=" ","<"=" ", "\""="'")), max_length, encode, trim, extra)

//Filters out undesirable characters from names
/proc/sanitizeName(input, max_length = MAX_NAME_LEN, allow_numbers = 0, force_first_letter_uppercase = TRUE)
	if(!input || length(input) > max_length)
		return //Rejects the input if it is null or if it is longer then the max length allowed

	var/number_of_alphanumeric	= 0
	var/last_char_group			= 0
	var/output = ""

	for(var/i=1, i<=length(input), i++)
		var/ascii_char = text2ascii(input,i)
		switch(ascii_char)
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// a  .. z
			if(97 to 122)			//Lowercase Letters
				if(last_char_group<2 && force_first_letter_uppercase)
					output += ascii2text(ascii_char-32)	//Force uppercase first character
				else
					output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// 0  .. 9
			if(48 to 57)			//Numbers
				if(!last_char_group)		continue	//suppress at start of string
				if(!allow_numbers)			continue
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 3

			// '  -  .
			if(39,45,46)			//Common name punctuation
				if(!last_char_group) continue
				output += ascii2text(ascii_char)
				last_char_group = 2

			// ~   |   @  :  #  $  %  &  *  +
			if(126,124,64,58,35,36,37,38,42,43)			//Other symbols that we'll allow (mainly for AI)
				if(!last_char_group)		continue	//suppress at start of string
				if(!allow_numbers)			continue
				output += ascii2text(ascii_char)
				last_char_group = 2

			//Space
			if(32)
				if(last_char_group <= 1)	continue	//suppress double-spaces and spaces at start of string
				output += ascii2text(ascii_char)
				last_char_group = 1
			else
				return

	if(number_of_alphanumeric < 2)	return		//protects against tiny names like "A" and also names like "' ' ' ' ' ' ' '"

	if(last_char_group == 1)
		output = copytext(output,1,length(output))	//removes the last character (in this case a space)

	for(var/bad_name in list("space","floor","wall","r-wall","monkey","unknown","inactive ai","plating"))	//prevents these common metagamey names
		if(cmptext(output,bad_name))	return	//(not case sensitive)

	return output

//Used to strip text of everything but letters and numbers, make letters lowercase, and turn spaces into .'s.
//Make sure the text hasn't been encoded if using this.
/proc/sanitize_for_email(text)
	if(!text) return ""
	var/list/dat = list()
	var/last_was_space = 1
	for(var/i=1, i<=length(text), i++)
		var/ascii_char = text2ascii(text,i)
		switch(ascii_char)
			if(65 to 90)	//A-Z, make them lowercase
				dat += ascii2text(ascii_char + 32)
			if(97 to 122)	//a-z
				dat += ascii2text(ascii_char)
				last_was_space = 0
			if(48 to 57)	//0-9
				dat += ascii2text(ascii_char)
				last_was_space = 0
			if(32, 46)	//space or .
				if(last_was_space)
					continue
				dat += "."		//We turn these into ., but avoid repeats or . at start.
				last_was_space = 1
	if(dat[length(dat)] == ".")	//kill trailing .
		dat.Cut(length(dat))
	return jointext(dat, null)

//Returns null if there is any bad text in the string
/proc/reject_bad_text(text, max_length=512)
	if(length(text) > max_length)	return			//message too long
	var/non_whitespace = 0
	for(var/i=1, i<=length(text), i++)
		switch(text2ascii(text,i))
			if(62,60,92,47)	return			//rejects the text if it contains these bad characters: <, >, \ or /
			if(127 to 255)	return			//rejects non-ASCII letters
			if(0 to 31)		return			//more weird stuff
			if(32)			continue		//whitespace
			else			non_whitespace = 1
	if(non_whitespace)		return text		//only accepts the text if it has some non-spaces


//Old variant. Haven't dared to replace in some places.
/proc/sanitize_old(t,list/repl_chars = list("\n"="#","\t"="#"))
	return html_encode(replace_characters(t,repl_chars))

/*
 * Text searches
 */

//Checks the beginning of a string for a specified sub-string
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtext(text, prefix, start, end)

//Checks the beginning of a string for a specified sub-string. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix_case(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtextEx(text, prefix, start, end)

//Checks the end of a string for a specified substring.
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtext(text, suffix, start, null)
	return

//Checks the end of a string for a specified substring. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix_case(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtextEx(text, suffix, start, null)

/*
 * Text modification
 */

/proc/replace_characters(t,list/repl_chars)
	for(var/char in repl_chars)
		t = replacetext(t, char, repl_chars[char])
	return t


/// Builds a string of padding repeated until its character count meets or exceeds size
/proc/generate_padding(size, padding)
	var/padding_size = length_char(padding)
	if (!padding_size)
		return ""
	var/padding_count = ceil(size / padding_size)
	var/list/result = list()
	for (var/i = padding_count to 1 step -1)
		result += padding // pow2 strategies could be used here at the cost of complexity
	return result.Join(null)


/// Pads the matter of padding onto the start of text until the result length is size
/proc/pad_left(text, size, padding)
	var/text_length = length_char(text)
	if (text_length >= size)
		return text
	if (!text_length)
		text = ""
	var/result = "[generate_padding(size - text_length, padding)][text]"
	var/length_difference = length_char(result) - size
	if (!length_difference)
		return result
	return copytext_char(result, length_difference + 1)


/// Pads the matter of padding onto the start of text until the result length is size
/proc/pad_right(text, size, padding)
	var/text_length = length_char(text)
	if (text_length >= size)
		return text
	if (!text_length)
		text = ""
	var/result = "[text][generate_padding(size - text_length, padding)]"
	var/length_difference = length_char(result) - size
	if (!length_difference)
		return result
	return copytext_char(result, 1, -length_difference)


//Returns a string with reserved characters and spaces before the first letter removed
/proc/trim_left(text)
	for (var/i = 1 to length(text))
		if (text2ascii(text, i) > 32)
			return copytext(text, i)
	return ""

//Returns a string with reserved characters and spaces after the last letter removed
/proc/trim_right(text)
	for (var/i = length(text) to 1 step -1)
		if (text2ascii(text, i) > 32)
			return copytext(text, 1, i + 1)
	return ""

//Returns a string with the first element of the string capitalized.
/proc/capitalize(text)
	return uppertext(copytext_char(text, 1, 2)) + copytext_char(text, 2)

//This proc strips html properly, remove < > and all text between
//for complete text sanitizing should be used sanitize()
/proc/strip_html_properly(input)
	if(!input)
		return
	var/opentag = 1 //These store the position of < and > respectively.
	var/closetag = 1
	while(1)
		opentag = findtext(input, "<")
		closetag = findtext(input, ">")
		if(closetag && opentag)
			if(closetag < opentag)
				input = copytext(input, (closetag + 1))
			else
				input = copytext(input, 1, opentag) + copytext(input, (closetag + 1))
		else if(closetag || opentag)
			if(opentag)
				input = copytext(input, 1, opentag)
			else
				input = copytext(input, (closetag + 1))
		else
			break

	return input

//This proc fills in all spaces with the "replace" var (* by default) with whatever
//is in the other string at the same spot (assuming it is not a replace char).
//This is used for fingerprints
/proc/stringmerge(text,compare,replace = "*")
	var/newtext = text
	if(length(text) != length(compare))
		return 0
	for(var/i = 1, i < length(text), i++)
		var/a = copytext(text,i,i+1)
		var/b = copytext(compare,i,i+1)
		//if it isn't both the same letter, or if they are both the replacement character
		//(no way to know what it was supposed to be)
		if(a != b)
			if(a == replace) //if A is the replacement char
				newtext = copytext(newtext,1,i) + b + copytext(newtext, i+1)
			else if(b == replace) //if B is the replacement char
				newtext = copytext(newtext,1,i) + a + copytext(newtext, i+1)
			else //The lists disagree, Uh-oh!
				return 0
	return newtext

//This proc returns the number of chars of the string that is the character
//This is used for detective work to determine fingerprint completion.
/proc/stringpercent(text,character = "*")
	if(!text || !character)
		return 0
	var/count = 0
	for(var/i = 1, i <= length(text), i++)
		var/a = copytext(text,i,i+1)
		if(a == character)
			count++
	return count

/proc/reverse_text(text)
	. = ""
	for (var/i = length_char(text) to 1 step -1)
		. += copytext_char(text, i, i + 1)

//Used in preferences' SetFlavorText and human's set_flavor verb
//Previews a string of len or less length
/proc/TextPreview(string,len=40)
	if(length(string) <= len)
		if(!length(string))
			return "\[...\]"
		else
			return string
	else
		return "[copytext_preserve_html(string, 1, 37)]..."

//alternative copytext() for encoded text, doesn't break html entities (&#34; and other)
/proc/copytext_preserve_html(text, first, last)
	return html_encode(copytext(html_decode(text), first, last))

/proc/create_text_tag(tagname, tagdesc = tagname, client/C = null)
	if(!(C && C.get_preference_value(/datum/client_preference/chat_tags) == GLOB.PREF_SHOW))
		return tagdesc
	return icon2html(icon('./icons/chattags.dmi', tagname), world, realsize=TRUE, class="text_tag")

/proc/contains_az09(input)
	for(var/i=1, i<=length(input), i++)
		var/ascii_char = text2ascii(input,i)
		switch(ascii_char)
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				return 1
			// a  .. z
			if(97 to 122)			//Lowercase Letters
				return 1

			// 0  .. 9
			if(48 to 57)			//Numbers
				return 1
	return 0

/proc/generateRandomString(length)
	. = list()
	for(var/a in 1 to length)
		var/letter = rand(33,126)
		. += ascii2text(letter)
	. = jointext(.,null)

#define text_starts_with(string, substring) !!findtext_char((string), (substring), 1, 1 + length_char(substring))
#define text_ends_with(string, substring) !!findtext_char((string), (substring), -length_char(substring))

#define gender2text(gender) capitalize(gender)

/**
 * Strip out the special beyond characters for \proper and \improper
 * from text that will be sent to the browser.
 */
#define strip_improper(input_text) replacetext(replacetext(input_text, "\proper", ""), "\improper", "")

/proc/pencode2html(t)
	t = replacetext(t, "\n", "<BR>")
	t = replacetext(t, "\[center\]", "<center>")
	t = replacetext(t, "\[/center\]", "</center>")
	t = replacetext(t, "\[br\]", "<BR>")
	t = replacetext(t, "\[b\]", "<B>")
	t = replacetext(t, "\[/b\]", "</B>")
	t = replacetext(t, "\[i\]", "<I>")
	t = replacetext(t, "\[/i\]", "</I>")
	t = replacetext(t, "\[u\]", "<U>")
	t = replacetext(t, "\[/u\]", "</U>")
	t = replacetext(t, "\[time\]", "[stationtime2text()]")
	t = replacetext(t, "\[date\]", "[stationdate2text()]")
	t = replacetext(t, "\[large\]", "<span style=\"font-size: 18px\">")
	t = replacetext(t, "\[/large\]", "</span>")
	t = replacetext(t, "\[field\]", "<span class=\"paper_field\"></span>")
	t = replacetext(t, "\[h1\]", "<H1>")
	t = replacetext(t, "\[/h1\]", "</H1>")
	t = replacetext(t, "\[h2\]", "<H2>")
	t = replacetext(t, "\[/h2\]", "</H2>")
	t = replacetext(t, "\[h3\]", "<H3>")
	t = replacetext(t, "\[/h3\]", "</H3>")
	t = replacetext(t, "\[*\]", "<li>")
	t = replacetext(t, "\[hr\]", "<HR>")
	t = replacetext(t, "\[small\]", "<span style=\"font-size: 10px\">")
	t = replacetext(t, "\[/small\]", "</span>")
	t = replacetext(t, "\[list\]", "<ul>")
	t = replacetext(t, "\[/list\]", "</ul>")
	t = replacetext(t, "\[table\]", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>")
	t = replacetext(t, "\[/table\]", "</td></tr></table>")
	t = replacetext(t, "\[grid\]", "<table>")
	t = replacetext(t, "\[/grid\]", "</td></tr></table>")
	t = replacetext(t, "\[row\]", "</td><tr>")
	t = replacetext(t, "\[cell\]", "<td>")
	t = replacetext(t, "\[logo\]", "<img src = exologo.png>")
	t = replacetext(t, "\[bluelogo\]", "<img src = bluentlogo.png>")
	t = replacetext(t, "\[solcrest\]", "<img src = sollogo.png>")
	t = replacetext(t, "\[torchltd\]", "<img src = exologo.png>")
	t = replacetext(t, "\[iccgseal\]", "<img src = terralogo.png>")
	t = replacetext(t, "\[ntlogo\]", "<img src = ntlogo.png>")
	t = replacetext(t, "\[daislogo\]", "<img src = daislogo.png>")
	t = replacetext(t, "\[eclogo\]", "<img src = eclogo.png>")
	t = replacetext(t, "\[xynlogo\]", "<img src = xynlogo.png>")
	t = replacetext(t, "\[fleetlogo\]", "<img src = fleetlogo.png>")
	t = replacetext(t, "\[sfplogo\]", "<img src = sfplogo.png>")
	t = replacetext(t, "\[falogo\]", "<img src = falogo.png>")
	// [SIERRA-ADD]
	t = replacetext(t, "\[ofbluelogo\]", "<img src = ofbluelogo.png>")
	t = replacetext(t, "\[ofntlogo\]", "<img src = ofntlogo.png>")
	t = replacetext(t, "\[foundlogo\]", "<img src = foundlogo.png>")
	t = replacetext(t, "\[ccalogo\]", "<img src = ccalogo.png>")
	t = replacetext(t, "\[sierralogo\]", "<img src = sierralogo.png>")
	t = replacetext(t, "\[saarelogo\]", "<img src = saarelogo.png>")
	t = replacetext(t, "\[pcrclogo\]", "<img src = pcrclogo.png>")
	t = replacetext(t, "\[zpcilogo\]", "<img src = zpcilogo.png>")
	t = replacetext(t, "\[hegemonylogo\]", "<img src = heglogo.png>")
	t = replacetext(t, "\[conventlogo\]", "<img src = convlogo.png>")
	t = replacetext(t, "\[leaguelogo\]", "<img src = leaguelogo.png>")
	t = replacetext(t, "\[ouerelogo\]", "<img src = ouerelogo.png>")
	t = replacetext(t, "\[terstenlogo\]", "<img src = terstenlogo.png>")
	// [/SIERRA-ADD]
	t = replacetext(t, "\[editorbr\]", "")
	return t

//pencode translation to html for tags exclusive to digital files (currently email, nanoword, report editor fields,
//modular scanner data and txt file printing) and prints from them
/proc/digitalPencode2html(text)
	text = replacetext(text, "\[pre\]", "<pre>")
	text = replacetext(text, "\[/pre\]", "</pre>")
	text = replacetext(text, "\[fontred\]", "<span style=\"color: red\">") //</span> to pass html tag integrity unit test
	text = replacetext(text, "\[fontblue\]", "<span style=\"color: blue\">")//</span> to pass html tag integrity unit test
	text = replacetext(text, "\[fontgreen\]", "<span style=\"color: green\">")
	text = replacetext(text, "\[/font\]", "</span>")
	text = replacetext(text, "\[redacted\]", "<span class=\"redacted\">R E D A C T E D</span>")
	return pencode2html(text)

//Will kill most formatting; not recommended.
/proc/html2pencode(t)
	t = replacetext(t, "<pre>", "\[pre\]")
	t = replacetext(t, "</pre>", "\[/pre\]")
	t = replacetext(t, "<span style=\"color: red\">", "\[fontred\]")//</span> to pass html tag integrity unit test
	t = replacetext(t, "<span style=\"color: blue\">", "\[fontblue\]")//</span> to pass html tag integrity unit test
	t = replacetext(t, "<span style=\"color: green\">", "\[fontgreen\]")
	t = replacetext(t, "</span>", "\[/font\]")
	t = replacetext(t, "<BR>", "\[br\]")
	t = replacetext(t, "<br>", "\[br\]")
	t = replacetext(t, "<B>", "\[b\]")
	t = replacetext(t, "</B>", "\[/b\]")
	t = replacetext(t, "<I>", "\[i\]")
	t = replacetext(t, "</I>", "\[/i\]")
	t = replacetext(t, "<U>", "\[u\]")
	t = replacetext(t, "</U>", "\[/u\]")
	t = replacetext(t, "<center>", "\[center\]")
	t = replacetext(t, "</center>", "\[/center\]")
	t = replacetext(t, "<H1>", "\[h1\]")
	t = replacetext(t, "</H1>", "\[/h1\]")
	t = replacetext(t, "<H2>", "\[h2\]")
	t = replacetext(t, "</H2>", "\[/h2\]")
	t = replacetext(t, "<H3>", "\[h3\]")
	t = replacetext(t, "</H3>", "\[/h3\]")
	t = replacetext(t, "<li>", "\[*\]")
	t = replacetext(t, "<HR>", "\[hr\]")
	t = replacetext(t, "<ul>", "\[list\]")
	t = replacetext(t, "</ul>", "\[/list\]")
	t = replacetext(t, "<table>", "\[grid\]")
	t = replacetext(t, "</table>", "\[/grid\]")
	t = replacetext(t, "<tr>", "\[row\]")
	t = replacetext(t, "<td>", "\[cell\]")
	t = replacetext(t, "<img src = ntlogo.png>", "\[ntlogo\]")
	t = replacetext(t, "<img src = bluentlogo.png>", "\[bluelogo\]")
	t = replacetext(t, "<img src = sollogo.png>", "\[solcrest\]")
	t = replacetext(t, "<img src = terralogo.png>", "\[iccgseal\]")
	t = replacetext(t, "<img src = exologo.png>", "\[logo\]")
	t = replacetext(t, "<img src = eclogo.png>", "\[eclogo\]")
	t = replacetext(t, "<img src = daislogo.png>", "\[daislogo\]")
	t = replacetext(t, "<img src = xynlogo.png>", "\[xynlogo\]")
	t = replacetext(t, "<img src = sfplogo.png>", "\[sfplogo\]")
	t = replacetext(t, "<img src = falogo.png>", "\[falogo\]")
	// [SIERRA-ADD]
	t = replacetext(t, "<img src = ofbluelogo.png>", "\[ofbluelogo\]" )
	t = replacetext(t, "<img src = ofntlogo.png>", "\[ofntlogo\]" )
	t = replacetext(t, "<img src = foundlogo.png>", "\[foundlogo\]" )
	t = replacetext(t, "<img src = ccalogo.png>", "\[ccalogo\]" )
	t = replacetext(t, "<img src = sierralogo.png>", "\[sierralogo\]" )
	t = replacetext(t, "<img src = saarelogo.png>", "\[saarelogo\]")
	t = replacetext(t, "<img src = pcrclogo.png>", "\[pcrclogo\]")
	t = replacetext(t, "<img src = zpcilogo.png>", "\[zpcilogo\]")
	t = replacetext(t, "<img src = heglogo.png>", "\[hegemonylogo\]")
	t = replacetext(t, "<img src = convlogo.png>", "\[conventlogo\]")
	t = replacetext(t, "<img src = leaguelogo.png>", "\[leaguelogo\]")
	t = replacetext(t, "<img src = ouerelogo.png>", "\[ouerelogo\]")
	t = replacetext(t, "<img src = terstenlogo.png>", "\[terstenlogo\]")
	// [/SIERRA-ADD]
	t = replacetext(t, "<span class=\"paper_field\"></span>", "\[field\]")
	t = replacetext(t, "<span class=\"redacted\">R E D A C T E D</span>", "\[redacted\]")
	t = strip_html_properly(t)
	return t

// Random password generator
/proc/GenerateKey()
	//Feel free to move to Helpers.
	var/newKey
	newKey += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newKey += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "big", "escape", "yellow", "gloves", "monkey", "engine", "nuclear", "ai")
	newKey += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return newKey

//Used for applying byonds text macros to strings that are loaded at runtime
/proc/apply_text_macros(string)
	var/next_backslash = findtext(string, "\\")
	if(!next_backslash)
		return string

	var/leng = length(string)

	var/next_space = findtext(string, " ", next_backslash + 1)
	if(!next_space)
		next_space = leng - next_backslash

	if(!next_space)	//trailing bs
		return string

	var/base = next_backslash == 1 ? "" : copytext(string, 1, next_backslash)
	var/macro = lowertext(copytext(string, next_backslash + 1, next_space))
	var/rest = next_backslash > leng ? "" : copytext(string, next_space + 1)

	//See http://www.byond.com/docs/ref/info.html#/DM/text/macros
	switch(macro)
		//prefixes/agnostic
		if("the")
			rest = text("\the []", rest)
		if("a")
			rest = text("\a []", rest)
		if("an")
			rest = text("\an []", rest)
		if("proper")
			rest = text("\proper []", rest)
		if("improper")
			rest = text("\improper []", rest)
		if("roman")
			rest = text("\roman []", rest)
		//postfixes
		if("th")
			base = text("[]\th", rest)
		if("s")
			base = text("[]\s", rest)
		if("he")
			base = text("[]\he", rest)
		if("she")
			base = text("[]\she", rest)
		if("his")
			base = text("[]\his", rest)
		if("himself")
			base = text("[]\himself", rest)
		if("herself")
			base = text("[]\herself", rest)
		if("hers")
			base = text("[]\hers", rest)

	. = base
	if(rest)
		. += .(rest)

/proc/deep_string_equals(A, B)
	if (length(A) != length(B))
		return FALSE
	for (var/i = 1 to length(A))
		if (text2ascii(A, i) != text2ascii(B, i))
			return FALSE
	return TRUE

// If char isn't part of the text the entire text is returned
/proc/copytext_after_last(text, char)
	var/regex/R = regex("(\[^[char]\]*)$")
	R.Find_char(text)
	return R.group[1]

/proc/sql_sanitize_text(text)
	text = replacetext(text, "'", "''")
	text = replacetext(text, ";", "")
	text = replacetext(text, "&", "")
	return text

/proc/text2num_or_default(text, default)
	var/result = text2num(text)
	return "[result]" == text ? result : default

/proc/text2regex(text)
	var/end = findlasttext_char(text, "/")
	if (end > 2 && length_char(text) > 2 && copytext_char(text, 1, 2) == "/")
		var/flags = end == length_char(text) ? FALSE : copytext_char(text, end + 1)
		var/matcher = copytext_char(text, 2, end)
		try
			return flags ? regex(matcher, flags) : regex(matcher)
		catch()
	log_error("failed to parse text to regex: [text]")

/proc/process_chat_markup(message)
	if (message && length(config.chat_markup))
		for (var/list/entry in config.chat_markup)
			var/regex/matcher = entry[1]
			message = replacetext_char(message, matcher, entry[2])
	return message


/**
* Connects either a list or variadic arguments with "/" and cleans up multiple joins.
* eg:
*   join_url("a", "b", "c") => "a/b/c"
*   join_url(list("a", "b", "c")) => "a/b/c"
*   join_url("https://some.tld/", "/cats", "~", "//dogs") => "https://some.tld/cats/~/dogs"
*/
/proc/join_url()
	var/len = length(args)
	if (!len)
		return ""
	var/list/parts
	if (len == 1)
		if (!islist(args[1]))
			parts = list(args[1])
		else
			parts = args[1]
	else
		parts = args
	var/static/regex/clean1 = regex(@"\/\/+", "g") //Squash //+ to /
	var/static/regex/clean2 = regex(@"^([^:]+:)\/([^\/])") //Fix "blah://" if we killed it in clean1
	parts = replacetext_char(parts.Join("/"), clean1, "/")
	return replacetext_char(parts, clean2, "$1//$2")

/// Returns direction-string, rounded to multiples of 22.5, from the first parameter to the second
/// N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
/proc/get_compass_direction_string(turf/A, turf/B)
	var/degree = Get_Angle(A, B)
/// % appears to round down floats, hence below values all being integers
	switch(round(degree, 22.5) % 360)
		if(0)
			return "North"
		if(22)
			return "North-Northeast"
		if(45)
			return "Northeast"
		if(67)
			return "East-Northeast"
		if(90)
			return "East"
		if(112)
			return "East-Southeast"
		if(135)
			return "Southeast"
		if(157)
			return "South-Southeast"
		if(180)
			return "South"
		if(202)
			return "South-Southwest"
		if(225)
			return "Southwest"
		if(247)
			return "West-Southwest"
		if(270)
			return "West"
		if(292)
			return "West-Northwest"
		if(315)
			return "Northwest"
		if(337)
			return "North-Northwest"


/// Check if thing is an SUID. If other is supplied, check if other matches thing.
/proc/is_suid(thing, other)
	var/static/regex/suid_check = regex(@"^~[0-9a-zA-Z]{15}$")
	if (other && other != thing)
		return FALSE
	return findtext(thing, suid_check)
