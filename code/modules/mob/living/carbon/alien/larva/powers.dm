/mob/living/carbon/alien/larva/verb/attach_host()

	set name = "Attach to host"
	set desc = "Burrow into a victim and begin drinking their blood."
	set category = "Abilities"

	if(!istype(loc, /turf))
		return

	if(stat)
		src << "<span class='danger'>You cannot infest a target in your current state.</span>"
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in view(1,src))
		if(src.Adjacent(H) || !H.lying)
			choices += H

	if(!choices.len)
		src << "<span class='danger'>There are no viable hosts within range.</span>"
		return

	var/mob/living/carbon/human/H = input(src,"Who do you wish to infest?") in null|choices

	if(!H || !src) return

	if(!(src.Adjacent(H)))
		src << "<span class='danger'>They are no longer in range.</span>"
		return

	if(!do_after(src,30))
		return

	if(!H || !src) return

	if(src.stat)
		src << "<span class='danger'>You cannot infest a target in your current state.</span>"
		return

	var/obj/item/weapon/holder/larva/holder = new (loc)
	src.loc = holder
	holder.name = src.name
	var/obj/item/organ/external/E = pick(H.organs)
	E.embed(holder,0,"\The [src] burrows deeply into \the [H]'s [E.name]!")