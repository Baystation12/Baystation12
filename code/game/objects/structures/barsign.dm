/obj/structure/sign/double/barsign
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	anchored = 1
	var/cult = 0
	New()
		ChangeSign(pick("pinkflamingo", "magmasea", "limbo", "rustyaxe", "armokbar", "brokendrum", "meadbay", "thedamnwall", "thecavern", "cindikate", "theorchard", "thesaucyclown", "theclownshead", "whiskeyimplant", "carpecarp", "robustroadhouse", "greytide", "theredshirt","thebark","theharmbaton","theharmedbaton","thesingulo","thedrukcarp","thedrunkcarp", "scotch","officerbeersky","on"))
		return
	proc/ChangeSign(var/Text)
		src.icon_state = "[Text]"
		//on = 0
		//brightness_on = 4 //uncomment these when the lighting fixes get in
		return

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(cult)
		return

	if(istype(I, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/card = I
		if(access_bar in card.GetAccess())
			var/sign_type = input(user, "What would you like to change the barsign to?") as null|anything in list("Off", "Pink Flamingo", "Magma Sea", "Limbo", "Rusty Axe", "Armok Bar", "Broken Drum", "Mead Bay", "The Damn Wall", "The Cavern", "Cindi Kate", "The Orchard", "The Saucy Clown", "The Clowns Head", "Whiskey Implant", "Carpe Carp", "Robust Roadhouse", "Greytide", "The Redshirt", "The Bark", "The Harm Baton", "The Harmed Baton", "The Singulo", "The Druk Carp", "The Drunk Carp", "Scotch", "Officer Beersky", "On")
			if(sign_type == null)
				return
			else
				sign_type = replacetext(lowertext(sign_type), " ", "") // lowercase, strip spaces - along with choices for user options, avoids huge if-else-else
				src.ChangeSign(sign_type)
				user << "You change the barsign."
