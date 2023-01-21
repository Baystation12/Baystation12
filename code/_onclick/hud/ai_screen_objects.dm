/obj/screen/ai_button
	var/mob/living/silicon/ai/ai_verb
	var/list/input_procs
	var/list/input_args
	icon = 'icons/mob/screen_ai.dmi'
	var/list/template_icon = list(null, "template")
	var/image/template_undelay

/obj/screen/ai_button/Click()
	if(!isAI(usr))
		return TRUE
	var/mob/living/silicon/ai/A = usr
	if(!(ai_verb in A.verbs))
		return TRUE

	var/input_arguments = list()
	for(var/input_proc in input_procs)
		var/input_flags = input_procs[input_proc]
		var/input_arg
		if(input_flags & AI_BUTTON_PROC_BELONGS_TO_CALLER) // Does the called proc belong to the AI, or not?
			input_arg = call(A, input_proc)()
		else
			input_arg= call(input_proc)()

		if(input_flags & AI_BUTTON_INPUT_REQUIRES_SELECTION)
			input_arg = input("Make a selection.", "Make a selection.") as null|anything in input_arg
			if(!input_arg)
				return // We assume a null-input means the user cancelled

		if(!(ai_verb in A.verbs) || A.incapacitated())
			return

		input_arguments += input_arg

	if(length(input_args))
		input_arguments |= input_args

	call(A, ai_verb)(arglist(input_arguments))
	return TRUE

/obj/screen/ai_button/Initialize(maploading, screen_loc, name, icon_state, ai_verb, list/input_procs = null, list/input_args = null)
	. = ..()
	if(!LAZYLEN(template_icon))
		template_icon = list(icon)

	src.name = name
	src.icon_state = icon_state
	src.screen_loc = screen_loc
	src.ai_verb = ai_verb
	if(input_procs)
		src.input_procs = input_procs.Copy()
	if(input_args)
		src.input_args = input_args.Copy()

	template_undelay = image(template_icon[1], template_icon[2])
	underlays += template_undelay
