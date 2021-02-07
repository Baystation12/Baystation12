//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

proc/Intoxicated(phrase)
	phrase = html_decode(phrase)
	var/leng=length(phrase)
	var/counter=length(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext_char(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		switch(rand(1,7))
			if(1,3,5,8)	newletter="[lowertext(newletter)]"
			if(2,4,6,15)	newletter="[uppertext(newletter)]"
			if(7)	newletter+="'"
			//if(9,10)	newletter="<b>[newletter]</b>"
			//if(11,12)	newletter="<big>[newletter]</big>"
			//if(13)	newletter="<small>[newletter]</small>"
		newphrase+="[newletter]";counter-=1
	return newphrase

proc/NewStutter(phrase,stunned)
	phrase = html_decode(phrase)
	var/new_phrase = ""
	for(var/i = 1, i <= length_char(phrase), i++)
		var/letter = copytext_char(phrase, i, i + 1)
		new_phrase += letter
		if(lowertext(letter) in list("б", "г", "д", "к", "п", "т", "ц", "ч", "b", "c", "d", "f", "g", "j", "k", "p", "q", "t", "x"))
			while(prob(45))
				new_phrase += "-[letter]"
	return html_encode(new_phrase)

proc/Stagger(mob/M,d) //Technically not a filter, but it relates to drunkenness.
	step(M, pick(d,turn(d,90),turn(d,-90)))

proc/Ellipsis(original_msg, chance = 50)
	if(chance <= 0) return "..."
	if(chance >= 100) return original_msg

	var/list/words = splittext(original_msg," ")
	var/list/new_words = list()

	var/new_msg = ""

	for(var/w in words)
		if(prob(chance))
			new_words += "..."
		else
			new_words += w

	new_msg = jointext(new_words," ")

	return new_msg
/*
RadioChat Filter.
args:
message - returns a distorted version of this
distortion_chance - the chance of a filter being applied to each character.
distortion_speed - multiplier for the chance increase.
distortion - starting distortion.
english_only - whether to use traditional english letters only (for use in NanoUI)
*/
proc/RadioChat(mob/living/user, message, distortion_chance = 60, distortion_speed = 1, distortion = 1, english_only = 0)
	var/datum/language/language
	if(user)
		language = user.get_default_language()
	message = html_decode(message)
	var/new_message = ""
	var/input_size = length(message)
	var/lentext = 0
	if(input_size < 20) // Short messages get distorted too. Bit hacksy.
		distortion += (20-input_size)/2
	while(lentext <= input_size)
		var/newletter=copytext(message, lentext, lentext+1)
		if(!prob(distortion_chance))
			new_message += newletter
			lentext += 1
			continue
		if(newletter != " ")
			if(prob(0.08 * distortion)) // Major cutout
				newletter = "*zzzt*"
				lentext += rand(1, (length(message) - lentext)) // Skip some characters
				distortion += 1 * distortion_speed
			else if(prob(0.8 * distortion)) // Minor cut out
				if(prob(25))
					newletter = ".."
				else if(prob(25))
					newletter = " "
				else
					newletter = ""
				distortion += 0.25 * distortion_speed
			else if(prob(2 * distortion)) // Mishearing
				if(language && language.syllables && prob(50))
					newletter = pick(language.syllables)
				else
					newletter =	pick("a","e","i","o","u")
				distortion += 0.25 * distortion_speed
			else if(prob(1.5 * distortion)) // Mishearing
				if(language && prob(50))
					if(language.syllables)
						newletter = pick (language.syllables)
					else
						newletter = "*"
				else
					if(english_only)
						newletter += "*"
					else
						newletter = pick("<", ">", "!", "$", "%")
				distortion += 0.5 * distortion_speed
			else if(prob(0.75 * distortion)) // Incomprehensible
				newletter = pick("<", ">", "!", "$", "%", "^", "&", "*", "~", "#")
				distortion += 0.75 * distortion_speed
			else if(prob(0.05 * distortion)) // Total cut out
				if(!english_only)
					newletter = "srgt%$hjc< -BZZT-"
				else
					newletter = "srgt%$hjc< -BZZT-"
				new_message += newletter
				break
			else if(prob(2.5 * distortion)) // Sound distortion. Still recognisable, mostly.
				switch(lowertext(newletter))
					if("s")
						newletter = "$"
					if("e")
						newletter = "э"
					if("w")
						newletter = "щ"
					if("y")
						newletter = "ю"
					if("x")
						newletter = "х"
					if("u")
						newletter = "m"
		else
			if(prob(0.2 * distortion))
				newletter = " *crackle* "
				distortion += 0.25 * distortion_speed
		if(prob(20))
			capitalize(newletter)
		new_message += newletter
		lentext += 1
	return new_message

