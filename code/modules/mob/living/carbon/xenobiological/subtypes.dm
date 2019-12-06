/mob/living/carbon/slime/proc/GetMutations()
	switch(src.colour)
		if("grey")
			return list("orange", "metal", "blue", "purple")
		if("purple")
			return list("dark purple", "dark blue", "green", "green")
		if("metal")
			return list("silver", "yellow", "gold", "gold")
		if("orange")
			return list("dark purple", "yellow", "red", "red")
		if("blue")
			return list("dark blue", "silver", "pink", "pink")
		//Tier 3
		if("dark blue")
			return list("purple", "cerulean", "blue", "blue")
		if("dark purple")
			return list("purple", "sepia", "orange", "orange")
		if("yellow")
			return list("bluespace", "metal", "orange", "orange")
		if("silver")
			return list("metal", "pyrite", "blue", "blue")
		//Tier 4
		if("pink")
			return list("pink", "pink", "light pink", "light pink")
		if("red")
			return list("red", "red", "oil", "oil")
		if("gold")
			return list("gold", "gold", "adamantine", "adamantine")
		if("green")
			return list("green", "green", "black", "black")
		// Tier 5
		else
			return list()

/mob/living/carbon/slime/proc/GetCoreType()
	switch(src.colour)
		// Tier 1
		if("grey")
			return /obj/item/slime_extract/grey
		// Tier 2
		if("purple")
			return /obj/item/slime_extract/purple
		if("metal")
			return /obj/item/slime_extract/metal
		if("orange")
			return /obj/item/slime_extract/orange
		if("blue")
			return /obj/item/slime_extract/blue
		// Tier 3
		if("dark blue")
			return /obj/item/slime_extract/darkblue
		if("dark purple")
			return /obj/item/slime_extract/darkpurple
		if("yellow")
			return /obj/item/slime_extract/yellow
		if("silver")
			return /obj/item/slime_extract/silver
		// Tier 4
		if("pink")
			return /obj/item/slime_extract/pink
		if("red")
			return /obj/item/slime_extract/red
		if("gold")
			return /obj/item/slime_extract/gold
		if("green")
			return /obj/item/slime_extract/green
		if("sepia")
			return /obj/item/slime_extract/sepia
		if("bluespace")
			return /obj/item/slime_extract/bluespace
		if("cerulean")
			return /obj/item/slime_extract/cerulean
		if("pyrite")
			return /obj/item/slime_extract/pyrite
		//Tier 5
		if("light pink")
			return /obj/item/slime_extract/lightpink
		if("oil")
			return /obj/item/slime_extract/oil
		if("adamantine")
			return /obj/item/slime_extract/adamantine
		if("black")
			return /obj/item/slime_extract/black
	return /obj/item/slime_extract/grey
