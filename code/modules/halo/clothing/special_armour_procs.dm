#define SELF_DESTRUCT_EXPLODE_AFTER 15 SECONDS

/obj/item/clothing/suit/armor/special/proc/toggle_eva_mode()
	set name = "Toggle Shield EVA Mode"
	set category = "EVA"

	var/mob/living/toggler = usr
	if(!istype(toggler))
		return

	for (var/datum/armourspecials/shields/s in specials)
		s.toggle_eva_mode(toggler)

/obj/item/clothing/suit/armor/special/proc/verb_self_destruct()
	set name = "Activate Self Destruct"
	set category = "Object"

	if(!istype(usr,/mob/living))
		return
	if(!self_destruct_allowed(usr))
		to_chat(usr,"<span class = 'notice'>You lack the knowledge to do that.</span>")
		return
	self_destruct(usr)

/obj/item/clothing/suit/armor/special/proc/self_destruct_allowed(var/mob/living/carbon/human/m)
	if(istype(m) && (istype(m,/mob/living/carbon/human/spartan) || istype(m.species,/datum/species/spartan)))
		return 1
	return 0

/obj/item/clothing/suit/armor/special/proc/self_destruct(var/mob/living/m)
	var/mob/living/carbon/human/our_mob = loc
	if(m && m.incapacitated())
		to_chat(m,"<span class = 'notice'>You can't do that in your current state.</span>")
		return
	if(!istype(our_mob))
		to_chat(m,"<span class = 'notice'>[src] will not activate self destruct unless it is on a person.</span>")
		return
	var/choice = "Yes"
	if(!isnull(m))
		choice = alert("Are you sure you want to activate the self destruct mechanism? This cannot be stopped and will cause instant death on detonation.","Self Destruct","Yes","No")
	switch (choice)
		if("Yes")
			if(istype(our_mob))
				if(m)
					m.visible_message("<span class = 'danger'>[m.name] arms [our_mob.name]'s self destruct mechanism.</span>")
				canremove = 0
				to_chat(our_mob,"<span class = 'notice'>Your armor locks down as the self-destruct activates.</span>")
				spawn(SELF_DESTRUCT_EXPLODE_AFTER) //I really don't want to add an entirely new variable to all /special armors just to deal with this.
					for(var/mob/living/m_kill in range(1,our_mob.loc))
						if(m_kill == our_mob)
							continue
						m_kill.dust()
					explosion(get_turf(our_mob),1,2,2,7,guaranteed_damage = 77,guaranteed_damage_range = 2)
					our_mob.ghostize()
					our_mob.loc = null
					qdel(our_mob)
		if("No")
			return
#undef SELF_DESTRUCT_EXPLODE_AFTER
