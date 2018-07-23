/obj/item/organ/internal/brain/adherent
	name = "mentality matrix"
	desc = "The self-contained, self-supporting internal 'brain' of an Adherent unit."
	icon = 'icons/mob/human_races/species/adherent/organs.dmi'
	icon_state = "brain"
	action_button_name = "Reset Ident"

/obj/item/organ/internal/brain/adherent/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "adherent-brain"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/internal/brain/adherent/attack_self(var/mob/user)
	. = ..()
	if(. && istype(species, /datum/species/adherent))
		var/datum/species/adherent/adherents = species
		adherents.sync_ident_to_role(owner)
		to_chat(owner, "<span class='notice'>You are now designated <b>[owner.real_name]</b>.</span>")

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
	if(active && owner.floatiness <= 5)
		owner.make_floating(5)

/obj/item/organ/internal/eyes/adherent
	name = "receptor prism"
	icon = 'icons/mob/human_races/species/adherent/organs.dmi'
	icon_state = "eyes"
	status = ORGAN_ROBOTIC

/obj/item/organ/internal/cell/adherent
	name = "piezoelectric core"
	icon = 'icons/mob/human_races/species/adherent/organs.dmi'
	icon_state = "cell"