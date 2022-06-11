//~KareTa //from infinity //proxima
/obj/screen/ai_button
	var/mob/living/silicon/ai/ai_verb
	var/list/input_procs = list()
	icon = 'proxima/icons/mob/screen_ai.dmi'
	var/list/template_icon = list(null, "template")
	var/image/template_undelay

/obj/screen/ai_button/Click()
	if(!isAI(usr)) return 1
	var/mob/living/silicon/ai/A = usr
	if(!(ai_verb in A.verbs))
		return 1

	var/input_args = list()
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

		input_args += input_arg

	call(A, ai_verb)(arglist(input_args))
	return 1

//~_Elar_
/obj/screen/ai_button/Initialize()
	. = ..()
	template_undelay = image(template_icon[1], template_icon[2])
	underlays += template_undelay
