/obj/item/pen/crayon/red
	icon_state = "crayonred"
	colour = "#da0000"
	shadeColour = "#810c0c"
	colourName = "red"
	color_description = "red crayon"
	crayon_reagent = /datum/reagent/crayon_dust/red

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	colour = "#ff9300"
	shadeColour = "#a55403"
	colourName = "orange"
	color_description = "orange crayon"
	crayon_reagent = /datum/reagent/crayon_dust/orange

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#fff200"
	shadeColour = "#886422"
	colourName = "yellow"
	color_description = "yellow crayon"
	crayon_reagent = /datum/reagent/crayon_dust/yellow

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	colour = "#a8e61d"
	shadeColour = "#61840f"
	colourName = "green"
	color_description = "green crayon"
	crayon_reagent = /datum/reagent/crayon_dust/green

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	colour = "#00b7ef"
	shadeColour = "#0082a8"
	colourName = "blue"
	color_description = "blue crayon"
	crayon_reagent = /datum/reagent/crayon_dust/blue

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = "#da00ff"
	shadeColour = "#810cff"
	colourName = "purple"
	color_description = "purple crayon"
	crayon_reagent = /datum/reagent/crayon_dust/purple


/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#ffffff"
	shadeColour = "#000000"
	colourName = "mime"
	color_description = "white crayon"
	uses = 0
	crayon_reagent = /datum/reagent/crayon_dust/grey

/obj/item/pen/crayon/mime/attack_self(mob/living/user as mob) //inversion
	if (colour != "#ffffff" && shadeColour != "#000000")
		colour = "#ffffff"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		colour = "#000000"
		shadeColour = "#ffffff"
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#fff000"
	shadeColour = "#000fff"
	colourName = "rainbow"
	color_description = "rainbow crayon"
	uses = 0
	crayon_reagent = /datum/reagent/crayon_dust/brown

/obj/item/pen/crayon/rainbow/attack_self(mob/living/user as mob)
	colour = input(user, "Please select the main colour.", "Crayon colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Crayon colour") as color
	return

/obj/item/pen/crayon/afterattack(atom/target, mob/user as mob, proximity)
	if (!proximity) return
	if (istype(target,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter","arrow", "defector graffiti")
		switch (drawtype)
			if ("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
			if ("graffiti", "Fleet defector graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if ("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if ("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
			if ("defector graffiti")
				to_chat(user, "You start drawing defector graffiti on the [target.name].")
		if (instant || do_after(user, 5 SECONDS, target, DO_PUBLIC_UNIQUE))
			new /obj/effect/decal/cleanable/crayon(target,colour,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			if (uses)
				uses--
				if (!uses)
					to_chat(user, SPAN_WARNING("You used up your crayon!"))
					qdel(src)
	return

/obj/item/pen/crayon/attack(mob/living/carbon/M as mob, mob/user as mob)
	if (istype(M) && M == user)
		to_chat(M, "You take a bite of the crayon and swallow it.")
		M.adjust_nutrition(1)
		M.reagents.add_reagent(/datum/reagent/crayon_dust,min(5,uses)/3)
		if (uses)
			uses -= 5
			if (uses <= 0)
				to_chat(M, SPAN_WARNING("You ate your crayon!"))
				qdel(src)
	else
		..()


/obj/random/crayon
	name = "Random Crayon"
	desc = "This is a random crayon."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonrainbow"


/obj/random/crayon/spawn_choices()
	return subtypesof(/obj/item/pen/crayon)
