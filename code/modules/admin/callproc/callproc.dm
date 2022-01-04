//// VERBS

// standard callproc, select target
/client/proc/callproc()
	set category = "Debug"
	set name = "Advanced ProcCall"

	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return

	var/target = null
	var/targetselected = 0

	switch(alert("Proc owned by something?",, "Yes", "No", "Cancel"))
		if("Yes")
			targetselected=1
			switch(input("Proc owned by...", "Owner", null) as null|anything in list("Obj", "Mob", "Area or Turf", "Client"))
				if("Obj")
					target = input("Select target:", "Target") as null|obj in world
				if("Mob")
					target = input("Select target:", "Target", usr) as null|mob in world
				if("Area or Turf")
					target = input("Select target:", "Target", get_turf(usr)) as null|area|turf in world
				if("Client")
					target = input("Select target:", "Target", usr.client) as null|anything in GLOB.clients
				else
					return
			if(!target)
				to_chat(usr, "Proc call cancelled.")
				return
		if("Cancel")
			return
		if("No")
			; // do nothing

	callproc_targetpicked(targetselected, target)

// right click verb
/client/proc/callproc_target(atom/A in range(world.view))
	set category = "Debug"
	set name = "Advanced ProcCall Target"

	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return

	callproc_targetpicked(1, A)

/datum/admins
	var/datum/callproc/callproc = null // if the user has a callproc datum, it goes here

/client/proc/callproc_targetpicked(hastarget, datum/target)
	// this needs checking again here because VV's 'Call Proc' option directly calls this proc with the target datum
	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return

	if(!holder.callproc)
		holder.callproc = new(src)
	holder.callproc.callproc(hastarget, target)

#define CANCEL -1
#define WAITING 0
#define DONE 1

/datum/callproc
	var/client/C
	var/datum/target
	var/hastarget
	var/procname
	var/list/arguments
	var/waiting_for_click = 0

/datum/callproc/New(client/C)
	..()
	src.C = C

/datum/callproc/proc/clear()
	target = null
	hastarget = null
	procname = null
	arguments = null
	waiting_for_click = 0

/datum/callproc/proc/callproc(hastarget, datum/target)
	src.target = target
	src.hastarget = hastarget

	procname = input("Proc name", "Proc") as null|text
	if(!procname)
		clear()
		return

	if(hastarget)
		if(!target)
			to_chat(usr, "Your callproc target no longer exists.")
			clear()
			return
		if(!hascall(target, procname))
			to_chat(usr, "\The [target] has no call [procname]()")
			clear()
			return

	arguments = list()
	do_args()

/datum/callproc/proc/do_args()
	switch(get_args())
		if(WAITING)
			return
		if(DONE)
			finalise()
	clear()

/datum/callproc/proc/get_args()
	var/done = 0
	var/current = null

	while(!done)
		if(hastarget && !target)
			to_chat(usr, "Your callproc target no longer exists.")
			return CANCEL
		switch(input("Type of [arguments.len+1]\th variable", "argument [arguments.len+1]") as null|anything in list(
				"finished", "null", "text", "num", "type", "obj reference", "mob reference",
				"area/turf reference", "icon", "file", "client", "mob's area", "marked datum", "click on atom"))
			if(null)
				return CANCEL

			if("finished")
				done = 1

			if("null")
				current = null

			if("text")
				current = input("Enter text for [arguments.len+1]\th argument") as null|text
				if(isnull(current)) return CANCEL

			if("num")
				current = input("Enter number for [arguments.len+1]\th argument") as null|num
				if(isnull(current)) return CANCEL

			if("type")
				current = input("Select type for [arguments.len+1]\th argument") as null|anything in typesof(/obj, /mob, /area, /turf)
				if(isnull(current)) return CANCEL

			if("obj reference")
				current = input("Select object for [arguments.len+1]\th argument") as null|obj in world
				if(isnull(current)) return CANCEL

			if("mob reference")
				current = input("Select mob for [arguments.len+1]\th argument") as null|mob in world
				if(isnull(current)) return CANCEL

			if("area/turf reference")
				current = input("Select area/turf for [arguments.len+1]\th argument") as null|area|turf in world
				if(isnull(current)) return CANCEL

			if("icon")
				current = input("Provide icon for [arguments.len+1]\th argument") as null|icon
				if(isnull(current)) return CANCEL

			if("client")
				current = input("Select client for [arguments.len+1]\th argument") as null|anything in GLOB.clients
				if(isnull(current)) return CANCEL

			if("mob's area")
				var/mob/M = input("Select mob to take area for [arguments.len+1]\th argument") as null|mob in world
				if(!M) return
				current = get_area(M)
				if(!current)
					switch(alert("\The [M] appears to not have an area; do you want to pass null instead?",, "Yes", "Cancel"))
						if("Yes")
							; // do nothing
						if("Cancel")
							return CANCEL

			if("marked datum")
				current = C.holder.marked_datum()
				if(!current)
					switch(alert("You do not currently have a marked datum; do you want to pass null instead?",, "Yes", "Cancel"))
						if("Yes")
							; // do nothing
						if("Cancel")
							return CANCEL

			if("click on atom")
				waiting_for_click = 1
				C.verbs += /client/proc/cancel_callproc_select
				to_chat(C, "Click an atom to select it. Click an atom then click 'cancel', or use the Cancel-Callproc-Select verb to cancel selecting a target by click.")
				return WAITING

		if(!done)
			arguments += current

	return DONE

/client/proc/cancel_callproc_select()
	set name = "Cancel Callproc Select"
	set category = "Admin"

	verbs -= /client/proc/cancel_callproc_select
	if(holder && holder.callproc && holder.callproc.waiting_for_click)
		holder.callproc.waiting_for_click = 0
		holder.callproc.do_args()

/client/Click(atom/A)
	if(!user_acted(src))
		return
	if(holder && holder.callproc && holder.callproc.waiting_for_click)
		if(alert("Do you want to select \the [A] as the [holder.callproc.arguments.len+1]\th argument?",, "Yes", "No") == "Yes")
			holder.callproc.arguments += A

		holder.callproc.waiting_for_click = 0
		verbs -= /client/proc/cancel_callproc_select
		holder.callproc.do_args()
	else
		return ..()

/datum/callproc/proc/finalise()
	var/returnval

	if(hastarget)
		if(!target)
			to_chat(usr, "Your callproc target no longer exists.")
			return
		log_and_message_admins("[key_name(C)] called \the [target]'s [procname]() with [arguments.len ? "the arguments [list2params(arguments)]" : "no arguments"].", location = get_turf(target))
		if(arguments.len)
			returnval = call(target, procname)(arglist(arguments))
		else
			returnval = call(target, procname)()
	else
		log_and_message_admins("[key_name(C)] called [procname]() with [arguments.len ? "the arguments [list2params(arguments)]" : "no arguments"].", location = get_turf(target))
		returnval = call(procname)(arglist(arguments))

	to_chat(usr, "<span class='info'>[procname]() returned: [json_encode(returnval)]</span>")

#undef CANCEL
#undef WAITING
#undef DONE
