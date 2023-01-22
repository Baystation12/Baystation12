#define PROTOCOL_ARTICLE "Protocol article [rand(100,999)]-[uppertext(pick(GLOB.full_alphabet))] subsection #[rand(10,99)]"

/obj/item/organ/internal/brain/adherent
	name = "mentality matrix"
	desc = "The self-contained, self-supporting internal 'brain' of an Adherent unit."
	icon = 'icons/mob/human_races/species/adherent/organs.dmi'
	icon_state = "brain"
	action_button_name = "Reset Ident"
	var/next_rename
	var/rename_delay = 15 MINUTES

/obj/item/organ/internal/brain/adherent/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "adherent-brain"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/internal/brain/adherent/attack_self(var/mob/user)
	. = ..()
	if(.)

		var/regex/name_regex = regex("\[A-Z\]{2}-\[A-Z\]{1} \[0-9\]{4}")
		name_regex.Find_char(owner.real_name)

		if(world.time < next_rename)
			to_chat(owner, "<span class='warning'>[PROTOCOL_ARTICLE] forbids changing your ident again so soon.</span>")
			return

		var/res = name_regex.match
		if(isnull(res))
			to_chat(user, "<span class='warning'>Nonstandard names are not subject to real-time modification under [PROTOCOL_ARTICLE].</span>")
			return

		var/newname = sanitizeSafe(input(user, "Enter a new ident.", "Reset Ident") as text, MAX_NAME_LEN)
		if(newname)
			var/confirm = input(user, "Are you sure you wish your name to become [newname] [res]?","Reset Ident") as anything in list("No", "Yes")
			if(confirm == "Yes" && owner && user == owner && !owner.incapacitated() && world.time >= next_rename)
				next_rename = world.time + rename_delay
				owner.real_name = "[newname] [res]"
				if(owner.mind)
					owner.mind.name = owner.real_name
				owner.SetName(owner.real_name)
				to_chat(user, "<span class='notice'>You are now designated <b>[owner.real_name]</b>.</span>")

/obj/item/organ/internal/powered
	icon = 'icons/mob/human_races/species/adherent/organs.dmi'
	var/maintenance_cost = 1
	var/base_action_state
	var/active = FALSE
	var/use_descriptor

/obj/item/organ/internal/powered/Process()
	. = ..()
	if(owner)
		var/obj/item/organ/internal/cell/cell = locate() in owner.internal_organs
		if(active && !(cell && cell.use(maintenance_cost)))
			active = FALSE
			to_chat(owner, "<span class='danger'>Your [name] [gender == PLURAL ? "are" : "is"] out of power!</span>")
			refresh_action_button()

/obj/item/organ/internal/powered/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "[base_action_state]-[active ? "on" : "off"]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/internal/powered/attack_self(var/mob/user)
	. = ..()
	if(.)
		sound_to(user, sound('sound/effects/ding2.ogg'))
		if(is_broken())
			to_chat(owner, "<span class='warning'>\The [src] [gender == PLURAL ? "are" : "is"] too damaged to function.</span>")
			active = FALSE
		else
			active = !active
			to_chat(owner, "<span class='notice'>You are [active ? "now" : "no longer"] using your [name] to [use_descriptor].</span>")
		refresh_action_button()

/obj/item/organ/internal/powered/jets
	name = "maneuvering jets"
	desc = "Gas jets from a Adherent chassis."
	action_button_name = "Toggle Maneuvering Pack"
	use_descriptor = "adjust your vector"
	organ_tag = BP_JETS
	parent_organ = BP_CHEST
	gender = PLURAL
	icon_state = "jets"
	base_action_state = "adherent-pack"
	maintenance_cost = 2

/obj/item/organ/internal/powered/float
	name = "levitation plate"
	desc = "A broad, flat disc of exotic matter. Slick to the touch."
	action_button_name = "Toggle Antigravity"
	organ_tag = BP_FLOAT
	parent_organ = BP_GROIN
	icon_state = "float"
	use_descriptor = "hover"
	base_action_state = "adherent-float"

/obj/item/organ/internal/powered/float/Process()
	. = ..()
	if(owner)
		if(active)
			owner.pass_flags |= PASS_FLAG_TABLE
			if(owner.floatiness <= 5)
				owner.make_floating(5)
		else
			owner.pass_flags &= ~PASS_FLAG_TABLE

/obj/item/organ/internal/eyes/adherent
	name = "receptor prism"
	icon = 'icons/mob/human_races/species/adherent/organs.dmi'
	eye_icon = 'icons/mob/human_races/species/adherent/eyes.dmi'
	icon_state = "eyes"
	status = ORGAN_ROBOTIC
	phoron_guard = TRUE
	innate_flash_protection = FLASH_PROTECTION_MAJOR

/obj/item/organ/internal/eyes/adherent/Initialize()
	. = ..()
	verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color

/obj/item/organ/internal/cell/adherent
	name = "piezoelectric core"
	icon = 'icons/mob/human_races/species/adherent/organs.dmi'
	icon_state = "cell"

/obj/item/organ/internal/powered/cooling_fins
	name = "cooling fins"
	gender = PLURAL
	desc = "A lacy filligree of heat-radiating fins."
	action_button_name = "Toggle Cooling"
	organ_tag = BP_COOLING_FINS
	parent_organ = BP_GROIN
	icon_state = "fins"
	maintenance_cost = 0
	use_descriptor = "radiate heat"
	base_action_state = "adherent-fins"
	var/max_cooling = 10
	var/target_temp = T20C

/obj/item/organ/internal/powered/cooling_fins/Process()
	if(owner)
		var/temp_diff = min(owner.bodytemperature - target_temp, max_cooling)
		if(temp_diff >= 1)
			maintenance_cost = max(temp_diff, 1)
			. = ..()
			if(active)
				owner.bodytemperature -= temp_diff
		else
			maintenance_cost = 0
	else
		. = ..()

#undef PROTOCOL_ARTICLE