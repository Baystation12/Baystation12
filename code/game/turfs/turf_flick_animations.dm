/turf/proc/turf_animation(var/anim_icon,var/anim_state,var/anim_x=0, var/anim_y=0, var/anim_layer=MOB_LAYER+1, var/anim_sound=null, var/anim_color=null)
	if(!c_animation)//spamming turf animations can have unintended effects, such as the overlays never disapearing. hence this check.
		if(anim_sound)
			playsound(src, anim_sound, 50, 1)
		c_animation = PoolOrNew(/atom/movable/overlay, src)
		c_animation.name = "turf_animation"
		c_animation.density = 0
		c_animation.anchored = 1
		c_animation.icon = anim_icon
		c_animation.icon_state = anim_state
		c_animation.layer = anim_layer
		c_animation.master = src
		c_animation.pixel_x = anim_x
		c_animation.pixel_y = anim_y
		if(anim_color)
			c_animation.color = anim_color
		flick("turf_animation",c_animation)
		spawn(10)
			if(c_animation)
				PlaceInPool(c_animation)
				c_animation = null
