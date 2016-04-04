/obj/item/weapon/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	flags = CONDUCT
	force = 5
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = 4
	max_w_class = 3
	max_storage_space = 14 //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")

/obj/item/weapon/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

/obj/item/weapon/storage/toolbox/emergency/New()
	..()
	new /obj/item/weapon/crowbar/red(src)
	new /obj/item/weapon/extinguisher/mini(src)
	if(prob(50))
		new /obj/item/device/flashlight(src)
	else
		new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/radio(src)

/obj/item/weapon/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

/obj/item/weapon/storage/toolbox/mechanical/New()
	..()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/weapon/wirecutters(src)

/obj/item/weapon/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"

/obj/item/weapon/storage/toolbox/electrical/New()
	..()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/device/t_scanner(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/stack/cable_coil/random(src,30)
	new /obj/item/stack/cable_coil/random(src,30)
	if(prob(5))
		new /obj/item/clothing/gloves/yellow(src)
	else
		new /obj/item/stack/cable_coil/random(src,30)

/obj/item/weapon/storage/toolbox/syndicate
	name = "black and red toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = list(TECH_COMBAT = 1, TECH_ILLEGAL = 1)
	force = 7.0

/obj/item/weapon/storage/toolbox/syndicate/New()
	..()
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/device/multitool(src)

/obj/item/weapon/storage/toolbox/lunchbox
	max_storage_space = 8 //slightly smaller than a toolbox
	name = "rainbow lunchbox"
	icon_state = "lunchbox_rainbow"
	item_state = "toolbox_pink"
	desc = "A little lunchbox. This one is the colors of the rainbow!"
	var/filled = FALSE
	attack_verb = list("lunched")

/obj/item/weapon/storage/toolbox/lunchbox/New()
	..()
	if(filled)
		var/list/lunches = lunchables_lunches()
		var/lunch = lunches[pick(lunches)]
		new lunch(src)

		var/list/snacks = lunchables_snacks()
		var/snack = snacks[pick(snacks)]
		new snack(src)

		var/list/drinks = lunchables_drinks()
		var/drink = drinks[pick(drinks)]
		new drink(src)

/obj/item/weapon/storage/toolbox/lunchbox/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/heart
	name = "heart lunchbox"
	icon_state = "lunchbox_lovelyhearts"
	item_state = "toolbox_pink"
	desc = "A little lunchbox. This one has cute little hearts on it!"

/obj/item/weapon/storage/toolbox/lunchbox/heart/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/cat
	name = "cat lunchbox"
	icon_state = "lunchbox_sciencecatshow"
	item_state = "toolbox_green"
	desc = "A little lunchbox. This one has a cute little science cat from a popular show on it!"

/obj/item/weapon/storage/toolbox/lunchbox/cat/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/nt
	name = "Nanotrasen brand lunchbox"
	icon_state = "lunchbox_nanotrasen"
	item_state = "toolbox_blue"
	desc = "A little lunchbox. This one is branded with the Nanotrasen logo!"

/obj/item/weapon/storage/toolbox/lunchbox/nt/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/mars
	name = "\improper Mars university lunchbox"
	icon_state = "lunchbox_marsuniversity"
	item_state = "toolbox_red"
	desc = "A little lunchbox. This one is branded with the Mars university logo!"

/obj/item/weapon/storage/toolbox/lunchbox/mars/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/cti
	name = "\improper CTI lunchbox"
	icon_state = "lunchbox_cti"
	item_state = "toolbox_blue"
	desc = "A little lunchbox. This one is branded with the CTI logo!"

/obj/item/weapon/storage/toolbox/lunchbox/cti/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/nymph
	name = "\improper Diona nymph lunchbox"
	icon_state = "lunchbox_dionanymph"
	item_state = "toolbox_yellow"
	desc = "A little lunchbox. This one is an adorable Diona nymph on the side!"

/obj/item/weapon/storage/toolbox/lunchbox/nymph/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/syndicate
	name = "black and red lunchbox"
	icon_state = "lunchbox_syndie"
	item_state = "toolbox_syndi"
	desc = "A little lunchbox. This one is a sleek black and red, made of a durable steel!"

/obj/item/weapon/storage/toolbox/lunchbox/syndicate/filled
	filled = TRUE
