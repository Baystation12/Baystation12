/obj/item/weapon/pen/marker/red
	icon_state = "markerred"
	colour = "#da0000"
	shadeColour = "#810c0c"
	colourName = "red"

/obj/item/weapon/pen/marker/orange
	icon_state = "markerorange"
	colour = "#ff9300"
	shadeColour = "#a55403"
	colourName = "orange"

/obj/item/weapon/pen/marker/yellow
	icon_state = "markeryellow"
	colour = "#fff200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/weapon/pen/marker/green
	icon_state = "markergreen"
	colour = "#a8e61d"
	shadeColour = "#61840f"
	colourName = "green"

/obj/item/weapon/pen/marker/blue
	icon_state = "markerblue"
	colour = "#00b7ef"
	shadeColour = "#0082a8"
	colourName = "blue"

/obj/item/weapon/pen/marker/purple
	icon_state = "markerpurple"
	colour = "#da00ff"
	shadeColour = "#810cff"
	colourName = "purple"

/obj/item/weapon/pen/marker/black
	icon_state = "markerblack"
	colour = "#000000"
	shadeColour = "#3d3d3d"
	colourName = "black"

/obj/item/weapon/pen/marker/random/initialize()
	var/marker_type = pick(subtypesof(/obj/item/weapon/pen/marker) - /obj/item/weapon/pen/marker/random)
	new marker_type(loc)
	qdel(src)

/obj/item/weapon/pen/marker/mime
	icon_state = "markermime"
	desc = "A very sad-looking marker."
	colour = "#ffffff"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/weapon/pen/marker/mime/attack_self(mob/living/user as mob) //inversion
	if(colour != "#ffffff" && shadeColour != "#000000")
		colour = "#ffffff"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this marker.")
	else
		colour = "#000000"
		shadeColour = "#ffffff"
		to_chat(user, "You will now draw in black and white with this marker.")
	return

/obj/item/weapon/pen/marker/rainbow
	icon_state = "markerrainbow"
	colour = "#fff000"
	shadeColour = "#000fff"
	colourName = "rainbow"
	uses = 0

/obj/item/weapon/pen/marker/rainbow/attack_self(mob/living/user as mob)
	colour = input(user, "Please select the main colour.", "marker colour") as color
	shadeColour = input(user, "Please select the shade colour.", "marker colour") as color
	return

/obj/item/weapon/pen/marker/proc/write_message()
	var/inputphrases = list(
		"**** ahead.",
		"Look out for ****.",
		"Try ****.",
		"Need ****.",
		"Have ****.",
		"Want ****.",
		"Get ****.",
		"Imminent ****...",
		"Weakness: ****",
		"****.",
		"****?")
	var/catcharacters = list("enemy","soldier","security guard","robot","wizard","captain","skeleton","ghost","spider","lizard","engineer","roboticist","research director","statue","scientist","strange creature","doctor","chemist","head of personnel","chaplain","wretch","charmer","miscreant","liar","fatty","beanpole","cargo technician","head of security","master","prisoner")
	var/catobjects = list("fire","lever","switch","door","loot","weapon","shield","projectile","armor","item","trap","crate","locker","gun","laser","tool","clothes","hat","device")
	var/cattechniques = list("close-quarters combat","gunfight","taking hostages","luring it out","beating to a pulp","lying in ambush","stealth","leaving messages","leaving hints","bombing","fleeing","serpentine","charging in","diversion","EMP","grenade","headshots","lying down","dashing through")
	var/catactions = list("sleeping","stepping back","jumping","attacking","holding with both hands","kicking","stabbing","shooting","dodging","building","healing","hiding","talking","whispering","drinking","eating")
	var/catgeography = list("hallway","hidden door","shortcut","detour","dead end","maintenance tunnel","labyrinth","space","safe zone","danger zone","bright spot","dark spot","open area","tight spot","hidden room","secure room","research","cargo","security","bridge","engineering","medical","bar","kitchen","arrivals","vault")
	var/catorientation = list("front","back","left","right","up","down","feet","head","back")
	var/catbodyparts = list("head","neck","stomach","back","arm","leg","heel","rear","tail","wings","anywhere")
	var/catattributes = list("magic","burn","bleeding","toxin","brain damage","suffocation","brute force","SSD")
	var/catconcepts = list("chance","hint","secret","happiness","sorrow","life","death","elation","grief","hope","despair","light","dark","bravery","resignation","comfort","tears","apathy","lust","robust")
	var/catphrases = list("Robust Softdrinks: more robust than a toolbox to the head","Report suspicious behavior","Help me","Stay safe","I need coffee","Another day, another thaler","Have you seen Ian","Do you know how much faxes cost","why me","help","they're coming","I <3 Beepsky","Don't eat markers, kids","the end is nigh")
	var/fillcategory
	var/basephrase = input("Choose your base phrase.", "Write a message") in inputphrases
	var/fillphrase
	fillcategory = input("Choose a phrase category to fill in the blank.", "Write a message") in list("Characters","Objects","Techniques","Actions","Geography","Orientation","Body Parts","Attributes","Concepts","Phrases")
	switch(fillcategory)
		if("Characters")
			fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catcharacters
		if("Objects")
			fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catobjects
		if("Techniques")
			fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in cattechniques
		if("Actions")
			fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catactions
		if("Geography")
			fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catgeography
		if("Orientation")
			fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catorientation
		if("Body Parts")
			fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catbodyparts
		if("Attributes")
			fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catattributes
		if("Phrases")
			fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catphrases
		else
			fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catconcepts
	var/message = "blank"
	switch(basephrase)
		if("**** ahead.")
			message = "[fillphrase] ahead."
		if("Look out for ****.")
			message = "Look out for [fillphrase]."
		if("Try ****.")
			message = "Try [fillphrase]."
		if("Need ****.")
			message = "Need [fillphrase]."
		if("Have ****.")
			message = "Have [fillphrase]."
		if("Want ****.")
			message = "Want [fillphrase]."
		if("Get ****.")
			message = "Get [fillphrase]."
		if("Imminent ****...")
			message = "Imminent [fillphrase]..."
		if("Weakness: ****")
			message = "Weakness: [fillphrase]."
		if("****?")
			message = "[fillphrase]?"
		if("****")
			message = "[fillphrase]."
		else
			message = basephrase
	return message

/obj/item/weapon/pen/marker/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.", "marker scribbles") in list("graffiti","rune","letter","arrow","message")
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "marker scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
				desc = "The letter [drawtype] drawn in permanent marker."
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
				desc = "Graffiti drawn in permanent marker."
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "marker scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
				desc = "An arrow drawn in permanent marker."
			if("message")
				var/message = write_message()
				to_chat(user, "You start writing a message on the [target.name].")
				drawtype = "message"
				desc = "A helpful (or not) message from a fellow crewmember, written in permanent marker. It reads, '[message]'"
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/marker(target,colour,shadeColour,drawtype,desc)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the marker is drawn on.
			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='warning'>Your marker ran dry!</span>")
					qdel(src)
	return

/*/obj/item/weapon/pen/marker/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(istype(M) && M == user)
		to_chat(M, "You take a bite of the marker and swallow it.")
		M.nutrition += 1
		M.reagents.add_reagent("marker_ink",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(M, "<span class='warning'>You ate your marker!</span>")
				qdel(src)
	else
		..()*/
//Don't eat markers, kids.
