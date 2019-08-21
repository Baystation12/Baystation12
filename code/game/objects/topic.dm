/obj/proc/DefaultTopicState()
	return GLOB.default_state

/obj/Topic(var/href, var/href_list = list(), var/datum/topic_state/state)
	if((. = ..()))
		return
	state = state || DefaultTopicState() || GLOB.default_state
	if(CanUseTopic(usr, state, href_list) == STATUS_INTERACTIVE)
		CouldUseTopic(usr)
		return OnTopic(usr, href_list, state)
	CouldNotUseTopic(usr)
	return TRUE

/obj/proc/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	return TOPIC_NOACTION

/obj/CanUseTopic(var/mob/user, var/datum/topic_state/state = DefaultTopicState() || GLOB.default_state, var/href_list)
	return min(..(), user.CanUseObjTopic(src, state))

/mob/living/CanUseObjTopic(var/obj/O, var/datum/topic_state/state)
	. = ..()
	if(state.check_access && !O.check_access(src))
		. = min(., STATUS_UPDATE)

/mob/proc/CanUseObjTopic()
	return STATUS_INTERACTIVE

/obj/proc/CouldUseTopic(var/mob/user)
	user.AddTopicPrint(src)

/mob/proc/AddTopicPrint(var/atom/target)
	if(!istype(target))
		return
	target.add_hiddenprint(src)

/mob/living/AddTopicPrint(var/atom/target)
	if(!istype(target))
		return
	if(Adjacent(target))
		target.add_fingerprint(src)
	else
		target.add_hiddenprint(src)

/mob/living/silicon/ai/AddTopicPrint(var/atom/target)
	if(!istype(target))
		return
	target.add_hiddenprint(src)

/obj/proc/CouldNotUseTopic(var/mob/user)
	return
