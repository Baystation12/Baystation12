/obj/item/weapon/pen/crayon/red
	icon_state = "crayonred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/weapon/pen/crayon/orange
	icon_state = "crayonorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"

/obj/item/weapon/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/weapon/pen/crayon/green
	icon_state = "crayongreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"

/obj/item/weapon/pen/crayon/blue
	icon_state = "crayonblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/weapon/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/weapon/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/weapon/pen/crayon/mime/attack_self(mob/living/user as mob) //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		user << "You will now draw in white and black with this crayon."
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		user << "You will now draw in black and white with this crayon."
	return

/obj/item/weapon/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
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
				user << "You start drawing a letter on the [target.name]."
			if("graffiti")
				user << "You start drawing graffiti on the [target.name]."
			if("rune")
				user << "You start drawing a rune on the [target.name]."
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				user << "You start drawing an arrow on the [target.name]."
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/crayon(target,colour,shadeColour,drawtype)
			user << "You finish drawing."
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			if(uses)
				uses--
				if(!uses)
					user << "<span class='warning'>You used up your crayon!</span>"
					qdel(src)
	return

/obj/item/weapon/pen/crayon/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		user << "You take a bite of the crayon and swallow it."
		user.nutrition += 1
		user.reagents.add_reagent("crayon_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				user << "<span class='warning'>You ate your crayon!</span>"
				qdel(src)
	else
		..()
