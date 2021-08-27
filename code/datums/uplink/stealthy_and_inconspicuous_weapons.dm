/*************************************
* Stealthy and Inconspicuous Weapons *
*************************************/
/datum/uplink_item/item/stealthy_weapons
	category = /datum/uplink_category/stealthy_weapons

/datum/uplink_item/item/stealthy_weapons/soap
	name = "Subversive Soap"
	item_cost = 1
	path = /obj/item/soap

/datum/uplink_item/item/stealthy_weapons/cigarette_kit
	name = "Box of Tricky Cigarettes"
	desc = "A box with some 'special' packs in the following order: 2x Flashes, 2x Smokes, 1x MindBreaker Toxin, and 1x Tricordrazine. Try not to mix them up!"
	item_cost = 8
	path = /obj/item/storage/box/syndie_kit/cigarette

/datum/uplink_item/item/stealthy_weapons/concealed_cane
	name = "Concealed Cane Sword"
	desc = "A cane used by a true gentlemen, especially ones with sharp intentions."
	item_cost = 8
	path = /obj/item/cane/concealed

/datum/uplink_item/item/stealthy_weapons/random_toxin
	name = "Random Toxin Vial"
	desc = "Contains one of an assortment of nasty toxins, with a single syringe included. Don't worry, its labeled. "
	item_cost = 8
	path = /obj/item/storage/box/syndie_kit/toxin

/datum/uplink_item/item/stealthy_weapons/sleepy
	name = "Paralytic Pen"
	desc = "Looks and works like a pen, but prick someone with it, and 30 seconds later, they'll be on the ground mumbling."
	item_cost = 20
	path = /obj/item/pen/reagent/sleepy

/datum/uplink_item/item/stealthy_weapons/syringegun
	name = "Disguised Syringe Gun"
	desc = "A syringe gun disguised as an electronic cigarette with 4 darts included in the box. Chemicals not included!"
	item_cost = 10
	path = /obj/item/storage/box/syndie_kit/syringegun

/datum/uplink_item/item/stealthy_weapons/razor_hat
	name = "Razor-Brimmed Bowler Hat"
	desc = "This dapper hat hides several microrazors in its brim, and also provides some head protection. Land a trickshot for maximum damage."
	item_cost = 15
	path = /obj/item/clothing/head/bowlerhat/razor

/datum/uplink_item/item/stealthy_weapons/carp_plush
	name = "Dehydrated Space Carp"
	desc = "An innocuous-looking space carp plushie. Add water and step back for a nasty surprise!"
	item_cost = 10
	path = /obj/item/dehydrated_carp

/datum/uplink_item/item/stealthy_weapons/plush_bomb
	name = "Plushie Bomb"
	desc = "A cuddly plushie implanted with a voice-activated bomb. Set the trigger phrase and run for an explosive ending!"
	item_cost = 20
	path = /obj/item/plushbomb

/datum/uplink_item/item/stealthy_weapons/plush_bomb/get_goods(obj/item/device/uplink/U, loc)
	var/plushtype = pick(typesof(path))
	var/obj/item/I = new plushtype(loc)
	return I
