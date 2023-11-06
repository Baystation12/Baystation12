/datum/artifact_effect/humanify
	name = "humanify"
	effect_type = EFFECT_ORGANIC
	var/next_act_time = 0

/datum/artifact_effect/humanify/DoEffectTouch(atom/holder)
	replace_limb_or_body(holder)

/datum/artifact_effect/humanify/DoEffectAura()
	var/turf/T = get_turf(holder)
	var/list/mobs = list()
	for (var/mob/living/carbon/C in range(effectrange, T))
		mobs += C

	if (length(mobs))
		replace_limb_or_body(pick(mobs))

/datum/artifact_effect/humanify/DoEffectPulse()
	var/turf/T = get_turf(holder)
	var/list/mobs = list()
	for (var/mob/living/carbon/C in range(effectrange, T))
		mobs += C

	if (length(mobs))
		replace_limb_or_body(pick(mobs))

/datum/artifact_effect/humanify/proc/replace_limb_or_body(mob/living/carbon/human/user)
	if (!ishuman(user))
		return

	if (!user.ckey || !user.client)
		return

	if (next_act_time > world.time)
		return

	next_act_time = world.time + rand(15, 20) SECONDS

	var/mob/living/carbon/human/H = user
	var/weakness = GetAnomalySusceptibility(H)
	if (prob(weakness * 100))
		var/obj/item/organ/external/chest = H.organs_by_name[BP_CHEST]
		if (BP_IS_ROBOTIC(chest))
			H.visible_message(
				SPAN_DANGER("\The [H] freezes up and collapses!"),
				SPAN_DANGER("A strange force lashes out at you, and everything goes black, your mind reeling in a horrible pain!")
			)
			H.Paralyse(20)
			H.make_jittery(100)
			addtimer(new Callback(src, .proc/create_new_human, H), rand(5, 10) SECONDS)
			return

		for (var/obj/item/organ/external/organ in H.organs)
			if (BP_IS_ROBOTIC(organ))
				replace_limb(H, organ)
				break

/datum/artifact_effect/humanify/proc/create_new_human(mob/living/carbon/human/H)
	var/mob/living/carbon/human/new_human = new /mob/living/carbon/human(holder.loc)
	new_human.Paralyse(5)
	new_human.make_jittery(100)

	//Port head appearance
	new_human.facial_hair_color = H.facial_hair_color
	new_human.facial_hair_style = H.facial_hair_style
	new_human.head_hair_style = H.head_hair_style
	new_human.head_hair_color = H.head_hair_color

	//Port body appearance
	new_human.skin_color = H.skin_color


	new_human.SetName(H.name)
	new_human.real_name = H.real_name
	new_human.pronouns = H.pronouns
	new_human.gender = H.gender

	transfer_languages(H, new_human)

	H.update_body()
	H.updatehealth()
	H.UpdateDamageIcon()

	if (H.dna)
		new_human.dna = H.dna.Clone()

	if (H.mind)
		H.mind.transfer_to(new_human)


	H.visible_message(SPAN_DANGER("[SPAN_BOLD("\The [H]")] seizes up, their body twitching one last time before going completely still..."))
	new_human.visible_message(SPAN_DANGER("[SPAN_BOLD("\The [new_human]")] bursts forth from \the [holder], gasping for air!"))
	to_chat(new_human, FONT_LARGE(SPAN_DANGER("The pain suddenly stops, and you feel warm, alive, and with the feeling of a beating heart in your chest...")))
	var/list/victims = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(holder.loc, 5, victims, objs)
	for (var/mob/living/living in victims)
		if (living.client)
			to_chat(living, SPAN_DANGER(FONT_LARGE("\The [holder] emits a blinding flash of light!")))
		living.flash_eyes(FLASH_PROTECTION_MAJOR)
		living.Stun(1)
		living.mod_confused(5)
	playsound(holder, "sound/effects/supermatter.ogg", 100, TRUE)
	H.death()

/datum/artifact_effect/humanify/proc/replace_limb(mob/living/carbon/human/H, obj/item/organ/external/limb)
	set waitfor = FALSE

	H.visible_message(
		SPAN_DANGER("\The [holder] grabs hold of [SPAN_BOLD("\The [H]")]'s [limb.name] with some invisible force and tears it off!"),
		SPAN_DANGER("You feel an invisible energy reach out and tear your [limb.name] from your body!"),
		)

	var/list/children_to_create = list()
	if (limb.children)
		for (var/obj/item/organ/external/child in limb.children)
			children_to_create +=  list(H.species.has_limbs[child.organ_tag])

	limb.droplimb(TRUE, TRUE)
	playsound(H, 'sound/effects/razorweb_break.ogg', 70)
	sleep(6 SECONDS)
	holder.visible_message(SPAN_WARNING("\The [holder] hums with a strange energy as it continues to manipulate [SPAN_BOLD("\The [H]")]'s body..."))
	sleep(6 SECONDS)
	playsound(H, 'sound/effects/squelch2.ogg', 70)
	var/list/organ_data = H.species.has_limbs[limb.organ_tag]
	var/limb_path = organ_data["path"]
	var/obj/item/organ/external/O = new limb_path(H)

	if (children_to_create)
		for (var/list/child_organ_data in children_to_create)
			var/child_limb_path = child_organ_data["path"]
			new child_limb_path(H)

	H.visible_message(
		SPAN_DANGER("[SPAN_BOLD("\The [H]")] suddenly sprouts a new [O.name]!"),
		SPAN_DANGER("You feel a strange energy reach out and attach a new [O.name] to your body, this one feeling much more natural than the last...")
		)

	H.update_body()
	H.updatehealth()
	H.UpdateDamageIcon()
