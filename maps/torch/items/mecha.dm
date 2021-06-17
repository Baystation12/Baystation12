
/mob/living/exosuit/premade/light/exploration
	name = "exploration mech"
	desc = "It looks a bit charred."

/mob/living/exosuit/premade/light/exploration/Initialize()
	if(!body)
		body = new /obj/item/mech_component/chassis/pod(src)
		body.color = COLOR_GUNMETAL
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/tracks(src)
		legs.color = COLOR_GUNMETAL
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/powerloader(src)
		arms.color = COLOR_PURPLE

	. = ..()

	//Damage it
	var/list/parts = list(arms,legs,head,body)
	var/obj/item/mech_component/damaged = pick(parts)
	damaged.take_burn_damage((damaged.max_damage / 4 ) * MECH_COMPONENT_DAMAGE_DAMAGED)
	if(prob(33))
		parts -= damaged
		damaged = pick(parts)
		damaged.take_burn_damage((damaged.max_damage / 4 ) * MECH_COMPONENT_DAMAGE_DAMAGED)

/mob/living/exosuit/premade/light/exploration/spawn_mech_equipment()
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_HEAD)
	install_system(new /obj/item/mech_equipment/clamp(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/taser/plasma(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/ionjets(src), HARDPOINT_BACK)
	