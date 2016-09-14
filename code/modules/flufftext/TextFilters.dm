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

	var/list/split_phrase = splittext(phrase," ") //Split it up into words.

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

	return sanitize(jointext(split_phrase," "))

proc/Stagger(mob/M,d) //Technically not a filter, but it relates to drunkenness.
	step(M, pick(d,turn(d,90),turn(d,-90)))

proc/Ellipsis(original_msg, chance = 50)
	if(chance <= 0) return "..."
	if(chance >= 100) return original_msg

	var/list
		words = splittext(original_msg," ")
		new_words = list()

	var/new_msg = ""

	for(var/w in words)
		if(prob(chance))
			new_words += "..."
		else
			new_words += w

	new_msg = jointext(new_words," ")

	return new_msg

proc/RadioChat(message, distortion_chance = 60, distortion_speed = 1, english_only = 0)
	var/new_message = ""
	var/p = 1 // progress
	for(var/i=1, i<=length(message), i++)
		var/newletter=copytext(message, i, i+1)
		if(newletter != " ")
			if(prob(distortion_chance * p) && newletter != ".")
				if(prob(0.1 * p))
					newletter = "*zzzt*" // Audible minor cutout
					i += rand(1, (length(message) - i))
					p += 1 * distortion_speed
				else if(prob(1 * p))
					newletter = ".." // Random silences
					p += 0.25 * distortion_speed
				else if(prob(2 * p))
					newletter =	pick("a","e","i","o","u") // Minor mishearing.
					p += 0.25 * distortion_speed
				else if(prob(1.5 * p) && !english_only)
					newletter = pick("ø", "Ð", "%", "æ", "µ") // Major mishearings
					p += 0.5 * distortion_speed
				else if(prob(0.05 * p))
					if(!english_only)
						newletter = "¦w¡¼b»%>-BZZT-"	 // Audible major cutout
					else
						newletter = "srgt%$hjc-sda.BZZT"
					new_message += newletter
					break
		else
			if(prob(0.15 * p))
				newletter = " *crackle* "
				p += 0.25 * distortion_speed
		new_message += newletter
	return new_message

