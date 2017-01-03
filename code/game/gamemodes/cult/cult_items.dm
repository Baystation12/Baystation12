/obj/item/weapon/melee/cultblade
	name = "cult blade"
	desc = "An arcane weapon wielded by the followers of Nar-Sie."
	icon_state = "cultblade"
	item_state = "cultblade"
	edge = 1
	sharp = 1
	w_class = ITEM_SIZE_LARGE
	force = 30
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/weapon/melee/cultblade/cultify()
	return

/obj/item/weapon/melee/cultblade/attack(mob/living/M, mob/living/user, var/target_zone)
	if(iscultist(user))
		return ..()

	var/zone = (user.hand ? BP_L_ARM : BP_R_ARM)

	var/obj/item/organ/external/affecting = null
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		affecting = H.get_organ(zone)

	if(affecting)
		to_chat(user, "<span class='danger'>An unexplicable force rips through your [affecting.name], tearing the sword from your grasp!</span>")
	else
		to_chat(user, "<span class='danger'>An unexplicable force rips through you, tearing the sword from your grasp!</span>")

	//random amount of damage between half of the blade's force and the full force of the blade.
	user.apply_damage(rand(force/2, force), BRUTE, zone, 0, (DAM_SHARP|DAM_EDGE))
	user.Weaken(5)

	user.drop_from_inventory(src)
	throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1,3), throw_speed)

	var/spooky = pick('sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg', 'sound/hallucinations/wail.ogg')
	playsound(loc, spooky, 50, 1)

	return 1

/obj/item/weapon/melee/cultblade/pickup(mob/living/user as mob)
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>An overwhelming feeling of dread comes over you as you pick up the cultist's sword. It would be wise to be rid of this blade quickly.</span>")
		user.make_dizzy(120)


/obj/item/clothing/head/culthood
	name = "cult hood"
	icon_state = "culthood"
	desc = "A hood worn by the followers of Nar-Sie."
	flags_inv = HIDEFACE
	body_parts_covered = HEAD
	armor = list(melee = 30, bullet = 10, laser = 5,energy = 5, bomb = 0, bio = 0, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/culthood/cultify()
	return

/obj/item/clothing/head/culthood/magus
	name = "magus helm"
	icon_state = "magus"
	desc = "A helm worn by the followers of Nar-Sie."
	flags_inv = HIDEFACE | BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/culthood/alt
	icon_state = "cult_hoodalt"

/obj/item/clothing/suit/cultrobes
	name = "cult robes"
	desc = "A set of armored robes worn by the followers of Nar-Sie."
	icon_state = "cultrobes"
	item_state = "cultrobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/book/tome,/obj/item/weapon/melee/cultblade)
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 10, rad = 0)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0

/obj/item/clothing/suit/cultrobes/cultify()
	return

/obj/item/clothing/suit/cultrobes/alt
	icon_state = "cultrobesalt"
	item_state = "cultrobesalt"

/obj/item/clothing/suit/cultrobes/magusred
	name = "magus robes"
	desc = "A set of armored robes worn by the followers of Nar-Sie."
	icon_state = "magusred"
	item_state = "magusred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/head/helmet/space/cult
	name = "cult helmet"
	desc = "A space worthy helmet used by the followers of Nar-Sie."
	icon_state = "cult_helmet"
	armor = list(melee = 60, bullet = 50, laser = 50,energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0

/obj/item/clothing/head/helmet/space/cult/cultify()
	return

/obj/item/clothing/suit/space/cult
	name = "cult armour"
	icon_state = "cult_armour"
	desc = "A bulky suit of armour, bristling with spikes. It looks space proof."
	allowed = list(/obj/item/weapon/book/tome,/obj/item/weapon/melee/cultblade,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit)
	armor = list(melee = 60, bullet = 50, laser = 50,energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS

/obj/item/clothing/suit/space/cult/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/space/cult/cultify()
	return
