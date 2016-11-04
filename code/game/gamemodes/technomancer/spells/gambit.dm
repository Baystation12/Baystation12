/datum/technomancer/spell/gambit
	name = "Gambit"
	desc = "This function causes you to receive a random function, including those which you haven't purchased."
	ability_icon_state = "tech_gambit"
	cost = 50
	obj_path = /obj/item/weapon/spell/gambit
	category = UTILITY_SPELLS

/var/global/list/all_technomancer_gambit_spells = typesof(/obj/item/weapon/spell) - list(
	/obj/item/weapon/spell,
	/obj/item/weapon/spell/gambit,
	/obj/item/weapon/spell/projectile,
	/obj/item/weapon/spell/aura,
	/obj/item/weapon/spell/insert,
	/obj/item/weapon/spell/spawner,
	/obj/item/weapon/spell/summon)

/obj/item/weapon/spell/gambit
	name = "gambit"
	desc = "Do you feel lucky?"
	icon_state = "gambit"
	cast_methods = CAST_USE
	aspect = ASPECT_UNSTABLE

/obj/item/weapon/spell/gambit/on_use_cast(mob/living/carbon/human/user)
	if(pay_energy(200))
		adjust_instability(3)
		var/obj/item/weapon/spell/random_spell = pick(all_technomancer_gambit_spells)
		if(random_spell)
			user.drop_from_inventory(src, null)
			user.place_spell_in_hand(random_spell)
		qdel(src)
