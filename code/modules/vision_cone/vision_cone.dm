/////////////VISION CONE///////////////
// Vision cone code by Honkertron (for Otuska) and Matt.
// This vision cone code allows for mobs and/or items to blocked out from a players field of vision.
// This code makes use of the "cone of effect" proc created by Lummox, contributed by Jtgibson.
//
// More info on that here:
// http://www.byond.com/forum/?post=195138
///////////////////////////////////////

//Defines.
#define OPPOSITE_DIR(D) turn(D, 180)

/client
	var/list/hidden_atoms = list()
	var/list/hidden_mobs = list()

/proc/cone(atom/center = usr, dir = NORTH, list/list = oview(center))
	for(var/atom/O in list) if(!O.InCone(center, dir)) list -= O
	return list

/atom/proc/InCone(atom/center = usr, dir = NORTH)
	if(get_dist(center, src) == 0 || src == center) return 0
	var/d = get_dir(center, src)

	if(!d || d == dir) return 1
	if(dir & (dir-1))
		return (d & ~dir) ? 0 : 1
	if(!(d & dir)) return 0
	var/dx = abs(x - center.x)
	var/dy = abs(y - center.y)
	if(dx == dy) return 1
	if(dy > dx)
		return (dir & (NORTH|SOUTH)) ? 1 : 0
	return (dir & (EAST|WEST)) ? 1 : 0

/mob/dead/InCone(mob/center = usr, dir = NORTH)
	return

/mob/living/InCone(mob/center = usr, dir = NORTH)
	. = ..()
	for(var/obj/item/grab/G in center)//TG doesn't have the grab item. But if you're porting it and you do then uncomment this.
		if(src == G.affecting)
			return 0
		else
			return .

/mob/proc/update_vision_cone()
	return

/mob/living/update_vision_cone()
	if(!can_have_vision_cone)
		if(vision_cone_overlay != null)
			hide_cone()
		return

	var/delay = 10
	if(src.client)
		var/image/I = null
		for(I in src.client.hidden_atoms)
			I.override = 0
			addtimer(CALLBACK(src, .proc/clear_cone_effect, I), delay)
			delay += 10

		check_fov()
		src.client.hidden_atoms = list()
		src.client.hidden_mobs = list()
		src.vision_cone_overlay.dir = src.dir
		if(vision_cone_overlay.alpha != 0)
			var/mob/living/M
			for(M in cone(src, OPPOSITE_DIR(src.dir), view(10, src)))
				I = image("split", M)
				I.override = 1
				src.client.images += I
				src.client.hidden_atoms += I
				src.client.hidden_mobs += M
				if(src.pulling == M)//If we're pulling them we don't want them to be invisible, too hard to play like that.
					I.override = 0

/mob/living/proc/clear_cone_effect(var/image/I)
	qdel(I)

/mob/living/proc/SetFov(var/n)
	if(!can_have_vision_cone)
		return

	if(!n)
		hide_cone()
	else
		show_cone()

/mob/living/proc/check_fov()
	if(!can_have_vision_cone)
		return

	if(isnull(vision_cone_overlay))
		src.vision_cone_overlay = new /obj/screen/fov()
		src.client.screen |= src.vision_cone_overlay

	if(resting || lying || client.eye != client.mob)
		src.vision_cone_overlay.alpha = 0
		return

	else if(src.vision_cone_overlay != null)
		show_cone()
	else
		hide_cone()

//Making these generic procs so you can call them anywhere.
/mob/living/proc/show_cone()
	if(!can_have_vision_cone)
		return

	if(src.vision_cone_overlay)
		src.vision_cone_overlay.alpha = 255

/mob/living/proc/hide_cone()
	if(src.vision_cone_overlay)
		src.vision_cone_overlay.alpha = 0

/mob/living/set_dir()
	. = ..()
	if(.)
		update_vision_cone()
