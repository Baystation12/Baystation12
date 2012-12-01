/*
		name
		key
		description
		role
		comments
		ready = 0
*/

/datum/paiCandidate/proc/savefile_path(mob/user)
	return "data/player_saves/[copytext(user.ckey, 1, 2)]/[user.ckey]/pai.sav"

/datum/paiCandidate/proc/savefile_save(mob/user)
	if(IsGuestKey(user.key))
		return 0

	var/savefile/F = new /savefile(src.savefile_path(user))


	F["name"] << src.name
	F["description"] << src.description
	F["role"] << src.role
	F["comments"] << src.comments

	F["version"] << 1

	return 1

// loads the savefile corresponding to the mob's ckey
// if silent=true, report incompatible savefiles
// returns 1 if loaded (or file was incompatible)
// returns 0 if savefile did not exist

/datum/paiCandidate/proc/savefile_load(mob/user, var/silent = 1)
	if (IsGuestKey(user.key))
		return 0

	var/path = savefile_path(user)

	if (!fexists(path))
		return 0

	var/savefile/F = new /savefile(path)

	if(!F) return //Not everyone has a pai savefile.

	var/version = null
	F["version"] >> version

	if (isnull(version) || version != 1)
		fdel(path)
		if (!silent)
			alert(user, "Your savefile was incompatible with this version and was deleted.")
		return 0

	F["name"] >> src.name
	F["description"] >> src.description
	F["role"] >> src.role
	F["comments"] >> src.comments
	return 1
