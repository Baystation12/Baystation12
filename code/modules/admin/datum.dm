#define STEALTH_OFF 0
#define STEALTH_MANUAL 1
#define STEALTH_AUTO 2

/datum/admin
	var/rank  = "Unknown"
	var/rights = 0
	var/flags = 0
	var/stealthy = STEALTH_OFF

	var/weakref/marked_datum_weak

/datum/admin/proc/marked_datum()
	if(marked_datum_weak)
		return marked_datum_weak.resolve()

/datum/admin/CanProcCall(procname)
	return FALSE

/datum/admin/New(rank, rights, flags = 0)
	src.rank = rank
	src.rights = rights
	src.flags = flags

/*
checks if usr is an admin with at least ONE of the flags in rights_required. (Note, they don't need all the flags)
if rights_required == 0, then it simply checks if they are an admin.
if it doesn't return 1 and show_msg=1 it will prints a message explaining why the check has failed
generally it would be used like so:

proc/admin_proc()
	if(!check_rights(R_ADMIN)) return
	to_chat(usr, "you have enough rights!")

NOTE: It checks usr by default. Supply the "user" argument if you wish to check for a specific mob.
*/
/proc/check_rights(rights_required, show_msg=1, var/client/C = usr)
	if(ismob(C))
		var/mob/M = C
		C = M.client
	if(!C)
		return FALSE
	if(!C.holder)
		if(show_msg)
			to_chat(C, "<span class='warning'>Error: You are not an admin.</span>")
		return FALSE

	if(rights_required)
		if(rights_required & C.holder.rights)
			return TRUE
		else
			if(show_msg)
				to_chat(C, "<span class='warning'>Error: You do not have sufficient rights to do that. You require one of the following flags: [rights2text(rights_required," ")].</span>")
			return FALSE
	else
		return TRUE

//probably a bit iffy - will hopefully figure out a better solution
/proc/check_if_greater_rights_than(client/other)
	if(usr && usr.client)
		if(usr.client.holder)
			if(!other || !other.holder)
				return 1
			if(usr.client.holder.rights != other.holder.rights)
				if( (usr.client.holder.rights & other.holder.rights) == other.holder.rights )
					return 1	//we have all the rights they have and more
		to_chat(usr, "<font color='red'>Error: Cannot proceed. They have more or equal rights to us.</font>")
	return 0

/client/proc/deadmin()
	if(holder)
		deadmin_holder = holder
		holder = null
		remove_admin_verbs()
		GLOB.admins -= src
	return 1

/client/proc/readmin()
	if (deadmin_holder)
		holder = deadmin_holder
		deadmin_holder = null
		add_admin_verbs()
		GLOB.admins += src

/mob/Stat()
	. = ..()
	if(!client)
		return

	var/stealth_status = client.is_stealthed()
	if(stealth_status && statpanel("Status"))
		stat("Stealth", "Engaged [client.holder.stealthy == STEALTH_AUTO ? "(Auto)" : "(Manual)"]")

/client/proc/is_stealthed()
	if(!holder)
		return FALSE

	// If someone has been AFK since round-start or longer, stealth them
	// BYOND keeps track of inactivity between rounds as long as it's not a full stop/start.
	if(holder.stealthy == STEALTH_OFF && ((inactivity >= world.time) || (config.autostealth && inactivity >= MinutesToTicks(config.autostealth))))
		holder.stealthy = STEALTH_AUTO
	else if(holder.stealthy == STEALTH_AUTO && inactivity < world.time)
		// And if someone has been set to auto-stealth and returns, unstealth them
		holder.stealthy = STEALTH_OFF
	return holder.stealthy

/mob/proc/is_stealthed()
	return client && client.is_stealthed()

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"

	if(!check_rights())
		return

	holder.stealthy = holder.stealthy == STEALTH_OFF ? STEALTH_MANUAL : STEALTH_OFF
	if(holder.stealthy)
		to_chat(src, "<span class='notice'>You are now stealthed.</span>")
	else
		to_chat(src, "<span class='notice'>You are no longer stealthed.</span>")
	log_and_message_admins("has turned stealth mode [holder.stealthy ? "ON" : "OFF"]")

#undef STEALTH_OFF
#undef STEALTH_MANUAL
#undef STEALTH_AUTO
