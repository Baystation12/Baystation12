/var/repository/follow/follow_repository = new()

/repository/follow
	var/datum/cache_entry/valid_until/cache

	var/list/followed_objects
	var/list/followed_objects_assoc
	var/list/followed_subtypes

	var/list/excluded_subtypes = list(
		/obj/machinery/atmospherics, // Atmos stuff calls initialize time and time again..,
		/mob/living/carbon/human/dummy/mannequin
	)

/repository/follow/New()
	..()
	followed_objects = list()
	followed_objects_assoc = list()
	followed_subtypes = list()

	for(var/fht in subtypesof(/datum/follow_holder))
		var/datum/follow_holder/fh = fht
		followed_subtypes[initial(fh.followed_type)] = fht

/repository/follow/proc/add_subject(var/atom/movable/AM)
	cache = null

	var/follow_holder_type = get_follow_type(AM)
	var/follow_holder = new follow_holder_type(AM)

	followed_objects_assoc[AM] = follow_holder
	followed_objects.Add(follow_holder)

	GLOB.destroyed_event.register(AM, src, /repository/follow/proc/remove_subject)

/repository/follow/proc/remove_subject(var/atom/movable/AM)
	cache = null

	var/follow_holder = followed_objects_assoc[AM]

	followed_objects_assoc -= AM
	followed_objects.Remove(follow_holder)

	GLOB.destroyed_event.unregister(AM, src, /repository/follow/proc/remove_subject)

	qdel(follow_holder)

/repository/follow/proc/get_follow_type(var/atom/movable/AM)
	for(var/follow_type in followed_subtypes)
		if(istype(AM, follow_type))
			return followed_subtypes[follow_type]

/repository/follow/proc/get_follow_targets()
	if(cache && cache.is_valid())
		return cache.data
	// The previous cache entry should have no further references and will thus be GCd eventually without qdel
	// Cache invalidated periodically in case of name changes, etc.
	cache = new(5 SECONDS)

	var/list/followed_by_name = list()
	for(var/followed_object in followed_objects)
		var/datum/follow_holder/fh = followed_object
		if(fh.show_entry())
			group_by(followed_by_name, fh.get_name(TRUE), fh)

	var/list/L = list()

	for(var/followed_name in followed_by_name)
		var/list/followed_things = followed_by_name[followed_name]
		if(followed_things.len == 1)
			ADD_SORTED(L, followed_things[1], /proc/cmp_follow_holder)
		else
			for(var/i = 1 to followed_things.len)
				var/datum/follow_holder/followed_thing = followed_things[i]
				followed_thing.instance = i
				followed_thing.get_name(TRUE)
				ADD_SORTED(L, followed_thing, /proc/cmp_follow_holder)

	cache.data = L
	return L

/atom/movable/Initialize()
	. = ..()
	if(!is_type_in_list(src, follow_repository.excluded_subtypes) && is_type_in_list(src, follow_repository.followed_subtypes))
		follow_repository.add_subject(src)

/******************
* Follow Metadata *
******************/

/datum/follow_holder
	var/name
	var/suffix = ""
	var/instance
	var/followed_type
	var/sort_order
	var/atom/movable/followed_instance

/datum/follow_holder/New(var/atom/movable/followed_instance)
	..()
	src.followed_instance = followed_instance
	suffix = suffix ? "\[[suffix]\]" : suffix

/datum/follow_holder/Destroy()
	followed_instance = null
	. = ..()

/datum/follow_holder/proc/get_name(var/recalc = FALSE)
	if(!name || recalc)
		var/suffix = get_suffix(followed_instance)
		name = "[followed_instance.follow_name()][instance ? " ([instance])" : ""][suffix ? " [suffix]" : ""]"
	return name

/atom/movable/proc/follow_name()
	return name

/mob/follow_name()
	return real_name || name

/datum/follow_holder/proc/show_entry()
	return !!followed_instance

/datum/follow_holder/proc/get_suffix()
	var/extra_suffix = followed_instance.follow_suffix()
	return "[suffix][suffix && extra_suffix ? " " : ""][extra_suffix]"

/atom/movable/proc/follow_suffix()
	return

/mob/living/follow_suffix()
	return stat == DEAD ? "\[DEAD\]" : ..()

// If you wish for objects to have coordinates you can simply uncomment the lines below
//  , just keep in mind that tracking is based on name which makes following something that moves often a bit of a pain (even with the 3 second cache).
/*
/obj/follow_suffix()
	var/turf/T = get_turf(src)
	return T ? "\[[T.x],[T.y],[T.z]\]" : ..()
*/

/datum/follow_holder/eye
	sort_order = 0
	followed_type = /mob/observer/eye
	suffix = "Eye"

/datum/follow_holder/ai
	sort_order = 1
	followed_type = /mob/living/silicon/ai
	suffix = "AI"

/datum/follow_holder/pai
	sort_order = 2
	followed_type = /mob/living/silicon/pai
	suffix = "pAI"

/datum/follow_holder/robot
	sort_order = 2
	followed_type = /mob/living/silicon/robot

/datum/follow_holder/robot/show_entry()
	var/mob/living/silicon/robot/R = followed_instance
	return ..() && R.braintype

/datum/follow_holder/robot/get_suffix(var/mob/living/silicon/robot/R)
	suffix = "\[[R.braintype]\][R.module ? " \[[R.module.name]\]" : ""]"
	return ..()

/datum/follow_holder/human
	sort_order = 2
	followed_type = /mob/living/carbon/human

/datum/follow_holder/human/get_suffix(var/mob/living/carbon/human/H)
	suffix = "\[[H.species.name]\]"
	return ..()

/datum/follow_holder/brain
	sort_order = 3
	followed_type = /mob/living/carbon/brain
	suffix = "Brain"

/datum/follow_holder/alien
	sort_order = 4
	followed_type = /mob/living/carbon/alien
	suffix = "Alien"

/datum/follow_holder/ghost
	sort_order = 5
	followed_type = /mob/observer/ghost
	suffix = "Ghost"

/datum/follow_holder/simple_animal
	sort_order = 6
	followed_type = /mob/living/simple_animal
	suffix = "Animal"

/datum/follow_holder/slime
	sort_order = 6
	followed_type = /mob/living/carbon/slime
	suffix = "Slime"

/datum/follow_holder/spiderling
	sort_order = 6
	followed_type = /obj/effect/spider/spiderling

/datum/follow_holder/spiderling/show_entry()
	var/obj/effect/spider/spiderling/S = followed_instance
	return ..() && S.amount_grown > 0

/datum/follow_holder/bot
	sort_order = 7
	followed_type = /mob/living/bot
	suffix = "Bot"

/datum/follow_holder/mob
	sort_order = 7
	followed_type = /mob/living // List all other (living) mobs we haven't given a special suffix
	suffix = "Mob"

/datum/follow_holder/mech
	sort_order = 8
	followed_type = /obj/mecha
	suffix = "Mech"

/datum/follow_holder/mech/get_suffix(var/obj/mecha/M)
	suffix = M.occupant ? "\[[M.occupant]\] \[[initial(suffix)]\]" : "\[[initial(suffix)]\]"
	return ..()

/datum/follow_holder/blob
	sort_order = 9
	followed_type = /obj/effect/blob/core
	suffix = "Blob"

/datum/follow_holder/supermatter
	sort_order = 10
	followed_type = /obj/machinery/power/supermatter

/datum/follow_holder/singularity
	sort_order = 10
	followed_type = /obj/singularity

/datum/follow_holder/nuke_disc
	sort_order = 11
	followed_type = /obj/item/weapon/disk/nuclear

/datum/follow_holder/nuclear_bomb
	sort_order = 12
	followed_type = /obj/machinery/nuclearbomb

/datum/follow_holder/captains_spare
	sort_order = 13
	followed_type = /obj/item/weapon/card/id/captains_spare

/datum/follow_holder/stack
	sort_order = 14
	followed_type = /obj/item/organ/internal/stack

/datum/follow_holder/stack/show_entry()
	var/obj/item/organ/internal/stack/S = followed_instance
	return ..() && !S.owner
