// ID-lockable firing pin.
/obj/item/firing_pin/id_locked
	name = "id-locked firing pin"
	pin_tag = "idlock"

/obj/item/firing_pin/id_locked/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/card/id))
		if(can_overwrite)
			var/obj/item/weapon/card/id/IDcard = I
			//it's an ID card
			if(IDcard.access.len) //If it has any accesses on it.
				req_access = IDcard.access
				to_chat(user, SPAN_NOTICE("You overwrite the ID requirements on the firing pin with [IDcard]'s."))
			else
				return
	else
		return

/obj/item/firing_pin/id_locked/authorization_check(mob/user)
	if(has_access(req_access, user.GetAccess()))
		return TRUE
	else
		return FALSE

/obj/item/firing_pin/id_locked/security
	name = "security-locked firing pin"
	pin_tag = "secid"
	can_overwrite = FALSE
	req_access = list(access_security)

/obj/item/firing_pin/id_locked/command
	name = "command-locked firing pin"
	pin_tag = "commandid"
	req_access = list(access_bridge)
	can_overwrite = FALSE

/obj/item/firing_pin/id_locked/commanding_officer
	name = "CO-locked firing pin"
	pin_tag = "co"
	req_access = list(access_captain)
	can_overwrite = FALSE

/obj/item/firing_pin/alert_locked
	name = "alert-locked firing pin"
	pin_tag = "alertlock"

/obj/item/firing_pin/alert_locked/authorization_check(mob/user) //Taken from free_fire() in secure.dm. Does this return true/false? I have no idea. I guess it does.
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	return security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level)

/obj/item/firing_pin/dna_locked
	name = "dna-locked firing pin"
	pin_tag = "dnalock"
	var/stored_dna

/obj/item/firing_pin/dna_locked/attack_self(mob/user)
	var/mob/living/carbon/human/newmob = user
	if(stored_dna)
		if(newmob.dna.unique_enzymes != stored_dna)
			to_chat(newmob, SPAN_WARNING("Unauthorized user."))
			return
		else
			to_chat(newmob, SPAN_NOTICE("You clear your DNA print from [src]."))
			stored_dna = null
	if(!stored_dna)
		to_chat(newmob, SPAN_NOTICE("You imprint your DNA onto [src]."))
		stored_dna = newmob.dna.unique_enzymes

/obj/item/firing_pin/dna_locked/authorization_check(mob/user)
	if(user.dna.unique_enzymes != stored_dna)
		return FALSE
	else
		return TRUE



