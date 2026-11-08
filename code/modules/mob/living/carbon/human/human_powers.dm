/****************
 true human verbs
****************/
/mob/living/carbon/human/proc/tie_hair()
	set name = "Tie Hair"
	set desc = "Style your hair."
	set category = "IC"

	if(incapacitated())
		to_chat(src, SPAN_WARNING("You can't mess with your hair right now!"))
		return

	if(head_hair_style)
		var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[head_hair_style]
		var/selected_string
		if(!(hair_style.flags & HAIR_TIEABLE))
			to_chat(src, SPAN_WARNING("Your hair isn't long enough to tie."))
			return
		else
			var/list/datum/sprite_accessory/hair/valid_hairstyles = list()
			for(var/hair_string in GLOB.hair_styles_list)
				var/datum/sprite_accessory/hair/test = GLOB.hair_styles_list[hair_string]
				if(test.flags & HAIR_TIEABLE)
					valid_hairstyles.Add(hair_string)
			selected_string = input("Select a new hairstyle", "Your hairstyle", hair_style) as null|anything in valid_hairstyles
		if(incapacitated())
			to_chat(src, SPAN_WARNING("You can't mess with your hair right now!"))
			return
		else if(selected_string && head_hair_style != selected_string)
			head_hair_style = selected_string
			regenerate_icons()
			visible_message(SPAN_NOTICE("[src] pauses a moment to style their hair."))
		else
			to_chat(src, SPAN_NOTICE("You're already using that style."))

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]")
		to_chat(M, SPAN_CLASS("alium", "You hear a strange, alien voice in your head... <i>[msg]</i>"))
		to_chat(src, SPAN_CLASS("alium", "You channel a message: \"[msg]\" to [M]"))
	return

/mob/living/carbon/human/proc/sample_air()
	set name = "Sample Air"
	set desc = "Flick your tongue to taste the air for scents."
	set category = "Abilities"

	if(incapacitated())
		to_chat(src, SPAN_WARNING("You can't do that right now!"))
		return
	if(!check_has_mouth())
		to_chat(src, SPAN_WARNING("You have no mouth to taste the air with!"))
		return
	if(world.time < next_air_sample)
		to_chat(src, SPAN_WARNING("You need a moment before you can sample the air again."))
		return
	next_air_sample = world.time + 3 SECONDS
	emote("flick")
	addtimer(new Callback(src, PROC_REF(finish_sample_air)), 5)

/mob/living/carbon/human/proc/finish_sample_air()
	if(stat != CONSCIOUS)
		return
	var/list/messages = sample_scents(src)
	if(!length(messages))
		to_chat(src, SPAN_NOTICE("You taste nothing unusual on the air."))
		return
	for(var/message in messages)
		to_chat(src, SPAN_NOTICE(message))

/***********
 diona verbs
***********/
/mob/living/carbon/human/proc/diona_heal_toggle()
	set name = "Toggle Heal"
	set desc = "Turn your innate healing on or off."
	set category = "Abilities"
	var/obj/aura/regenerating/human/aura = locate() in auras
	if(!aura)
		to_chat(src, SPAN_WARNING("You don't possess an innate healing ability."))
		return
	if(!aura.can_toggle())
		to_chat(src, SPAN_WARNING("You can't toggle the healing at this time!"))
		return
	aura.toggle()
	if (aura.innate_heal)
		to_chat(src, SPAN_CLASS("alium", "You are now using nutrients to regenerate."))
	else
		to_chat(src, SPAN_CLASS("alium", "You are no longer using nutrients to regenerate."))

/mob/living/carbon/human/proc/change_colour()
	set category = "Abilities"
	set name = "Change Colour"
	set desc = "Choose the colour of your skin."
	var/new_skin = input(usr, "Choose your new skin colour: ", "Change Colour", skin_color) as null | color
	if (isnull(new_skin))
		return
	var/list/rgb = rgb2num(new_skin)
	change_skin_color(rgb[1], rgb[2], rgb[3])
