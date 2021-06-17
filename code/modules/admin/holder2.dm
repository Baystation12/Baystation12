#define STEALTH_OFF 0
#define STEALTH_MANUAL 1
#define STEALTH_AUTO 2

var/list/admin_datums = list()

/datum/admins
	var/rank         = "Temporary Admin"
	var/client/owner = null
	var/rights       = 0
	var/stealthy_    = STEALTH_OFF

	var/weakref/marked_datum_weak

	var/admincaster_screen = 0	//See newscaster.dm under machinery for a full description
	var/datum/feed_message/admincaster_feed_message = new /datum/feed_message   //These two will act as holders.
	var/datum/feed_channel/admincaster_feed_channel = new /datum/feed_channel
	var/admincaster_signature	//What you'll sign the newsfeeds as

/datum/admins/proc/marked_datum()
	if(marked_datum_weak)
		return marked_datum_weak.resolve()

/datum/admins/New(initial_rank = "Temporary Admin", initial_rights = 0, ckey)
	if(!ckey)
		error("Admin datum created without a ckey argument. Datum has been deleted")
		qdel(src)
		return
	admincaster_signature = "[GLOB.using_map.company_name] Officer #[rand(0,9)][rand(0,9)][rand(0,9)]"
	rank = initial_rank
	rights = initial_rights
	admin_datums[ckey] = src
	if (rights & R_DEBUG)
		world.SetConfig("APP/admin", ckey, "role=admin")

/datum/admins/proc/associate(client/C)
	if(istype(C))
		if(admin_datums[C.ckey] != src)
			return
		owner = C
		owner.holder = src
		owner.add_admin_verbs()	//TODO
		GLOB.admins |= C

/datum/admins/proc/disassociate()
	if(owner)
		GLOB.admins -= owner
		owner.remove_admin_verbs()
		owner.deadmin_holder = owner.holder
		owner.holder = null

/datum/admins/proc/reassociate()
	if(owner)
		GLOB.admins += owner
		owner.holder = src
		owner.deadmin_holder = null
		owner.add_admin_verbs()


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
				to_chat(C, "<span class='warning'>Error: You do not have sufficient rights to do that. You require one of the following flags:[rights2text(rights_required," ")].</span>")
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
		holder.disassociate()
		//qdel(holder)
	return 1

/mob/Stat()
	. = ..()
	if(!client)
		return

	var/stealth_status = client.is_stealthed()
	if(stealth_status && statpanel("Status"))
		stat("Stealth", "Engaged [client.holder.stealthy_ == STEALTH_AUTO ? "(Auto)" : "(Manual)"]")

/client/proc/is_stealthed()
	if(!holder)
		return FALSE

	var/auto_stealth = (inactivity >= world.time) || (config.autostealth && (inactivity >= MinutesToTicks(config.autostealth)))
	// If someone has been AFK since round-start or longer, stealth them
	// BYOND keeps track of inactivity between rounds as long as it's not a full stop/start.
	if(holder.stealthy_ == STEALTH_OFF && auto_stealth)
		holder.stealthy_ = STEALTH_AUTO
	else if(holder.stealthy_ == STEALTH_AUTO && !auto_stealth)
		// And if someone has been set to auto-stealth and returns, unstealth them
		holder.stealthy_ = STEALTH_OFF
	return holder.stealthy_

/mob/proc/is_stealthed()
	return client && client.is_stealthed()

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"

	if(!holder)
		to_chat(src, "<span class='warning'>Error: You are not an admin.</span>")
		return

	holder.stealthy_ = holder.stealthy_ == STEALTH_OFF ? STEALTH_MANUAL : STEALTH_OFF
	if(holder.stealthy_)
		to_chat(src, "<span class='notice'>You are now stealthed.</span>")
	else
		to_chat(src, "<span class='notice'>You are no longer stealthed.</span>")
	log_and_message_admins("has turned stealth mode [holder.stealthy_ ? "ON" : "OFF"]")
	SSstatistics.add_field_details("admin_verb","SM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

#undef STEALTH_OFF
#undef STEALTH_MANUAL
#undef STEALTH_AUTO