//Todo on clusternades: add a pin overlay to grenades, and handling for it.



/obj/item/weapon/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	flags = CONDUCT
	slot_flags = SLOT_BELT

	var/truncated_name = "nade" // Used for clusterbombs.

	var/active = 0 //Dangerous if thrown.
	var/primed = 0 //Timer is running.

	var/det_time = 50
	var/arm_sound = 'sound/weapons/armbomb.ogg'
	var/unique_lever = 0 //Applies a specific lever sprite if true, saved as ([icon_state] + "_lever") in grenade.dmi.
	var/is_digital = 1 //Is this an electronic grenade? Used for EMP_act. Required for spawner, gravity, radiation, shock, laser
	var/can_repin = 1 //More or less exclusive to rifle grenades.

/*
---Grenade traits.---
Controls the various behaviors of a grenade. Down the line it should allow for custom grenade synthesis without using chem grenades.
*/
	var/trait_flags //A list of flags concerning grenade behaviors.
	var/trait_flags_2 //Second list of bitflags because we ran out in the first list. DO NOT MIX UP THE FIRST AND SECOND LISTS. YOUR GRENADE WILL NOT BEHAVE CORRECTLY.
	var/trait_power //Dictates things like range, strength of force, amount of projectiles,

	var/detonative_power //Used exclusively by grenades that explode proper.
	var/falloff_type =
//Path to projectiles, items, or mobs that you will spawn, chosen randomly. Any movable atom, really. Not other grenades; that's what cluster bombs are for.

	var/trait_payload_1
	var/trait_payload_2
	var/trait_payload_3

/*
Tactical grenades: Flash; Sonic; Daze; EMP; Anti-Photon
*/

/*
Utility grenades: Cleaner; Metal foam; Pest killer (For space vines); Tear gas; Tranq smoke; Berserk smoke; Medicine smoke;
Defers to chemical grenade behavior in chem_grenade.dm
*/


/*
Spawner grenades: Carp; Holocarp; Viscerator; Spiderling
*/







/obj/item/weapon/grenade/New()
	..()
	var/icon/L = image(icon, unique_lever ? "[src]_lever" : "lever")
	overlays += L


/obj/item/weapon/grenade/proc/clown_check(var/mob/living/user)
	if((CLUMSY in user.mutations))
		to_chat(user, "<span class='warning'>Huh? How does this thing work?</span>")
		return 0 //Grenades take a lot of dexterity and hard EFFORT to work.
	return 1

/obj/item/weapon/grenade/examine(mob/user)
	if(..(user, 0))
		if(det_time > 1)
			to_chat(user, "The timer is set to [det_time/10] seconds.")
			return
		if(det_time == null)
			return
		to_chat(user, "\The [src] is set for instant detonation.")


/obj/item/weapon/grenade/attack_self(mob/user as mob)
	if (primed)
		to_chat(user, "<span class='warning'>Why are you fiddling out with a live grenade?")
		if(iscarbon(user))
			var/mob/living/carbon/U = user
			U.throw_mode_on()
		return

	if(clown_check(user))
		add_fingerprint(user)
		toggle_active()



//Todo: Rename all previous uses of activate to prime.
/obj/item/weapon/grenade/proc/toggle_active()
	if(active)
		if(can_repin)
			user.visible_message("<span class='warning'>[user] puts the pin back into \his [name]!</span>",\
			"<span class='notice'>You put the pin back into \the [name].</span>",\
			"You hear a disappointing scrape.")

			active = 0
			icon_state = initial(icon_state)
			if(iscarbon(user))
				var/mob/living/carbon/U = user
				U.throw_mode_off() //To keep players from accidentally tossing repinned grenades.
	else
		active = 1
		icon_state = initial(icon_state) + "_active"
		user.visible_message("<span class='warning'>[user] rips the pin out of \his [src]!</span>",\
		"<span class='warning'>You prime \the [name]! [det_time/10] seconds! Give it a hurl!</span>",\
		"You hear an ominous click.")
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()
	//Todo: Add a pin noise. On hand ideas are a noise sample, edited to be covered by parody OR the construction noise from chemnades.


//Grenade is dangerous now.
/obj/item/weapon/grenade/proc/prime()
	if(primed)
		return
	//Todo: Add a priming noise... Likely the one used before the refactor.
	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, arm_sound, 75, 0, -3)

	spawn(det_time)
		detonate()
		return


///obj/item/weapon/grenade/proc/detonate() // Held in newnades.dm for the sake of coder sanity.





/obj/item/weapon/grenade/throw_at()
	if(active)
		prime(src)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] via throw. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		var/obj/item/weapon/safety_clip/C = new /obj/item/weapon/safety_clip(loc)
		C.add_fingerprint(user)
		C.throw_at(target, (throw_range/2.75), throw_speed, src) //Safety clip flies past with it.


/obj/item/weapon/grenade/dropped()
	if(active)
		prime(src)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] via drop. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")



/obj/item/weapon/grenade/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		switch(det_time)
			if (1)
				det_time = 10
				to_chat(user, "<span class='notice'>You set the [name] for 1 second detonation time.</span>")
			if (10)
				det_time = 30
				to_chat(user, "<span class='notice'>You set the [name] for 3 second detonation time.</span>")
			if (30)
				det_time = 50
				to_chat(user, "<span class='notice'>You set the [name] for 5 second detonation time.</span>")
			if (50)
				det_time = 1
				to_chat(user, "<span class='notice'>You set the [name] for instant detonation.</span>")
		add_fingerprint(user)
	..()
	return

//Handle grenadeparts.
/obj/item/weapon/grenade/attackby(obj/item/weapon/W as obj, mob/user as mob)

/obj/item/weapon/grenade/attack_hand()
	walk(src, null, null)
	..()
	return



/obj/item/weapon/safety_clip
	name = "grenade safety clip"
	description = "A safety clip used to delay grenade detonation as long as it is being depressed. Evidently this grenade's user let go of this one."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "lever"
	matter = list(DEFAULT_WALL_MATERIAL = 3000)