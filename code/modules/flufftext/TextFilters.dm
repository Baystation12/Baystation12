//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

proc/Intoxicated(phrase)
	phrase = html_decode(phrase)
	var/leng=lentext(phrase)
	var/counter=lentext(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
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

	var/list/split_phrase = text2list(phrase," ") //Split it up into words.

	var/list/unstuttered_words = split_phrase.Copy()
	var/i = rand(1,3)
	if(stunned) i = split_phrase.len
	for(,i > 0,i--) //Pick a few words to stutter on.

		if (!unstuttered_words.len)
			break
		var/word = pick(unstuttered_words)
		unstuttered_words -= word //Remove from unstuttered words so we don't stutter it again.
		var/index = split_phrase.Find(word) //Find the word in the split phrase so we can replace it.

		//Search for dipthongs (two letters that make one sound.)
		var/first_sound = copytext(word,1,3)
		var/first_letter = copytext(word,1,2)
		if(lowertext(first_sound) in list("ch","th","sh"))
			first_letter = first_sound

		//Repeat the first letter to create a stutter.
		var/rnum = rand(1,3)
		switch(rnum)
			if(1)
				word = "[first_letter]-[word]"
			if(2)
				word = "[first_letter]-[first_letter]-[word]"
			if(3)
				word = "[first_letter]-[word]"

		split_phrase[index] = word

	return sanitize(list2text(split_phrase," "))

proc/Stagger(mob/M,d) //Technically not a filter, but it relates to drunkenness.
	step(M, pick(d,turn(d,90),turn(d,-90)))

proc/Ellipsis(original_msg, chance = 50)
	if(chance <= 0) return "..."
	if(chance >= 100) return original_msg

	var/list
		words = text2list(original_msg," ")
		new_words = list()

	var/new_msg = ""

	for(var/w in words)
		if(prob(chance))
			new_words += "..."
		else
			new_words += w

	new_msg = list2text(new_words," ")

	return new_msg

//Makes messages get gradually more distorted throughout the message.
proc/RadioChat(message, distortion_chance = 60, distortion_speed = 1)
	var/new_message = ""
	var/progress = 1
	var/list/string = string_explode(message, " ")
	for(var/i=1, i<=string.len, i++)
		var/character_index = length(string[i])
		while(character_index > 0)
			var/temp = 0
			var/newletter = copytext(string[i], character_index, character_index+1)
			if(newletter != " ")
				if(prob(distortion_chance * progress) && newletter != ".")
					if(prob(0.25 * progress))
						newletter = pick("*zzzt*", "...", "- ") // Audible minor cutout
						i += rand(1, (length(message) - i))
						temp += 1
					else if(prob(1 * progress))
						newletter = "..." // Random silences
						temp += 0.25
					else if(prob(1.5 * progress))
						newletter =	pick("a","e","i","o","u") // Minor mishearing.
						temp += 0.25
					else if(prob(1.25 * progress))
						newletter = pick("ø", "Ð", "%", "æ", "µ") // Major mishearings
						temp += 0.5
					else if(prob(0.01 * progress))
						newletter = "¦w¡¼b»%>-BZZT-"	 // Audible major cutout
						new_message += newletter
						break
			else
				if(prob(2 * progress))
					newletter = " *crackle* "
					progress += 0.25 * distortion_speed
			new_message += newletter
			progress += temp * distortion_speed
			temp = 0
			character_index--
	return new_message

