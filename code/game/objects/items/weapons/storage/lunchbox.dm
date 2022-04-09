/obj/item/storage/lunchbox
	max_storage_space = 8 //slightly smaller than a toolbox
	name = "rainbow lunchbox"
	icon_state = "lunchbox_rainbow"
	item_state = "toolbox_pink"
	desc = "A little lunchbox. This one is the colors of the rainbow!"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	var/filled = FALSE
	attack_verb = list("lunched")
	allow_slow_dump = TRUE

/obj/item/storage/lunchbox/New()
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

/obj/item/storage/lunchbox/filled
	filled = TRUE

/obj/item/storage/lunchbox/heart
	name = "heart lunchbox"
	icon_state = "lunchbox_lovelyhearts"
	item_state = "toolbox_pink"
	desc = "A little lunchbox. This one has cute little hearts on it!"

/obj/item/storage/lunchbox/heart/filled
	filled = TRUE

/obj/item/storage/lunchbox/cat
	name = "cat lunchbox"
	icon_state = "lunchbox_sciencecatshow"
	item_state = "toolbox_green"
	desc = "A little lunchbox. This one has a cute little science cat from a popular show on it!"

/obj/item/storage/lunchbox/cat/filled
	filled = TRUE

/obj/item/storage/lunchbox/nt
	name = "\improper NanoTrasen brand lunchbox"
	icon_state = "lunchbox_nanotrasen"
	item_state = "toolbox_blue"
	desc = "A little lunchbox. This one is branded with the NanoTrasen logo!"

/obj/item/storage/lunchbox/dais
	name = "\improper DAIS brand lunchbox"
	icon_state = "lunchbox_dais"
	item_state = "toolbox_blue"
	desc = "A little lunchbox. This one is branded with the Deimos Advanced Information Systems logo!"

/obj/item/storage/lunchbox/nt/filled
	filled = TRUE

/obj/item/storage/lunchbox/mars
	name = "\improper Mariner University lunchbox"
	icon_state = "lunchbox_marsuniversity"
	item_state = "toolbox_red"
	desc = "A little lunchbox. This one is branded with the Mariner university logo!"

/obj/item/storage/lunchbox/mars/filled
	filled = TRUE

/obj/item/storage/lunchbox/cti
	name = "\improper CTI lunchbox"
	icon_state = "lunchbox_cti"
	item_state = "toolbox_blue"
	desc = "A little lunchbox. This one is branded with the CTI logo!"

/obj/item/storage/lunchbox/cti/filled
	filled = TRUE

/obj/item/storage/lunchbox/nymph
	name = "\improper Diona nymph lunchbox"
	icon_state = "lunchbox_dionanymph"
	item_state = "toolbox_yellow"
	desc = "A little lunchbox. This one is an adorable Diona nymph on the side!"

/obj/item/storage/lunchbox/nymph/filled
	filled = TRUE

/obj/item/storage/lunchbox/syndicate
	name = "black and red lunchbox"
	icon_state = "lunchbox_syndie"
	item_state = "toolbox_syndi"
	desc = "A little lunchbox. This one is a sleek black and red, made of a durable steel!"

/obj/item/storage/lunchbox/syndicate/filled
	filled = TRUE

/obj/item/storage/lunchbox/TCC
	name = "\improper GCC lunchbox"
	icon_state = "lunchbox_tcc"
	item_state = "toolbox_syndi"
	desc = "A little lunchbox. This one is branded with the flag of the Gilgamesh Colonial Confederation!"

/obj/item/storage/lunchbox/syndicate/filled
	filled = TRUE

/obj/item/storage/lunchbox/picnic
	name = "picnic basket"
	icon_state = "picnic_basket"
	item_state = "picnic_basket"
	desc = "A small, old-fashioned picnic basket. Great for lunches in the garden."

/obj/item/storage/lunchbox/picnic/filled
	filled = TRUE
