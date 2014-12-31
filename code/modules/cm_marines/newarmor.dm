/obj/item/clothing/under/marine2
	name = "marine jumpsuit"
	desc = "Soft as silk. Light as feather. Protective as Kevlar."
	armor = list(melee = 20, bullet = 20, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	flags = FPRINT | TABLEPASS
	siemens_coefficient = 0.9

	icon = 'icons/Marine/marine_armor.dmi'
	icon_state = "jumpsuit1_s"
	item_state = "jumpsuit1"
	item_color = "jumpsuit1"
	var/sleeves = 1
	icon_override = 'icons/Marine/marine_armor.dmi'


#define ALPHA		1
#define BRAVO		2
#define CHARLIE		3
#define DELTA		4
#define NONE 		5

var/list/armormarkings = list()
var/list/armormarkings_sql = list()
var/list/helmetmarkings = list()
var/list/helmetmarkings_sql = list()
var/list/squad_colors = list(rgb(255,0,0), rgb(255,255,0), rgb(160,32,240), rgb(0,0,255))


/proc/initialize_marine_armor()
	var/i
	for(i=1, i<5, i++)
		var/image/armor
		var/image/helmet
		armor = image('icons/Marine/marine_armor.dmi',icon_state = "std-armor")
		armor.color = squad_colors[i]
		armormarkings += armor
		armor = image('icons/Marine/marine_armor.dmi',icon_state = "sql-armor")
		armor.color = squad_colors[i]
		armormarkings_sql += armor

		helmet = image('icons/Marine/marine_armor.dmi',icon_state = "std-helmet")
		helmet.color = squad_colors[i]
		helmetmarkings += helmet
		helmet = image('icons/Marine/marine_armor.dmi',icon_state = "sql-helmet")
		helmet.color = squad_colors[i]
		helmetmarkings_sql += helmet

/obj/item/clothing/head/helmet/marine2
	icon = 'icons/Marine/marine_armor.dmi'
	icon_state = "helmet"
	item_state = "helmet"
	icon_override = 'icons/Marine/marine_armor.dmi'
	armor = list(melee = 50, bullet = 80, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	health = 5
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	var/mob/living/carbon/human/wornby
	var/squad = 0
	var/rank = 0
	var/image/markingoverlay

	proc/get_squad(var/obj/item/weapon/card/id/card)
		rank = 0
		squad = 0
		if(findtext(card.assignment, "Leader") != 0)
			rank = 1
		if(findtext(card.assignment, "Alpha") != 0)
			squad = 1
		if(findtext(card.assignment, "Bravo") != 0)
			squad = 2
		if(findtext(card.assignment, "Charlie") != 0)
			squad = 3
		if(findtext(card.assignment, "Delta") != 0)
			squad = 4

		return

	proc/update_helmet()
		spawn while(1)
			if(istype(wornby) && src.loc == wornby)
				var/obj/item/weapon/card/id/card = wornby.wear_id
				var/currsquad = squad
				var/currrank = rank
				if(istype(card))
					get_squad(card)
					if(currsquad != squad || currrank != rank)
						update_icon()
			sleep(50)

	New(loc)
		..(loc)
		update_helmet()

	equipped(var/mob/living/carbon/human/mob, slot)
		if(slot == slot_head)
			wornby = mob
			if(istype(markingoverlay))
				mob.overlays_standing += markingoverlay
		else
			if(istype(markingoverlay) && markingoverlay in mob.overlays_standing)
				mob.overlays_standing.Remove(markingoverlay)

	dropped(var/mob/living/carbon/human/mob)
		if(istype(markingoverlay) && markingoverlay in mob.overlays_standing)
			mob.overlays_standing.Remove(markingoverlay)

	update_icon()
		overlays = list() //resets list
		underlays = list()

		if(istype(markingoverlay) && markingoverlay in wornby.overlays_standing)
			wornby.overlays_standing.Remove(markingoverlay)

		if(squad > 0)
			if(rank)
				markingoverlay = helmetmarkings_sql[squad]
				overlays += markingoverlay
				wornby.overlays_standing += markingoverlay
			else
				markingoverlay = helmetmarkings[squad]
				overlays += markingoverlay
				wornby.overlays_standing += markingoverlay
		wornby.update_icons()


/obj/item/clothing/suit/storage/marine2
	icon = 'icons/Marine/marine_armor.dmi'
	icon_state = "1"
	item_state = "1"
	icon_override = 'icons/Marine/marine_armor.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	name = "marine armor"
	desc = "A standard issue marine combat vest designed to protect them from their worst enemies: themselves."
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 80, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	allowed = list(/obj/item/weapon/gun/, /obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton, /obj/item/weapon/melee/stunprod, /obj/item/weapon/handcuffs, /obj/item/weapon/restraints, /obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/weapon/grenade, /obj/item/weapon/combat_knife)
	var/mob/living/carbon/human/wornby
	var/squad = 0
	var/rank = 0
	var/image/markingoverlay

	proc/get_squad(var/obj/item/weapon/card/id/card)
		rank = 0
		squad = 0
		if(findtext(card.assignment, "Leader") != 0)
			rank = 1
		if(findtext(card.assignment, "Alpha") != 0)
			squad = 1
		if(findtext(card.assignment, "Bravo") != 0)
			squad = 2
		if(findtext(card.assignment, "Charlie") != 0)
			squad = 3
		if(findtext(card.assignment, "Delta") != 0)
			squad = 4

		return

	proc/update_armor()
		spawn while(1)
			if(istype(wornby) && src.loc == wornby && wornby.wear_suit == src)
				var/obj/item/weapon/card/id/card = wornby.wear_id
				var/currsquad = squad
				var/currrank = rank
				if(istype(card))
					get_squad(card)
					if(currsquad != squad || currrank != rank)
						update_icon()
			sleep(50)

	New(loc)
		..(loc)
		update_armor()
		icon_state = "[rand(1,6)]"
		item_state = icon_state

	equipped(var/mob/living/carbon/human/mob, slot)
		if(slot == slot_wear_suit)
			wornby = mob
			if(istype(markingoverlay))
				mob.overlays_standing += markingoverlay
		else
			if(istype(markingoverlay) && markingoverlay in mob.overlays_standing)
				mob.overlays_standing.Remove(markingoverlay)

	dropped(var/mob/living/carbon/human/mob)
		if(istype(markingoverlay) && markingoverlay in mob.overlays_standing)
			mob.overlays_standing.Remove(markingoverlay)

	update_icon()
		overlays = list() //resets list
		underlays = list()

		if(istype(markingoverlay) && markingoverlay in wornby.overlays_standing)
			wornby.overlays_standing.Remove(markingoverlay)

		if(squad > 0)
			if(rank)
				markingoverlay = armormarkings_sql[squad]
				overlays += markingoverlay
				wornby.overlays_standing += markingoverlay
			else
				markingoverlay = armormarkings[squad]
				overlays += markingoverlay
				wornby.overlays_standing += markingoverlay
		wornby.update_icons()