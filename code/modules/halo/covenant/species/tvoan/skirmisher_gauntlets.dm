#define SKIRMISHER_CLOTHING_PATH 'code/modules/halo/covenant/species/tvoan/skirm_clothing.dmi'

/obj/item/clothing/gloves/skirmisher_shield_gauntlets
	name = "T\'Vaoan Murmillo shield gauntlets"
	desc = "Point defence gauntlets with twin energy shields for deflecting fire."
	icon = SKIRMISHER_CLOTHING_PATH
	icon_override = SKIRMISHER_CLOTHING_PATH
	icon_state = "murmilloglove"
	item_state = "murmilloshield"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	body_parts_covered = ARMS | HANDS
	armor = list(melee = 30, bullet = 40, laser = 30, energy = 30, bomb = 25, bio = 0, rad = 0)
	species_restricted = list("Tvaoan Kig-Yar")
	var/datum/armourspecials/shields/tvoan/my_shield
	var/shieldstrength = 25
	var/totalshields = 25
	var/intercept_chance = 100	//A 100% chance to block only a single bullet.
	matter = list("nanolaminate" = 1)

/obj/effect/overlay/shields/tvoan
	icon = SKIRMISHER_CLOTHING_PATH

/datum/armourspecials/shields/tvoan
	shield_recharge_delay = 5 SECONDS
	shieldoverlay = new /obj/effect/overlay/shields/tvoan

/obj/item/clothing/gloves/skirmisher_shield_gauntlets/New()
	. = ..()

	if(totalshields)
		my_shield = new(src)
		my_shield.intercept_chance = src.intercept_chance

/obj/item/clothing/gloves/skirmisher_shield_gauntlets/equipped(var/mob/user, var/slot)
	if(my_shield && slot == slot_gloves)
		my_shield.user = user
	. = ..()

/obj/item/clothing/gloves/skirmisher_shield_gauntlets/get_mob_overlay(mob/user_mob, slot)
	var/image/retval = ..()
	if(slot == "slot_gloves" && my_shield)
		my_shield.update_mob_overlay(retval)
	return retval

/obj/item/clothing/gloves/skirmisher_shield_gauntlets/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(my_shield)
		return my_shield.handle_shield(user, damage, damage_source, attacker, def_zone, attack_text)
	return 0



//variants

/obj/item/clothing/gloves/skirmisher_shield_gauntlets/commando
	name = "T\'Vaoan Commando shield gauntlets"
	item_state = "commandoshield"
	icon_state = "commandoglove"
	shieldstrength = 0
	totalshields = 0

/obj/item/clothing/gloves/skirmisher_shield_gauntlets/champion
	name = "T\'Vaoan Champion shield gauntlets"
	item_state = "championshield"
	icon_state = "championglove"
	shieldstrength = 60
	totalshields = 60
