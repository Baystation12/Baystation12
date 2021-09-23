/obj/item/organ/internal/augment/active/hud
	name = "integrated HUD"
	desc = "A small implantable heads-up display."
	icon_state = "eye"
	action_button_name = "Toggle HUD"
	augment_slots = AUGMENT_HEAD
	var/list/hud_type = list(HUD_MEDICAL, HUD_SECURITY)
	var/active = FALSE


/obj/item/organ/internal/augment/active/hud/Process()
	..()
	if (!owner)
		return

	if (active)
		switch(hud_type)
			if (HUD_MEDICAL)
				req_access = list(access_medical)
				if (allowed(owner))
					process_med_hud(owner, 1)
			if (HUD_SECURITY)
				req_access = list(access_security)
				if (allowed(owner))
					process_sec_hud(owner, 1)
			if (HUD_JANITOR)
				process_jani_hud(owner)


/obj/item/organ/internal/augment/active/hud/emp_act(severity)
	if (istype(src.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = src.loc
		to_chat(M, SPAN_DANGER("Your [name] malfunctions, blinding you!"))
		M.eye_blind = 4
		M.eye_blurry = 8
		take_general_damage(rand(5, 15))
		if (active)
			active = FALSE


/obj/item/organ/internal/augment/active/hud/activate()
	if (!can_activate())
		return
	active = !active
	to_chat(owner, SPAN_NOTICE("You [active ? "enable" : "disable"] \the [src]."))


/obj/item/organ/internal/augment/active/hud/health
	name = "integrated health HUD"
	desc = "The Vey-Med H-27 is an implantable HUD, designed to interface with the user's optic nerve and display information about patient vitals."
	icon_state = "eye_medical"
	hud_type = HUD_MEDICAL


/obj/item/organ/internal/augment/active/hud/security
	name = "integrated security HUD"
	desc = "The Hephaestus Industries C-VSR is an implantable HUD, designed to interface with the user's optic nerve and local databases to display security information."
	hud_type = HUD_SECURITY


/obj/item/organ/internal/augment/active/hud/janitor
	name = "integrated filth HUD"
	desc = "An implantable HUD based on the wearable janitorial version, designed to interface with the user's optic nerve and display information about nearby messes."
	icon_state = "eye_janitor"
	hud_type = HUD_JANITOR


/obj/item/organ/internal/augment/active/hud/science
	name = "integrated sciHUD"
	desc = "An implantable HUD fitted with a portable analyzer capable of determining the research potential of a visible item or the components of a machine."
	icon_state = "eye_science"
	hud_type = HUD_SCIENCE
