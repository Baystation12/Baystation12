/datum/technomancer/spell/condensation
	name = "Condensation"
	desc = "This causes rapid formation of liquid at the target, causing floors to become wet, entities to be soaked, and fires \
	to be extinguished.  You can also fill contains with water if they are targeted directly."
	ability_icon_state = "tech_condensation"
	cost = 50
	obj_path = /obj/item/weapon/spell/condensation
	category = UTILITY_SPELLS

/obj/item/weapon/spell/condensation
	name = "condensation"
	desc = "Stronger than it appears."
	icon_state = "condensation"
	cast_methods = CAST_RANGED
	aspect = ASPECT_AIR
	cooldown = 2 SECONDS

/obj/item/weapon/spell/condensation/on_ranged_cast(atom/hit_atom, mob/user)
	if(pay_energy(200))
		if(istype(hit_atom, /turf/simulated))
			var/turf/simulated/T = hit_atom

			for(var/direction in alldirs + null) // null is for the center tile.
				spawn(1)
					var/turf/desired_turf = get_step(T,direction)
					if(desired_turf) // This shouldn't fail but...
						var/obj/effect/effect/water/W = new(get_turf(T))
						W.create_reagents(60)
						W.reagents.add_reagent(id = "water", amount = 60, data = null, safety = 0)
						W.set_color()
						W.set_up(desired_turf)
						flick(initial(icon_state),W) // Otherwise pooling causes the animation to stay stuck at the end.
		else if(hit_atom.reagents && !ismob(hit_atom))
			hit_atom.reagents.add_reagent(id = "water", amount = 60, data = null, safety = 0)
		adjust_instability(5)