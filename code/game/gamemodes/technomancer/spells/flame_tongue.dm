/datum/technomancer/spell/flame_tongue
	name = "Flame Tongue"
	desc = "Using a miniturized flamethrower in your gloves, you can emit a flame strong enough to melt both your enemies and walls."
	cost = 50
	obj_path = /obj/item/weapon/spell/flame_tongue
	ability_icon_state = "tech_flametongue"
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/flame_tongue
	name = "flame tongue"
	icon_state = "flame_tongue"
	desc = "Burn!"
	cast_methods = CAST_MELEE
	aspect = ASPECT_FIRE
	var/obj/item/weapon/weldingtool/spell/welder = null

/obj/item/weapon/spell/flame_tongue/New()
	..()
	set_light(3, 2, l_color = "#FF6A00")
	visible_message("<span class='warning'>\The [loc]'s hand begins to emit a flame.</span>")
	welder = new /obj/item/weapon/weldingtool/spell(src)
	welder.setWelding(1)

/obj/item/weapon/spell/flame_tongue/Destroy()
	qdel(welder)
	welder = null
	return ..()

/obj/item/weapon/weldingtool/spell
	name = "flame"

/obj/item/weapon/weldingtool/spell/process()
	return

//Needed to make the spell welder have infinite fuel.  Don't worry, it uses energy instead.
/obj/item/weapon/weldingtool/spell/remove_fuel()
	return 1

/obj/item/weapon/weldingtool/spell/eyecheck(mob/user as mob)
	return

/obj/item/weapon/spell/flame_tongue/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(isliving(hit_atom) && user.a_intent != I_HELP)
		var/mob/living/L = hit_atom
		if(pay_energy(1000))
			visible_message("<span class='danger'>\The [user] reaches out towards \the [L] with the flaming hand, and they ignite!</span>")
			to_chat(L,"<span class='danger'>You ignite!</span>")
			L.fire_act()
			adjust_instability(12)
	else
		//This is needed in order for the welder to work, and works similarly to grippers.
		welder.forceMove(user)
		var/resolved = hit_atom.attackby(welder, user)
		if(!resolved && welder && hit_atom)
			if(pay_energy(500))
				welder.attack(hit_atom, user, def_zone)
				adjust_instability(4)
		if(welder && user && (welder.loc == user))
			welder.forceMove(src)
		else
			welder = null
			qdel(src)
			return
