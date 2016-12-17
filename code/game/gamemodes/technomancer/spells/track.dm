/datum/technomancer/spell/track
	name = "Track"
	desc = "Acts as directional guidance towards an object that belongs to you or your team.  It can also point towards your allies.  \
	Wonderful if you're worried someone will steal your valuables, like a certain shiny Scepter..."
	enhancement_desc = "You will be able to track most other entities in addition to your belongings and allies."
	cost = 25
	obj_path = /obj/item/weapon/spell/track
	ability_icon_state = "tech_track"
	category = UTILITY_SPELLS

// This stores a ref to all important items that belong to a Technomancer, in case of theft.  Used by the spell below.
// I feel dirty for adding yet another global list used by one thing, but the only alternative is to loop through world, and yeahhh.
var/list/technomancer_belongings = list()

/obj/item/weapon/spell/track
	name = "track"
	icon_state = "track"
	desc = "Never lose your stuff again!"
	cast_methods = CAST_USE
	aspect = ASPECT_TELE
	var/atom/movable/tracked = null // The thing to point towards.
	var/tracking = 0 // If one, points towards tracked.

/obj/item/weapon/spell/track/Destroy()
	tracked = null
	tracking = 0
	return ..()

/obj/item/weapon/spell/track/on_use_cast(mob/user)
	if(tracking)
		tracking = 0
		to_chat(user,"<span class='notice'>You stop tracking for \the [tracked]'s whereabouts.</span>")
		tracked = null
		return

	var/can_track_non_allies = 0
	var/list/object_choices = technomancer_belongings.Copy()
	if(check_for_scepter())
		can_track_non_allies = 1
	var/list/mob_choices = list()
	for(var/mob/living/L in mob_list)
		if(!is_ally(L) && !can_track_non_allies)
			continue
		if(L == user)
			continue
		mob_choices += L
	var/choice = input(user,"Decide what or who to track.","Tracking") as null|anything in object_choices + mob_choices
	if(choice)
		tracked = choice
		tracking = 1
		track()

/obj/item/weapon/spell/track/proc/track()
	if(!tracking)
		icon_state = "track"
		return

	if(!tracked)
		icon_state = "track_unknown"

	if(tracked.z != owner.z)
		icon_state = "track_unknown"

	else
		set_dir(get_dir(src,get_turf(tracked)))

		switch(get_dist(src,get_turf(tracked)))
			if(0)
				icon_state = "track_direct"
			if(1 to 8)
				icon_state = "track_close"
			if(9 to 16)
				icon_state = "track_medium"
			if(16 to INFINITY)
				icon_state = "track_far"

	spawn(5)
		.()