/obj/item/weapon/gun/energy/particle
	name = "particle lance"
	desc = "A long, thick-bodied energy rifle of some kind, clad in a curious indigo polymer and lit from within by Cherenkov radiation. The grip is clearly not designed for human hands."
	icon = 'icons/obj/guns/particle_rifle.dmi'
	icon_state = "particle_rifle"
	item_state = "particle_rifle"
	slot_flags = SLOT_BACK
	force = 25 // Heavy as Hell.
	projectile_type = /obj/item/projectile/beam/particle
	max_shots = 18
	self_recharge = 1
	w_class = ITEM_SIZE_HUGE
	one_hand_penalty = 6
	multi_aim = 1
	burst_delay = 3
	burst = 3
	move_delay = 4
	accuracy = -1
	wielded_item_state = "particle_rifle-wielded"
	charge_meter = 0
	has_safety = FALSE
	firemodes = list(
		list(mode_name="stun",   projectile_type = /obj/item/projectile/beam/stun),
		list(mode_name="shock",  projectile_type = /obj/item/projectile/beam/stun/shock),
		list(mode_name="lethal", projectile_type = /obj/item/projectile/beam/particle)
		)
	var/charge_state = "pr"

/obj/item/weapon/gun/energy/particle/small
	name = "particle projector"
	desc = "A smaller variant on the Ascent particle lance, usually carried by drones and alates."
	icon_state = "particle_rifle_small"
	force = 12
	max_shots = 9
	burst = 1
	move_delay = 2
	one_hand_penalty = 0
	charge_state = "prsmall"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_DENYPOCKET | SLOT_HOLSTER
	projectile_type = /obj/item/projectile/beam/particle/small
	firemodes = list(
		list(mode_name="stun",   projectile_type = /obj/item/projectile/beam/stun),
		list(mode_name="shock",  projectile_type = /obj/item/projectile/beam/stun/shock),
		list(mode_name="lethal", projectile_type = /obj/item/projectile/beam/particle/small)
		)


/obj/item/weapon/gun/energy/particle/on_update_icon()
	. = ..()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	overlays = list(
		image(icon, "[charge_state]mode-[istype(current_mode) ? current_mode.name : "lethal"]"),
		image(icon, "[charge_state]charge-[Floor(power_supply.percent()/20)]")
	)

/obj/item/weapon/gun/energy/particle/get_mob_overlay(var/mob/living/carbon/human/user, var/slot)
	if(istype(user) && (slot == slot_l_hand_str || slot == slot_r_hand_str))
		var/bodytype = user.species.get_bodytype(user)
		if(bodytype in list(SPECIES_MANTID_ALATE, SPECIES_MANTID_GYNE, SPECIES_NABBER))
			if(slot == slot_l_hand_str)
				if(bodytype == SPECIES_MANTID_ALATE)
					return overlay_image('icons/mob/species/mantid/onmob_lefthand_particle_rifle_alate.dmi',  item_state_slots[slot_l_hand_str], color, RESET_COLOR)
				else if(bodytype == SPECIES_MANTID_GYNE)
					return overlay_image('icons/mob/species/mantid/onmob_lefthand_particle_rifle_gyne.dmi',   item_state_slots[slot_l_hand_str], color, RESET_COLOR)
				else
					return overlay_image('icons/mob/species/nabber/onmob_lefthand_particle_rifle.dmi',  item_state_slots[slot_l_hand_str], color, RESET_COLOR)
			else if(slot == slot_r_hand_str)
				if(bodytype == SPECIES_MANTID_ALATE)
					return overlay_image('icons/mob/species/mantid/onmob_righthand_particle_rifle_alate.dmi', item_state_slots[slot_r_hand_str], color, RESET_COLOR)
				else if(bodytype == SPECIES_MANTID_GYNE)
					return overlay_image('icons/mob/species/mantid/onmob_righthand_particle_rifle_gyne.dmi',  item_state_slots[slot_r_hand_str], color, RESET_COLOR)
				else
					return overlay_image('icons/mob/species/nabber/onmob_righthand_particle_rifle.dmi', item_state_slots[slot_r_hand_str], color, RESET_COLOR)
	. = ..(user, slot)

/obj/item/weapon/gun/magnetic/railgun/flechette/ascent
	name = "mantid flechette rifle"
	desc = "A viciously pronged rifle-like weapon."
	has_safety = FALSE
	one_hand_penalty = 6
	var/charge_per_shot = 10

/obj/item/weapon/gun/magnetic/railgun/flechette/ascent/get_cell()
	if(isrobot(loc) || istype(loc, /obj/item/rig_module))
		return loc.get_cell()

/obj/item/weapon/gun/magnetic/railgun/flechette/ascent/show_ammo(var/mob/user)
	var/obj/item/weapon/cell/cell = get_cell()
	to_chat(user, "<span class='notice'>There are [cell ? Floor(cell.charge/charge_per_shot) : 0] shot\s remaining.</span>")

/obj/item/weapon/gun/magnetic/railgun/flechette/ascent/check_ammo()
	var/obj/item/weapon/cell/cell = get_cell()
	return cell && cell.charge >= charge_per_shot

/obj/item/weapon/gun/magnetic/railgun/flechette/ascent/use_ammo()
	var/obj/item/weapon/cell/cell = get_cell()
	if(cell) cell.use(charge_per_shot)