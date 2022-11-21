/**
 * The atom's default topic state. Used in various Topic related proc calls and defines to validate interactions.
 *
 * Returns `GLOB.default_state` by default, or a subtype of `/datum/topic_state`.
 */
/atom/proc/DefaultTopicState()
	return GLOB.default_state

/atom/Topic(href, href_list = list(), datum/topic_state/state)
	if((. = ..()))
		return
	state = state || DefaultTopicState() || GLOB.default_state
	if(CanUseTopic(usr, state, href_list) == STATUS_INTERACTIVE)
		CouldUseTopic(usr)
		return OnTopic(usr, href_list, state)
	CouldNotUseTopic(usr)
	return TRUE

/**
 * Called when a user successfully interacts with a topic interaction window.
 *
 * **Parameters**:
 * - `user` - The mob interacting with the atom.
 * - `href_list` - An associative list of parameters passed by the topic call.
 * - `state` - The topic chain's state.
 *
 * Returns int (One of `TOPIC_*`). The return value determines what happens to the topic UI window upon completion of the interaction. See `code\__defines\topic.dm`.
 */
/atom/proc/OnTopic(mob/user, href_list, datum/topic_state/state)
	return TOPIC_NOACTION

// Override prescribes default state argument.
/atom/CanUseTopic(mob/user, datum/topic_state/state = DefaultTopicState() || GLOB.default_state, href_list)
	return ..()

/obj/CanUseTopic(mob/user, datum/topic_state/state = DefaultTopicState() || GLOB.default_state, href_list)
	return min(..(), user.CanUseObjTopic(src, state))

/mob/living/CanUseObjTopic(obj/O, datum/topic_state/state)
	. = ..()
	if(state.check_access && !O.check_access(src))
		. = min(., STATUS_UPDATE)

/mob/proc/CanUseObjTopic()
	return STATUS_INTERACTIVE

/**
 * Called if the `CanUseTopic()` call succeeds in `Topic()`.
 *
 * **Parameters**:
 * - `user` - The Topic chain's user.
 */
/atom/proc/CouldUseTopic(mob/user)
	user.AddTopicPrint(src)

/mob/proc/AddTopicPrint(atom/target)
	if(!istype(target))
		return
	target.add_hiddenprint(src)

/mob/living/AddTopicPrint(atom/target)
	if(!istype(target))
		return
	if(Adjacent(target))
		target.add_fingerprint(src)
	else
		target.add_hiddenprint(src)

/mob/living/silicon/ai/AddTopicPrint(atom/target)
	if(!istype(target))
		return
	target.add_hiddenprint(src)

/**
 * Called if the `CanUseTopic()` call fails in `Topic()`.
 *
 * **Parameters**:
 * - `user` - The Topic chain's user.
 */
/atom/proc/CouldNotUseTopic(mob/user)
