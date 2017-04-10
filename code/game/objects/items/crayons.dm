/obj/item/weapon/pen/crayon/red
	icon_state = "crayonred"
	colour = "#da0000"
	shadeColour = "#810c0c"
	colourName = "red"

/obj/item/weapon/pen/crayon/orange
	icon_state = "crayonorange"
	colour = "#ff9300"
	shadeColour = "#a55403"
	colourName = "orange"

/obj/item/weapon/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#fff200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/weapon/pen/crayon/green
	icon_state = "crayongreen"
	colour = "#a8e61d"
	shadeColour = "#61840f"
	colourName = "green"

/obj/item/weapon/pen/crayon/blue
	icon_state = "crayonblue"
	colour = "#00b7ef"
	shadeColour = "#0082a8"
	colourName = "blue"

/obj/item/weapon/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = "#da00ff"
	shadeColour = "#810cff"
	colourName = "purple"

/obj/item/weapon/pen/crayon/random/initialize()
	var/crayon_type = pick(subtypesof(/obj/item/weapon/pen/crayon) - /obj/item/weapon/pen/crayon/random)
	new crayon_type(loc)
	qdel(src)

/obj/item/weapon/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#ffffff"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/weapon/pen/crayon/mime/attack_self(mob/living/user as mob) //inversion
	if(colour != "#ffffff" && shadeColour != "#000000")
		colour = "#ffffff"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		colour = "#000000"
		shadeColour = "#ffffff"
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/weapon/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#fff000"
	shadeColour = "#000fff"
	colourName = "rainbow"
	uses = 0

/obj/item/weapon/pen/crayon/rainbow/attack_self(mob/living/user as mob)
	colour = input(user, "Please select the main colour.", "Crayon colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Crayon colour") as color
	return

/obj/item/weapon/pen/crayon/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter","arrow")
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/crayon(target,colour,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='warning'>You used up your crayon!</span>")
					qdel(src)
	return

/obj/item/weapon/pen/crayon/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(istype(M) && M == user)
		to_chat(M, "You take a bite of the crayon and swallow it.")
		M.nutrition += 1
		M.reagents.add_reagent("crayon_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(M, "<span class='warning'>You ate your crayon!</span>")
				qdel(src)
	else
		..()

/obj/item/weapon/pen/soapstone
	name = "orange guidance soapstone"
	icon = 'icons/obj/crayons.dmi'
	icon_state = "soapstone"
	var/instant = 0

/obj/item/weapon/pen/soapstone/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/catcharacters = list("enemy","tough enemy","soldier","knight","sniper","caster","giant","skeleton","ghost","bug","lizard","flier","golem","statue","monster","strange creature","demon","dragon","boss","saint","wretch","charmer","miscreant","liar","fatty","beanpole","merchant","blacksmith","master","prisoner")
		var/catobjects = list("bonfire","lever","switch","key","treasure","weapon","shield","projectile","armor","item","trap","amazing key","amazing treasure","amazing chest","amazing weapon","amazing shield","amazing projectile","amazing armor","amazing item","amazing trap")
		var/cattechniques = list("close-ranged battle","ranged battle","eliminating one at a time","luring it out","beating to a pulp","lying in ambush","stealth","mimicry","pincer attack","hitting them in one swoop","fleeing","serpentine","charging","stabbing in the back","sweeping attack","shield-breaking","headshots","jumping off","sliding down","dashing through")
		var/catactions = list("rolling","stepping back","jumping","attacking","holding with both hands","kicking","plunging attack","thrusting attack","blocking","parrying")
		var/catgeography = list("path","hidden path","shortcut","detour","dead end","cave","labyrinth","safe zone","danger zone","sniper spot","bright spot","dark spot","open area","tight spot","hidden place","exchange","gorgeous view","fall")
		var/catorientation = list("front","back","left","right","up","down","feet","head","back")
		var/catbodyparts = list("head","neck","stomach","back","arm","leg","heel","rear","tail","wings","anywhere")
		var/catattributes = list("strike","thrust","slash","magic","fire","bleeding","poison","curses","divine","occult")
		var/catconcepts = list("chance","hint","secret","happiness","sorrow","life","death","undead","elation","grief","hope","despair","light","dark","bravery","resignation","comfort","tears","apathy","lust")
		var/basephrase = input("Choose your base phrase.", "Write a message") in list("**** ahead.","Be wary of ****.","Try ****.","Need ****.","Imminent ****...","Weakness: ****","****.","****?","Good luck.","I did it!","Here!","I can't take this...","Praise the Sun!")
		var/fillphrase
		var/fillcategory
		var/inputphrases = list(
			"**** ahead.",
			"Be wary of ****.",
			"Try ****.",
			"Need ****.",
			"Imminent ****...",
			"Weakness: ****",
			"****.",
			"****?")
		if(basephrase in inputphrases)
			fillcategory = input("Choose a phrase category to fill in the blank.", "Write a message") in list("Characters","Objects","Techniques","Actions","Geography","Orientation","Body Parts","Attributes","Concepts")
			switch(fillcategory)
				if("Characters")
					fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catcharacters
					to_chat(user, "You begin writing...")
				if("Objects")
					fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catobjects
					to_chat(user, "You begin writing...")
				if("Techniques")
					fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in cattechniques
					to_chat(user, "You begin writing...")
				if("Actions")
					fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catactions
					to_chat(user, "You begin writing...")
				if("Geography")
					fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catgeography
					to_chat(user, "You begin writing...")
				if("Orientation")
					fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catorientation
					to_chat(user, "You begin writing...")
				if("Body Parts")
					fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catbodyparts
					to_chat(user, "You begin writing...")
				if("Attributes")
					fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catattributes
					to_chat(user, "You begin writing...")
				else
					fillphrase = input("Choose a phrase to fill in the blank.", "Write a message") in catconcepts
					to_chat(user, "You begin writing...")
		else
			to_chat(user, "You begin writing...")
		var/message = "blank"
		switch(basephrase)
			if("**** ahead.")
				message = "[fillphrase] ahead."
			if("Be wary of ****.")
				message = "Be wary of [fillphrase]."
			if("Try ****.")
				message = "Try [fillphrase]."
			if("Need ****.")
				message = "Need [fillphrase]."
			if("Imminent ****...")
				message = "Imminent [fillphrase]..."
			if("Weakness: ****")
				message = "Weakness: [fillphrase]."
			if("****?")
				message = "[fillphrase]?"
			if("****.")
				message = "[fillphrase]."
			else
				message = basephrase
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/guidance(target,message)
			to_chat(user, "You finish writing your message.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
	return