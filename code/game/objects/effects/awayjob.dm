/obj/effect/awayjob
	anchored = 1
	desc = "Clicking on this will turn you into a controllable human"
	name = "away job"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	invisibility = INVISIBILITY_OBSERVER
	unacidable = 1
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	var/inuse = FALSE

/obj/effect/awayjob/Initialize()
	. = ..()
	GLOB.awayjobs.Add(src)


/obj/effect/awayjob/attack_ghost(var/mob/observer/ghost/user)
	if(inuse)
		to_chat(user, "<span class='notice'> Another observer is currently using this.</span>")
		return
	inuse = TRUE
	var/response = alert(user, "Are you sure you wish to become [src]? Contact with other players is not guaranteed", "Take control [src]", "Yes", "No")
	if(response == "Yes")
		var/mob/living/carbon/human/G = new(src.loc)
		G.ckey = user.ckey
		prepare(G)
		qdel(src)
	else
		inuse = FALSE
	return

// Up to mappers to decide how to overload this function with their own stuff.
/obj/effect/awayjob/proc/prepare(var/mob/living/carbon/human/H)
	var/list/valid_species = list(SPECIES_UNATHI,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_HUMAN,SPECIES_VOX)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/silenced(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/syndicate(H), slot_wear_mask)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/box/c45(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/weapon/rig/merc(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse_rifle(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(H), slot_l_hand)
	H.change_appearance(APPEARANCE_ALL, H.loc, H, valid_species, state = GLOB.z_state)
	to_chat(H, "<b> You are playing an off-station role. Use your surroundings to your advantage, and create good roleplay. REMEMBER: Server rules still apply.")

