
/obj/item/conversion_contract
	name = "Conversion Contract"
	desc = "Converts the person you slap with this."
	icon = 'code/modules/halo/misc/convert_contract.dmi'
	icon_state = "neutral_contract"

	var/primed = 0
	var/mob/curr_target
	var/faction_to = "neutral" //To convert to

	var/list/lines = list(\
	"What makes a man neutral?",\
	"Was he just born",\
	"With a heart full of neutrality?"\
	)

/obj/item/conversion_contract/proc/check_convert(var/mob/user,var/mob/target)

	if(!primed)
		return 0

	if(!user.ckey || !target.ckey)
		to_chat(user,"<span class = 'notice'>They seem too lifeless to convert.</span>")
		return 0

	if(target.stat != CONSCIOUS || user.stat != CONSCIOUS)
		to_chat(user,"<span class = 'notice'>You and your target need to be conscious to do that!</span>")
		return 0

	if(user.faction != faction_to)
		to_chat(user,"<span class = 'notice'>You can't convert someone to a faction that isn't yours!</span>")
		return 0

	if(target.faction == faction_to)
		to_chat(user,"<span class = 'notice'>Converting this person would have no effect!</span>")
		return 0
	if(!(target in view(5,user)))
		to_chat(user,"<span class = 'notice'>You can't convert someone out of your sight!</span>")
		return 0

	return 1

/obj/item/conversion_contract/proc/convert_fail_message(var/mob/target)
	target.visible_message("<span class = 'notice'>[target.name] looks away from [src] and shakes their head, staying silent.</span>")

/obj/item/conversion_contract/proc/try_convert(var/mob/living/user,var/mob/living/target)
	if(!check_convert(user,target))
		return
	curr_target = target
	log_admin("[user.name],([user.ckey]) is attempting to convert [target.name] ([target.ckey])")
	to_chat(target,"<span class = 'notice'>[user.name] is attempting to convert you. You are under no obligation to accept.</span>")
	var/mob/living/carbon/human/h_user = user
	if(istype(h_user))
		h_user.forcesay("Repeat after me:")
	else
		user.say("Repeat after me.")
	for(var/line in lines)
		if(istype(h_user))
			h_user.forcesay(line)
		else
			user.say(line)
		var/will_say = alert("Repeat the line?",,"Yes","No")
		if(will_say == "No")
			convert_fail_message(target)
			curr_target = null
			return
		var/mob/living/carbon/human/h_target = target
		if(istype(h_target))
			h_target.forcesay(line)
		else
			target.say(line)
	do_convert(target)

/obj/item/conversion_contract/proc/do_convert(var/mob/target)
	target.faction = faction_to
	log_admin("[target.name] ([target.ckey]), has been successfully converted, faction changed to [faction_to]")

/obj/item/conversion_contract/attack_self(var/mob/user)
	if(..())
		primed = !primed
		curr_target = null
		to_chat(user,"<span class = 'notice'>You [primed ? "ready":"unready" ] [src] for easy reading and conversion...</span>")

/obj/item/conversion_contract/attack(var/mob/living/carbon/target, var/mob/living/carbon/user)
	if(primed)
		if(curr_target)
			to_chat(user,"<span class = 'notice'>You're already converting someone</span>")
		else
			try_convert(user,target)
	else
		. = ..()


/obj/item/conversion_contract/unsc
	faction_to = "UNSC"
	lines = list(\
	"I do solemnly swear my loyalty and my life to Earth and her colonies.",\
	"I swear that I will only obey legitimate authority",\
	"And that my actions shall be weighed for the greater good of humanity."
	)

/obj/item/conversion_contract/innie
	faction_to = "Insurrection"
	lines = list(\
	"I do solemnly swear my life to the cause of freedom.",\
	"I vow that I will not stop fighting, I will fight for the freedom of all colonies, I will fight for free men.",\
	"I will lay down my life to stop the tyranny of the UNSC.",\
	"Long live freedom. Sic semper tyrannis."
	)

/obj/item/conversion_contract/cov
	faction_to = "Covenant"
	lines = list(\
	"I devote myself to further the Great Journey in any capacity even to my last dying breath.",\
	"I devote myself amongst trillions of souls to aid in life’s true goal: the Great Journey.",\
	"In exchange for my service, my undying loyalty, and my devotion to the cause, I will be granted repentance and a place in the Great Journey.",\
	"On swearing of this pledge, I will be protected from all previous transgressions coming from my past."
	)
