/obj/structure/sign/double/barsign
	icon = 'tauceti/icons/obj/barsigns.dmi'
	icon_state = "empty"
	anchored = 1

	var/global/bar_sing_global = pick("lv426", "zocalo", "4theemprah", "ishimura", "tardis", "thecavern", "quarks", "tenforward", "thepranicngpony", "vault13", "solaris", "thehive", "cantina", "theouterspess", "milliways42", "thetimeofeve", "spaceasshole", "dwarffortress", "maltesefalcon", "meadbay", "thecavern","theorchard","whiskeyimplant","carpecarp","robustroadhouse","greytide","theredshirt")
	New()
		ChangeSign(bar_sing_global)
		return
	proc/ChangeSign(var/Text)
		src.icon_state = "[Text]"
		//on = 0
		//brightness_on = 4 //uncomment these when the lighting fixes get in
		return