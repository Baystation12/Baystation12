/mob/living/heavy_vehicle/premade
	name = "impossible mech"
	desc = "It seems to be saying 'please let me die'."

/mob/living/heavy_vehicle/premade/New()
	if(arms) arms.prebuild()
	if(legs) legs.prebuild()
	if(head) head.prebuild()
	if(body) body.prebuild()
	..()
	install_system(new /obj/item/mecha_equipment/light(src), HARDPOINT_HEAD)

/mob/living/heavy_vehicle/premade/random/New()
	if(!arms)
		var/armstype = pick(typesof(/obj/item/mech_component/manipulators)-/obj/item/mech_component/manipulators)
		arms = new armstype(src)
	if(!legs)
		var/legstype = pick(typesof(/obj/item/mech_component/propulsion)-/obj/item/mech_component/propulsion)
		legs = new legstype(src)
	if(!head)
		var/headtype = pick(typesof(/obj/item/mech_component/sensors)-/obj/item/mech_component/sensors)
		head = new headtype(src)
	if(!body)
		var/bodytype = pick(typesof(/obj/item/mech_component/chassis)-/obj/item/mech_component/chassis)
		body = new bodytype(src)
	..()
