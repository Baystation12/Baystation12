var/datum/antagonist/deathsquad/mercenary/commandos

/datum/antagonist/deathsquad/mercenary
	id = MODE_COMMANDO
	landmark_id = "Syndicate-Commando"
	role_text = "Syndicate Commando"
	role_text_plural = "Commandos"
	welcome_text = "You are in the employ of a criminal syndicate hostile to NanoTrasen."

/datum/antagonist/deathsquad/mercenary/New()
	..(1)
	commandos = src

/datum/antagonist/deathsquad/mercenary/equip(var/mob/living/carbon/human/player)

	player.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/silenced(player), slot_belt)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(player), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(player), slot_glasses)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/syndicate(player), slot_wear_mask)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/box(player), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/ammo_magazine/c45(player), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/weapon/rig/merc(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse_rifle(player), slot_r_hand)

	var/obj/item/weapon/card/id/id = create_id("Commando", player)
	id.access |= get_all_accesses()
	id.icon_state = "centcom"
	create_radio(SYND_FREQ, player)