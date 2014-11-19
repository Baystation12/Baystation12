var/list/vip_datums = list()

/datum/vips
	var/rank			= "Temporary Vip"
	var/client/owner	= null
	var/rights = 0

	var/datum/marked_datum


/datum/vips/New(initial_rank = "Temporary Vip", initial_rights = 0, ckey)
	if(!ckey)
		error("vip datum created without a ckey argument. Datum has been deleted")
		del(src)
		return
	rank = initial_rank
	rights = initial_rights
	vip_datums[ckey] = src

/datum/vips/proc/associate(client/C)
	if(istype(C))
		owner = C
		owner.vipholder = src
		owner.add_vip_verbs()	//TODO
		vips |= C

/datum/vips/proc/disassociate()
	if(owner)
		vips -= owner
		owner.remove_vip_verbs()
		owner.vipholder = null
		owner = null

/*
checks if usr is an vip with at least ONE of the flags in rights_required. (Note, they don't need all the flags)
if rights_required == 0, then it simply checks if they are an vip.
if it doesn't return 1 and show_msg=1 it will prints a message explaining why the check has failed
generally it would be used like so:

proc/vip_proc()
	if(!vip_check_rights(V_VIP)) return
	world << "you have enough rights!"

NOTE: it checks usr! not src! So if you're checking somebody's rank in a proc which they did not call
you will have to do something like if(client.vipholder.rights & V_VIP) yourself.
*/
/proc/vip_check_rights(rights_required, show_msg=1)
	if(usr && usr.client)
		if(rights_required)
			if(usr.client.vipholder)
				if(rights_required & usr.client.vipholder.rights)
					return 1
				else
					if(show_msg)
						usr << "<font color='red'>Error: You do not have sufficient rights to do that. You require one of the following flags:[vip_rights2text(rights_required," ")].</font>"
		else
			if(usr.client.vipholder)
				return 1
			else
				if(show_msg)
					usr << "<font color='red'>Error: You are not a VIP.</font>"
	return 0

//probably a bit iffy - will hopefully figure out a better solution
/proc/vip_check_if_greater_rights_than(client/other)
	if(usr && usr.client)
		if(usr.client.vipholder)
			if(!other || !other.vipholder)
				return 1
			if(usr.client.vipholder.rights != other.vipholder.rights)
				if( (usr.client.vipholder.rights & other.vipholder.rights) == other.vipholder.rights )
					return 1	//we have all the rights they have and more
		usr << "<font color='red'>Error: Cannot proceed. They have more or equal rights to us.</font>"
	return 0



/client/proc/de_vip()
	vip_datums -= ckey
	if(vipholder)
		vipholder.rights = null
		vipholder.disassociate()
		del(vipholder)
	return 1