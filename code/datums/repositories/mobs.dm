var/repository/mob/mob_repository = new()

/repository/mob
	var/list/mobs_

/repository/mob/New()
	..()
	mobs_ = list()

// A lite mob is unique per ckey and mob real name/ref (ref conflicts possible.. but oh well)
/repository/mob/proc/get_lite_mob(var/mob/M)
	var/mob_key = mob2unique(M)
	. = mobs_[mob_key]
	if(!.)
		. = new/datum/mob_lite(M)
		mobs_[mob_key] = .

/datum/mob_lite
	var/name = "*no mob*"
	var/ref
	var/datum/client_lite/client

/datum/mob_lite/New(var/mob/M)
	name =(M && (M.real_name || M.name)) || name
	ref = (M && any2ref(M)) || ref
	client = client_repository.get_lite_client(M)

/datum/mob_lite/proc/key_name(var/pm_link = TRUE, var/check_if_offline = TRUE)
	return client.key_name(pm_link, check_if_offline)
