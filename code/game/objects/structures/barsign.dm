
/obj/structure/sign/double/barsign
	name = "bar sign"
	desc = "A bar sign with no writing on it"
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	anchored = 1
	req_access = list(access_bar)
	var/no_change = 0
	var/sign = null
	var/datum/barsign/current_sign = null
	var/broken = 0
	var/emagged = 0
	var/panel_open = 0

/obj/structure/sign/double/barsign/New()
	..()
	if(sign && istype(sign, /datum/barsign))
		set_sign(new sign)
	else
		set_sign(pick(barsigns))

/obj/structure/sign/double/barsign/proc/set_sign(datum/barsign/newsign)
	if(!istype(newsign))
		return
	current_sign = newsign
	icon_state = newsign.icon_state
	name = newsign.name
	if(newsign.desc)
		desc = newsign.desc
	else
		desc = "It displays \"[name]\"."

/obj/structure/sign/double/barsign/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/structure/sign/double/barsign/attack_hand(mob/user)
	if(no_change)	return
	if(!src.allowed(user))
		user << "<span class='info'>[translation(src, "access_denied")]</span>"
		return
	if(broken)
		user << "<span class ='danger'>[translation(src, "broken")]</span>"
		return
	pick_sign()

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(no_change)	return
	if(!allowed(user))
		user << "<span class='info'>[translation(src, "access_denied")]</span>"
		return

	if(istype(I, /obj/item/weapon/screwdriver))
		if(!panel_open)
			user << "<span class='notice'>[translation(src, "open_panel")]</span>"
			set_sign(new /datum/barsign/signoff)
			panel_open = 1
		else
			user << "<span class='notice'>[translation(src, "close_panel")]</span>"
			if(!broken && !emagged)
				if(no_change && sign && istype(sign, /datum/barsign))
					set_sign(new sign)
				else
					set_sign(pick(barsigns))
			else if(emagged)
				set_sign(new /datum/barsign/syndibarsign)
			else
				set_sign(new /datum/barsign/empbarsign)
			panel_open = 0

	else if(istype(I, /obj/item/stack/cable_coil) && panel_open)
		var/obj/item/stack/cable_coil/C = I
		if(emagged) //Emagged, not broken by EMP
			user << "<span class='warning'>[translation(src, "emagged")]</span>"
			return
		else if(!broken)
			user << "<span class='warning'>[translation(src, "normal")]</span>"
			return

		if(C.use(2))
			user << "<span class='notice'>[translation(src, "replace_wire")]</span>"
			broken = 0
		else
			user << "<span class='warning'>[translation(src, "more_cable")]</span>"
	else if(istype(I, /obj/item/weapon/card/emag))
		if(broken || emagged)
			user << "<span class='warning'>[translation(src, "fail_emag")]</span>"
			return
		user << "<span class='notice'>[translation(src, "emag")]</span>"
		sleep(100) //10 seconds
		set_sign(new /datum/barsign/syndibarsign)
		emagged = 1
		req_access = list(access_syndicate)

/obj/structure/sign/double/barsign/emp_act(severity)
	if(no_change)	return
	set_sign(new /datum/barsign/empbarsign)
	broken = 1

/obj/structure/sign/double/barsign/proc/pick_sign()
	var/picked_name = input("[translation(src,"pick_desc")]", "[translation(src,"pick_name")]") as null|anything in translation(src,"barsigns_list")
	if(!picked_name)
		return
	picked_name = translation(src,"barsigns_return",picked_name)
	set_sign(picked_name)

/datum/barsign
	var/name = "name"
	var/icon_state = "icon"
	var/desc = "desc"
	var/hidden = 0

/datum/barsign/signoff
	name = "Bar Sign"
	desc = "This sign doesn't seem to be on."
	icon_state = "empty"
	hidden = 1

/datum/barsign/empbarsign
	name = "Haywire Barsign"
	desc = "Something has gone very wrong."
	icon_state = "emp"
	hidden = 1

/datum/barsign/adminbus
	name = "The Adminbus"
	desc = "An establishment visited mainly by space-judges. It isn't bombed nearly as much as court hearings."
	icon_state = "adminbus"

/obj/structure/sign/double/barsign/adminbus
	icon_state = "adminbus"
	sign = /datum/barsign/adminbus
	no_change = 1

/datum/barsign/alenath
	name = "The Ale' Nath"
	desc = "All right, buddy. I think you've had EI NATH. Time to get a cab."
	icon_state = "alenath"

/datum/barsign/alohasnackbar
	name = "The Aloha Snackbar"
	desc = "A tasteful, inoffensive tiki bar sign."
	icon_state = "alohasnackbar"
	hidden = 1

/obj/structure/sign/double/barsign/alohasnackbar
	icon_state = "alohasnackbar"
	sign = /datum/barsign/alohasnackbar
	no_change = 1

/datum/barsign/armokbar
	name = "Armok's Bar N Grill"
	desc = null
	icon_state = "armokbar"

/datum/barsign/bark
	name = "The Bark"
	desc = "Ian's bar of choice."
	icon_state = "bark"

/datum/barsign/bark_neon
	name = "The Neon Bark"
	desc = "Ian's bar of choice."
	icon_state = "bark_neon"

/datum/barsign/barsik
	name = "The Barsik"
	desc = "Malyar's bar of choice."
	icon_state = "barsik"

/datum/barsign/birdcage
	name = "The Bird Cage"
	desc = "Caw."
	icon_state = "birdcage"

/datum/barsign/brokendrum
	name = "The Broken Drum"
	desc = null
	icon_state = "brokendrum"

/datum/barsign/carpecarp
	name = "Carpe Carp"
	desc = null
	icon_state = "carpecarp"

/datum/barsign/casino
	name = "Casino"
	desc = null
	icon_state = "casino"
	hidden = 1

/obj/structure/sign/double/barsign/casino
	icon_state = "casino"
	sign = /datum/barsign/casino
	no_change = 1

/datum/barsign/cavern
	name = "The Cavern"
	desc = null
	icon_state = "cavern"

/datum/barsign/cavern_neon
	name = "The Neon Cavern"
	desc = "Fine drinks while listening to some fine tunes."
	icon_state = "cavern_neon"

/datum/barsign/cindikate
	name = "Cindi Kate's"
	desc = null
	icon_state = "cindikate"

/datum/barsign/clownshead
	name = "The Clown's Head"
	desc = null
	icon_state = "clownshead"

/datum/barsign/coderbus
	name = "The Coderbus"
	desc = "A very controversial bar known for its wide variety of constantly-changing drinks."
	icon_state = "coderbus"

/datum/barsign/combocafe
	name = "The Combo Cafe"
	desc = "Renowned system-wide for their utterly uncreative drink combinations."
	icon_state = "combocafe"

/datum/barsign/damnwall
	name = "The Damn Wall"
	desc = null
	icon_state = "damnwall"

/datum/barsign/drunkcarp
	name = "The Drunk Carp"
	desc = "Don't drink and swim."
	icon_state = "drunkcarp"

/datum/barsign/drunkcarp_neon
	name = "The Neon Drunk Carp"
	desc = "Don't drink and swim."
	icon_state = "drunkcarp_neon"

/datum/barsign/emergencyrumparty
	name = "The Emergency Rum Party"
	desc = "Recently relicensed after a long closure."
	icon_state = "emergencyrumparty"
	hidden = 1

/obj/structure/sign/double/barsign/emergencyrumparty
	icon_state = "emergencyrumparty"
	sign = /datum/barsign/emergencyrumparty
	no_change = 1

/datum/barsign/greytide
	name = "The Grey Tide"
	desc = "Abandon your toolboxing ways and enjoy a lazy beer!"
	icon_state = "greytide"

/datum/barsign/greytide_neon
	name = "The Neon Grey Tide"
	desc = "Abandon your toolboxing ways and enjoy a lazy beer!"
	icon_state = "greytide_neon"

/datum/barsign/harmbaton
	name = "The Harmbaton"
	desc = "A great dining experience for both security members and assistants."
	icon_state = "harmbaton"

/datum/barsign/harmbaton_neon
	name = "The Neon Harmbaton"
	desc = "A great dining experience for both security members and assistants."
	icon_state = "harmbaton_neon"

/datum/barsign/harmedbaton
	name = "The Harmedbaton"
	desc = "A great dining experience for both security members and assistants."
	icon_state = "harmedbaton"

/datum/barsign/honkednloaded
	name = "Honked 'n' Loaded"
	desc = "Honk."
	icon_state = "honkednloaded"

/datum/barsign/limbo
	name = "The Limbo"
	desc = null
	icon_state = "limbo"

/datum/barsign/magmasea
	name = "The Magma Sea"
	desc = null
	icon_state = "magmasea"

/datum/barsign/maltesefalcon
	name = "Maltese Falcon"
	desc = "Play it again, Sam."
	icon_state = "maltesefalcon"

/datum/barsign/meadbay
	name = "Meadbay"
	desc = null
	icon_state = "meadbay"

/datum/barsign/narsiebistro
	name = "Nar-Sie Bistro"
	desc = "It shows a picture of a large black and red being. Spooky!"
	icon_state = "narsiebistro"
	hidden = 1

/obj/structure/sign/double/barsign/narsiebistro
	icon_state = "narsiebistro"
	sign = /datum/barsign/narsiebistro
	no_change = 1

/datum/barsign/nest
	name = "The Nest"
	desc = "A good place to retire for a drink after a long night of crime fighting."
	icon_state = "nest"

/datum/barsign/net
	name = "The Net"
	desc = "You just seem to get caught up in it for hours."
	icon_state = "net"

/datum/barsign/officerbeersky
	name = "Officer Beersky's"
	desc = "Man eat a dong, these drinks are great."
	icon_state = "officerbeersky"

/datum/barsign/officerbeersky_neon
	name = "Neon Officer Beersky's"
	desc = "Man eat a dong, these drinks are great."
	icon_state = "officerbeersky_neon"

/datum/barsign/oldcockinn
	name = "The Old Cock Inn"
	desc = "Something about this sign fills you with despair."
	icon_state = "oldcockinn"
	hidden = 1

/obj/structure/sign/double/barsign/oldcockinn
	icon_state = "oldcockinn"
	sign = /datum/barsign/oldcockinn
	no_change = 1

/datum/barsign/orchard
	name = "The Orchard"
	desc = null
	icon_state = "orchard"

/datum/barsign/outerspess
	name = "The Outer Spess"
	desc = "This bar isn't actually located in outer space."
	icon_state = "outerspess"

/datum/barsign/pinkflamingo
	name = "The Pink Flamingo"
	desc = null
	icon_state = "pinkflamingo"

/datum/barsign/redshirt
	name = "The Redshirt"
	desc = null
	icon_state = "redshirt"

/datum/barsign/robustacafe
	name = "The Robusta Cafe"
	desc = "Holder of the 'Most Lethal Barfights' record 5 years uncontested."
	icon_state = "robustacafe"

/datum/barsign/robustroadhouse
	name = "Robust Roadhouse"
	desc = null
	icon_state = "robustroadhouse"

/datum/barsign/rustyaxe
	name = "The Rusty Axe"
	desc = null
	icon_state = "rustyaxe"

/datum/barsign/saucyclown
	name = "The Saucy Clown"
	desc = null
	icon_state = "saucyclown"

/datum/barsign/scotchservinwill
	name = "Scotch Servin Willy's"
	desc = "Willy sure moved up in the world from clown to bartender."
	icon_state = "scotchservinwill"

/datum/barsign/scotchservinwill_neon
	name = "Neon Scotch Servin Willy's"
	desc = "Willy sure moved up in the world from clown to bartender."
	icon_state = "scotchservinwill_neon"

/datum/barsign/shaken
	name = "The Shaken"
	desc = "This establishment does not serve stirred drinks."
	icon_state = "shaken"

/datum/barsign/singulo
	name = "The Singulo"
	desc = "Where people go that'd rather not be called by their name."
	icon_state = "singulo"

/datum/barsign/slipperyshots
	name = "Slippery Shots"
	desc = "Slippery slope to drunkeness with our shots!"
	icon_state = "slipperyshots"

/datum/barsign/syndibarsign
	name = "Syndi Cat Takeover"
	desc = "Syndicate or die."
	icon_state = "syndibarsign"
	hidden = 1

/obj/structure/sign/double/barsign/syndibarsign
	icon_state = "syndibarsign"
	sign = /datum/barsign/syndibarsign
	no_change = 1

/datum/barsign/vladssaladbar
	name = "Vlad's Salad Bar"
	desc = "Under new management. Vlad was always a bit too trigger happy with that shotgun."
	icon_state = "vladssaladbar"

/datum/barsign/wiggle
	name = "The Wiggle Room"
	desc = "MoMMIs got moves."
	icon_state = "wiggle"

/datum/barsign/wretchedhive
	name = "The Wretched Hive"
	desc = "Legally obligated to instruct you to check your drinks for acid before consumption."
	icon_state = "wretchedhive"

/datum/barsign/whiskeyimplant
	name = "Whiskey Implant"
	desc = null
	icon_state = "whiskeyimplant"