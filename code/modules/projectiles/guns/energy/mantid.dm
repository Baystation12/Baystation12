/obj/item/weapon/gun/energy/particle
	name = "particle lance"
	desc = "A long, thick-bodied energy rifle of some kind, clad in a curious indigo polymer and lit from within by Cherenkov radiation. The grip is clearly not designed for human hands."
	icon_state = "particle_rifle"
	item_state = "particle_rifle"
	slot_flags = SLOT_BACK
	force = 25 // Heavy as Hell.
	projectile_type = /obj/item/projectile/beam/particle
	max_shots = 30
	self_recharge = 1
	w_class = ITEM_SIZE_HUGE
	one_hand_penalty= 6
	multi_aim = 1
	burst_delay = 3
	burst = 3
	move_delay = 4
	accuracy = -1
	wielded_item_state = "particle_rifle-wielded"
	charge_meter = 0

	firemodes = list(
		list(mode_name="stun",   projectile_type = /obj/item/projectile/beam/stun),
		list(mode_name="shock",  projectile_type = /obj/item/projectile/beam/stun/shock),
		list(mode_name="lethal", projectile_type = /obj/item/projectile/beam/particle)
		)

/obj/item/weapon/gun/energy/particle/update_icon()
	. = ..()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	overlays = list(
		image(icon, "prmode-[istype(current_mode) ? current_mode.name : "lethal"]"),
		image(icon, "prcharge-[Floor(power_supply.percent()/20)]")
	)

/obj/item/weapon/gun/energy/particle/get_mob_overlay(var/mob/living/carbon/human/user, var/slot)
	if(istype(user) && (slot == slot_l_hand_str || slot == slot_r_hand_str))
		var/bodytype = user.species.get_bodytype(user)
		if(bodytype in list(SPECIES_MANTID_ALATE, SPECIES_MANTID_GYNE, SPECIES_NABBER))
			if(slot == slot_l_hand_str)
				if(bodytype == SPECIES_MANTID_ALATE)
					return overlay_image('icons/mob/onmob/mantid/lefthand_particle_rifle_alate.dmi',  item_state_slots[slot_l_hand_str], color, RESET_COLOR)
				else if(bodytype == SPECIES_MANTID_GYNE)
					return overlay_image('icons/mob/onmob/mantid/lefthand_particle_rifle_gyne.dmi',   item_state_slots[slot_l_hand_str], color, RESET_COLOR)
				else
					return overlay_image('icons/mob/onmob/nabber/lefthand_particle_rifle.dmi',        item_state_slots[slot_l_hand_str], color, RESET_COLOR)
			else
				if(bodytype == SPECIES_MANTID_ALATE)
					return overlay_image('icons/mob/onmob/mantid/righthand_particle_rifle_alate.dmi', item_state_slots[slot_r_hand_str], color, RESET_COLOR)
				else if(bodytype == SPECIES_MANTID_GYNE)
					return overlay_image('icons/mob/onmob/mantid/righthand_particle_rifle_gyne.dmi',  item_state_slots[slot_r_hand_str], color, RESET_COLOR)
				else
					return overlay_image('icons/mob/onmob/nabber/righthand_particle_rifle.dmi',       item_state_slots[slot_r_hand_str], color, RESET_COLOR)
	. = ..(user, slot)
