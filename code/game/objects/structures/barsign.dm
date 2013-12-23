/obj/structure/sign/double/barsign
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	anchored = 1
	New()
		ChangeSign(pick("pinkflamingo", "magmasea", "limbo", "rustyaxe", "armokbar", "brokendrum", "meadbay", "thedamnwall", "thecavern", "cindikate", "theorchard", "thesaucyclown", "theclownshead","lv426", "zocalo", "4theemprah", "ishimura", "tardis", "quarks", "tenforward", "thepranicngpony", "vault13", "solaris", "thehive", "cantina", "theouterspess", "milliways42", "thetimeofeve", "spaceasshole", "dwarffortress"))
		return
	proc/ChangeSign(var/Text)
		src.icon_state = "[Text]"
		//on = 0
		//brightness_on = 4 //uncomment these when the lighting fixes get in
		return
