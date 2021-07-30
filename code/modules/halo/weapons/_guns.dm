
#define EASYMODIFY_SCOPE_ZOOM_VERB_INCREMENT 0.5
#define ACTION_USE_SCOPE "Use Scope"
#define ACTION_ADJUST_ZOOM_PLUS "Adjust Zoom (+0.5)"
#define ACTION_ADJUST_ZOOM_MINUS "Adjust Zoom (-0.5)"

/obj/item/weapon/gun
	var/scope_zoom_amount = 0
	var/max_zoom_amount = 0
	var/min_zoom_amount = BASE_MIN_MAGNIF
	var/is_scope_variable = 0 //If this is set to 1, the set_scope_zoom verb will be added to the list of usable verbs.
	var/list/weapon_actions = list()

/obj/item/weapon/gun/Initialize()
	. = ..()
	if(scope_zoom_amount != 0)
		create_scope_actions(0)
		if(max_zoom_amount == 0)
			max_zoom_amount = scope_zoom_amount
	if(is_scope_variable)
		create_scope_actions(1)
		verbs += /obj/item/weapon/gun/proc/verb_set_scope_zoom
		verbs += /obj/item/weapon/gun/proc/verb_increase_zoom_amt
		verbs += /obj/item/weapon/gun/proc/verb_decrease_zoom_amt

/obj/item/weapon/gun/proc/verb_set_scope_zoom()
	set name = "Set Scope Zoom"
	set category = "Weapon"
	set popup_menu = 1

	if(istype(usr,/mob/living))
		var/setzoom = input(usr,"Set Scope Zoom?","Max Zoom: [max_zoom_amount]x, Min Zoom: [min_zoom_amount]x") as num
		set_scope_zoom(setzoom,usr)

/obj/item/weapon/gun/proc/set_scope_zoom(var/setzoom,var/mob/user) //The set zoom amount on the weapon is
	if(setzoom < min_zoom_amount)
		if(user)
			to_chat(user,"<span class = 'notice'>Zoom must be greater than or equal to [min_zoom_amount]. Defaulting to [min_zoom_amount].</span>")
		scope_zoom_amount = min_zoom_amount
	else if(setzoom > max_zoom_amount)
		if(user)
			to_chat(user,"<span class = 'notice'>Zoom must be less than or equal to [max_zoom_amount]. Defaulting to [max_zoom_amount].</span>")
		scope_zoom_amount = max_zoom_amount
	else
		if(user)
			to_chat(user,"<span class = 'notice'>Zoom level set to [setzoom].</span>")
		scope_zoom_amount = setzoom


/obj/item/weapon/gun/proc/increase_decrease_zoom_amt(var/increase,var/mob/user)
	if(user == loc)
		var/do_rezoom = 0
		if(zoom)
			do_rezoom = 1
			toggle_scope(user)
		if(increase)
			set_scope_zoom(scope_zoom_amount+EASYMODIFY_SCOPE_ZOOM_VERB_INCREMENT,user)
		else
			set_scope_zoom(scope_zoom_amount-EASYMODIFY_SCOPE_ZOOM_VERB_INCREMENT,user)
		if(do_rezoom)
			toggle_scope(user,scope_zoom_amount)

/obj/item/weapon/gun/proc/verb_increase_zoom_amt()
	set name = "Increase Scope Zoom"
	set category = "Weapon"
	set popup_menu = 1

	increase_decrease_zoom_amt(1,usr)

/obj/item/weapon/gun/proc/verb_decrease_zoom_amt()
	set name = "Decrease Scope Zoom"
	set category = "Weapon"
	set popup_menu = 1

	increase_decrease_zoom_amt(0,usr)

//Let's make these scopes and such easier to interact with.//
/datum/action/item_action/scope_action/CheckRemoval(var/mob/living/user)
	if(!user || !target)
		return 1
	var/mob/living/carbon/human/h_user = user
	if(!istype(h_user)) //If we're not doing special human handling, let's just check if we're on their person.
		if(target.loc != user)
			return 1
	else
		if(h_user.l_hand != target && h_user.r_hand != target)//Otherwise let's be special and check if we're in their hands.
			return 1
	return 0

/datum/action/item_action/scope_action/scope_in
	name = ACTION_USE_SCOPE

/datum/action/item_action/scope_action/scope_zoom_up
	name = ACTION_ADJUST_ZOOM_PLUS

/datum/action/item_action/scope_action/scope_zoom_down
	name = ACTION_ADJUST_ZOOM_MINUS

/obj/item/weapon/gun/proc/create_scope_actions(var/create_scope_adjusters)
	for(var/datum/action/a in weapon_actions)
		if(a.owner)
			a.Remove(a.owner)
		weapon_actions -= a
		qdel(a)
	weapon_actions += new /datum/action/item_action/scope_action/scope_in (src)
	if(create_scope_adjusters)
		weapon_actions += new /datum/action/item_action/scope_action/scope_zoom_down (src)
		weapon_actions += new /datum/action/item_action/scope_action/scope_zoom_up (src)

/obj/item/weapon/gun/proc/grant_scope_actions(var/mob/living/user)
	for(var/datum/action/a in weapon_actions)
		a.Grant(user)

/obj/item/weapon/gun/equipped(var/mob/living/user)
	. = ..()
	if(!istype(user))
		return
	var/mob/living/carbon/human/h_user = user
	if(!istype(h_user))
		//No special checks, let's just assign these actions
		grant_scope_actions(user)
	else
		if(h_user.l_hand == src || h_user.r_hand == src)
			grant_scope_actions(user)

/obj/item/weapon/gun/ui_action_click(var/action_name)
	if(!action_name)
		. = ..()
	var/mob/living/user = loc
	if(!istype(user))
		return
	switch(action_name)
		if(ACTION_USE_SCOPE)
			toggle_scope(user,scope_zoom_amount)
		if(ACTION_ADJUST_ZOOM_PLUS)
			increase_decrease_zoom_amt(1,user)
		if(ACTION_ADJUST_ZOOM_MINUS)
			increase_decrease_zoom_amt(0,user)

#undef ACTION_USE_SCOPE
#undef ACTION_ADJUST_ZOOM_PLUS
#undef ACTION_ADJUST_ZOOM_MINUS
#undef EASYMODIFY_SCOPE_ZOOM_VERB_INCREMENT