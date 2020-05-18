/obj/item/weapon/implant/imprinting
	name = "imprinting implant"
	desc = "Latest word in training your peons."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_DATA = 3)
	hidden = 1
	var/list/instructions = list("Do your job.", "Respect your superiors.", "Wash you hands after using the toilet.")
	var/brainwashing = 0

/obj/item/weapon/implant/imprinting/get_data()
	. = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> BB-56 "Educator" Employee Assistance Implant<BR>
	<b>Life:</b> 1 year.<BR>
	<HR>
	<b>Function:</b> Adjusts itself to host's brainwaves, and presents supplied instructions as their 'inner voice' for less intrusive reminding. It will transmit them every 5 minutes in non-obtrusive manner.<BR>
	<b>Special Features:</b> Do NOT implant if subject is under effect of any mind-altering drugs.
	It carries risk of over-tuning, making subject unable to question the suggestions received, treating them as beliefs they feel strongly about.<BR>
	It is HIGLY ILLEGAL and the seller does NOT endorse use of this device in such way.
	Any amount of "Mind-Breaker"(TM) present in bloodstream will trigger this side-effect.<BR>"}
	. += "<HR><B>Instructions:</B><BR>"
	for(var/i = 1 to instructions.len)
		. += "- [instructions[i]] <A href='byond://?src=\ref[src];edit=[i]'>Edit</A> <A href='byond://?src=\ref[src];del=[i]'>Remove</A><br>"
	. += "<A href='byond://?src=\ref[src];add=1'>Add</A>"

/obj/item/weapon/implant/imprinting/Topic(href, href_list)
	..()
	if (href_list["add"])
		var/mod = sanitize(input("Add an instruction", "Instructions") as text|null)
		if(mod)
			instructions += mod
		interact(usr)
	if (href_list["edit"])
		var/idx = text2num(href_list["edit"])
		var/mod = sanitize(input("Edit the instruction", "Instruction Editing", instructions[idx]) as text|null)
		if(mod)
			instructions[idx] = mod
			interact(usr)
	if (href_list["del"])
		instructions -= instructions[text2num(href_list["del"])]
		interact(usr)

/obj/item/weapon/implant/imprinting/implanted(mob/M)
	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return FALSE
	if(H.reagents.has_reagent(/datum/reagent/mindbreaker))
		brainwashing = 1
	var/msg = get_instructions()
	to_chat(M, msg)
	if(M.mind)
		M.StoreMemory(msg, /decl/memory_options/system)
	if(brainwashing)
		log_and_message_admins("was implanted with a brainwashing implant holding following laws: [jointext(instructions, ";")].", M)
	addtimer(CALLBACK(src,.proc/activate),3000,(TIMER_UNIQUE|TIMER_OVERRIDE))
	return TRUE

/obj/item/weapon/implant/imprinting/proc/get_instructions()
	. = list()
	if(brainwashing)
		. += "<span class='danger'>The fog in your head clears, and you remember some important things. You hold following things as deep convictions, almost like synthetics' laws:</span><br>"
	else
		. += "<span class='notice'>You hear an annoying voice in the back of your head. The things it keeps reminding you of:</span><br>"
	for(var/thing in instructions)
		. += "- [thing]<br>"
	. = JOINTEXT(.)

/obj/item/weapon/implant/imprinting/disable(time)
	. = ..()
	if(. && brainwashing)//add deactivate and reactivate messages?
		to_chat(imp_in,"<span class='warning'>A wave of nausea comes over you.</span><br><span class='good'>You are no longer so sure of those beliefs you've had...</span>")

/obj/item/weapon/implant/imprinting/restore()
	. = ..()
	if(. && brainwashing)
		to_chat(imp_in, get_instructions())
		activate()

/obj/item/weapon/implant/imprinting/activate()
	if(malfunction || !implanted || imp_in) return
	var/instruction = pick(instructions)
	if(brainwashing)
		instruction = "<span class='warning'>You recall one of your beliefs: \"[instruction]\"</span>"
	else
		instruction = "<span class='notice'>You remember suddenly: \"[instruction]\"</span>"
	to_chat(imp_in, instruction)
	addtimer(CALLBACK(src,.proc/activate),3000,(TIMER_UNIQUE|TIMER_OVERRIDE))

/obj/item/weapon/implant/imprinting/removed()
	if(brainwashing && !malfunction)
		to_chat(imp_in,"<span class='warning'>A wave of nausea comes over you.</span><br><span class='good'>You are no longer so sure of those beliefs you've had...</span>")
	..()

/obj/item/weapon/implant/imprinting/emp_act(severity)
	var/power = 4 - severity
	if(prob(power * 15))
		meltdown()
	else if(prob(power * 40))
		disable(rand(power*100,power*1000))//a few precious seconds of freedom

/obj/item/weapon/implant/imprinting/meltdown()
	if(brainwashing && !malfunction)//if it's already broken don't send the message again
		to_chat(imp_in,"<span class='warning'>A wave of nausea comes over you.</span><br><span class='good'> You are no longer so sure of those beliefs you've had...</span>")
	. = ..()

/obj/item/weapon/implant/imprinting/can_implant(mob/M, mob/user, target_zone)
	var/mob/living/carbon/human/H = M	
	if(istype(H))
		var/obj/item/organ/internal/B = H.internal_organs_by_name[BP_BRAIN]
		if(!B || H.isSynthetic())
			to_chat(user, "<span class='warning'>\The [M] cannot be imprinted.</span>")
			return FALSE
		if(!(B.parent_organ == check_zone(target_zone)))
			to_chat(user, "<span class='warning'>\The [src] must be implanted in [H.get_organ(B.parent_organ)].</span>")
			return FALSE
	return TRUE

/obj/item/weapon/implanter/imprinting
	name = "imprinting implanter"
	imp = /obj/item/weapon/implant/imprinting

/obj/item/weapon/implantcase/imprinting
	name = "glass case - 'imprinting'"
	imp = /obj/item/weapon/implant/imprinting