/datum/technomancer/spell/instability_tap
	name = "Instability Tap"
	desc = "Creates a large sum of energy, at the cost of a very large amount of instability afflicting you."
	enhancement_desc = "50% more energy gained, 20% less instability gained."
	cost = 100
	obj_path = /obj/item/weapon/spell/instability_tap
	ability_icon_state = "tech_instabilitytap"
	category = UTILITY_SPELLS

/obj/item/weapon/spell/instability_tap
	name = "instability tap"
	desc = "Short term gain for long term consequences never end bad, right?"
	icon_state = "generic"
	cast_methods = CAST_USE
	aspect = ASPECT_UNSTABLE

/obj/item/weapon/spell/instability_tap/New()
	..()
	set_light(3, 2, l_color = "#FA58F4")

/obj/item/weapon/spell/instability_tap/on_use_cast(mob/user)
	if(check_for_scepter())
		core.give_energy(7500)
		adjust_instability(40)
	else
		core.give_energy(5000)
		adjust_instability(50)
	qdel(src)