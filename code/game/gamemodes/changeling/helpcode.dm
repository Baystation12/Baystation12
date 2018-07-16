/mob/living/proc/set_m_intent(var/intent)
	if (intent != "walk" && intent != "run")
		return 0
	m_intent = intent
	if(hud_used)
		if (hud_used.move_intent)
			hud_used.move_intent.icon_state = intent == "walk" ? "walking" : "running"

////////////////No Brain Gen//////////////////////////////////////////////

/obj/item/organ/internal/biostructure
	name = "Strange biostructure"
	desc = "Strange abhorrent biostructure of unknown origins. Is that an alien organ, a xenoparasite or some sort of space cancer? Is that normal to bear things like that inside you?"
	organ_tag = BP_CHANG
	parent_organ = BP_CHEST
	vital = 1
	icon_state = "Strange_biostructure"
	force = 1.0
	w_class = ITEM_SIZE_SMALL
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 10, TECH_ILLEGAL = 5)
	attack_verb = list("attacked", "slapped", "whacked")
	relative_size = 10
	var/mob/living/carbon/brain/brainchan = null
	var/const/damage_threshold_count = 10
	var/damage_threshold_value
	var/healed_threshold = 1


/obj/item/organ/internal/biostructure/New(var/mob/living/carbon/holder)
	..()
	max_damage = 600
//	if(species)
//		max_damage = species.total_health
	min_bruised_damage = max_damage*0.25
	min_broken_damage = max_damage*0.75

	damage_threshold_value = round(max_damage / damage_threshold_count)
	spawn(5)
		if(brainchan && brainchan.client)
			brainchan.client.screen.len = null //clear the hud



/obj/item/organ/internal/biostructure/Destroy()
	QDEL_NULL(brainchan)
	. = ..()

/obj/item/organ/internal/biostructure/proc/transfer_identity(var/mob/living/carbon/H)
	if(status & ORGAN_DEAD) return

	if(!brainchan)
		brainchan = new(src)
		brainchan.SetName(H.real_name)
		brainchan.real_name = H.real_name
		brainchan.dna = H.dna.Clone()
		brainchan.timeofhostdeath = H.timeofdeath

	if(H.mind)
		H.mind.transfer_to(brainchan)

	to_chat(brainchan, "<span class='notice'>You feel slightly disoriented. That's normal.</span>")
	callHook("debrain", list(brainchan))



/obj/item/organ/internal/biostructure/removed(var/mob/living/user)
	if(!istype(owner))
		return ..()

	if(vital)
		transfer_identity(owner)

	..()

/obj/item/organ/internal/biostructure/replaced(var/mob/living/target)

	if(!..()) return 0

	if(target.key)
		target.ghostize()

	if(brainchan)
		if(brainchan.mind)
			brainchan.mind.transfer_to(target)
		else
			target.key = brainchan.key

	return 1

/obj/item/organ/internal/biostructure/Process()
	..()
	if(owner)
		if(damage > max_damage / 2 && healed_threshold)
			spawn()
				alert(owner, "You have taken massive core damage! You need regeneration.", "Core Damaged")
			healed_threshold = 0
		if(damage <= max_damage / 2 && healed_threshold)
			while(owner && damage > 0 && owner.mind && owner.mind.changeling)
				owner.mind.changeling.chem_charges = max(owner.mind.changeling.chem_charges - 0.5, 0)
				damage--
				sleep(40)
			healed_threshold = 1

/obj/item/organ/internal/biostructure/die()
	QDEL_NULL(brainchan)
	owner.mind.changeling.true_dead = 1
	..()