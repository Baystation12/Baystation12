/datum/technomancer/spell/mark
	name = "Mark"
	desc = "This function places a specific 'mark' beacon under you, which is used by the Recall function as a destination.  \
	Note that using Mark again will move the destination instead of creating a second destination, and only one destination \
	can exist, regardless of who casted Mark."
	cost = 25
	obj_path = /obj/item/weapon/spell/mark
	ability_icon_state = "tech_mark"
	category = UTILITY_SPELLS

//The object to teleport to when Recall is used.
/obj/effect/mark_spell
	name = "mark"
	desc = "This is a strange looking disturbance."
	opacity = 0
	density = 0
	anchored = 1

//This is global, to avoid looping through a list of all objects, or god forbid, looping through world.
/var/global/obj/effect/mark_spell/mark_spell_ref = null

/obj/item/weapon/spell/mark
	name = "mark"
	icon_state = "mark"
	desc = "Marks a specific location to be used by Recall."
	cast_methods = CAST_USE
	aspect = ASPECT_TELE

/obj/item/weapon/spell/mark/on_use_cast(mob/living/user)
	if(!allowed_to_teleport()) // Otherwise you could teleport back to the admin Z-level.
		to_chat(user,"<span class='warning'>You can't teleport here!</span>")
		return 0
	if(pay_energy(1000))
		if(!mark_spell_ref)
			mark_spell_ref = new(get_turf(user))
			to_chat(user,"<span class='notice'>You mark \the [get_turf(user)] under you.</span>")
		else
			mark_spell_ref.forceMove(get_turf(user))
			to_chat(user,"<span class='notice'>Your mark is moved from its old position to \the [get_turf(user)] under you.</span>")
		adjust_instability(5)
		return 1
	else
		to_chat(user,"<span class='warning'>You can't afford the energy cost!</span>")
		return 0

//Recall

/datum/technomancer/spell/recall
	name = "Recall"
	desc = "This function teleports you to where you placed a mark using the Mark function.  Without the Mark function, this \
	function is useless.  Note that teleporting takes three seconds.  Being incapacitated while teleporting will cancel it."
	enhancement_desc = "Recall takes two seconds instead of three."
	cost = 25
	obj_path = /obj/item/weapon/spell/recall
	ability_icon_state = "tech_recall"
	category = UTILITY_SPELLS

/obj/item/weapon/spell/recall
	name = "recall"
	icon_state = "recall"
	desc = "This will bring you to your Mark."
	cast_methods = CAST_USE
	aspect = ASPECT_TELE

/obj/item/weapon/spell/recall/on_use_cast(mob/living/user)
	if(pay_energy(3000))
		if(!mark_spell_ref)
			to_chat(user,"<span class='danger'>There's no Mark!</span>")
			return 0
		else
			visible_message("<span class='warning'>\The [user] starts glowing!</span>")
			var/light_intensity = 2
			var/time_left = 3
			if(check_for_scepter())
				time_left = 2
			while(time_left)
				if(user.incapacitated())
					visible_message("<span class='notice'>\The [user]'s glow fades.</span>")
					to_chat(user,"<span class='danger'>You cannot Recall while incapacitated!</span>")
					return 0
				light_intensity++
				set_light(light_intensity, light_intensity, l_color = "#006AFF")
				time_left--
				sleep(1 SECOND)

			var/turf/target_turf = get_turf(mark_spell_ref)
			var/turf/old_turf = get_turf(user)

			for(var/obj/item/weapon/grab/G in user.contents) // People the Technomancer is grabbing come along for the ride.
				if(G.affecting)
					G.affecting.forceMove(locate( target_turf.x+rand(-1,1), target_turf.y+rand(-1,1), target_turf.z))
					to_chat(G.affecting,"<span class='warning'>You are teleported along with [user]!</span>")

			user.forceMove(target_turf)
			to_chat(user,"<span class='notice'>You are teleported to your Mark.</span>")

			playsound(target_turf, 'sound/effects/phasein.ogg', 25, 1)
			playsound(target_turf, 'sound/effects/sparks2.ogg', 50, 1)

			playsound(old_turf, 'sound/effects/sparks2.ogg', 50, 1)

			adjust_instability(25)
			qdel(src)
			return 1
	else
		to_chat(user,"<span class='warning'>You can't afford the energy cost!</span>")
		return 0

