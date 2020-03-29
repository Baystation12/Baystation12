/datum/computer_file/data/access_record
	filetype = "ACR"
	size = 2
	var/list/grants = list()
	var/user_id							// A unique identifier linking a mob/player/user to this access record and their grants.
	var/desired_name					// A friendly name used to identify this user.
	read_only 	= 1
	var/ennid							// The exonet network ID this access record is associated with.

/datum/computer_file/data/access_record/proc/add_grant(var/datum/computer_file/data/grant_record/grant)
	LAZYDISTINCTADD(grants, grant)

/datum/computer_file/data/access_record/proc/get_access()
	var/list/access_grants = list()
	for(var/datum/computer_file/data/grant_record/grant in get_valid_grants())
		LAZYDISTINCTADD(access_grants, "[ennid].[grant.stored_data]")
	return access_grants

/datum/computer_file/data/access_record/proc/get_valid_grants()
	var/list/valid_grants = list()
	for(var/datum/computer_file/data/grant_record/grant in grants)
		if(grant.holder != holder)
			grants.Remove(grant)
			continue // This is a bad grant. File is gone or moved.
		LAZYDISTINCTADD(valid_grants, grant)
	return valid_grants


/datum/computer_file/data/grant_record
	filetype = "GRT"
	size = 2
	do_not_edit = 1					// Whether the user will be reminded that the file probably shouldn't be edited.
	
/datum/computer_file/data/grant_record/proc/set_value(var/value)
	stored_data = replacetext(sanitize(uppertext(value)), " ", "_")
