/* *
* Renderers
* Renderers are virtual objects that act as draw groups of things, including
* other Renderers. Renderers are similar to older uses of PLANE_MASTER but
* employ render targets using the "*" slate prefix to draw off-screen, to be
* composited in a controlled and flexible order and in some cases, reuse for
* visual effects.
*/

/// The base /renderer definition and defaults.
/atom/movable/renderer
	abstract_type = /atom/movable/renderer
	appearance_flags = PLANE_MASTER
	screen_loc = "CENTER"
	plane = LOWEST_PLANE
	blend_mode = BLEND_OVERLAY

	/// The compositing renderer this renderer belongs to.
	var/group = RENDER_GROUP_FINAL

	/// The relay movable used to composite this renderer to its group.
	var/atom/movable/relay // Also see https://secure.byond.com/forum/?post=2141928 maybe.

	/// Optional blend mode override for the renderer's composition relay.
	var/relay_blend_mode

	/// If text, uses the text or, if TRUE, uses "*AUTO-[name]"
	var/render_target_name = TRUE

	var/mob/owner = null


/atom/movable/renderer/Destroy()
	owner = null
	QDEL_NULL(relay)
	return ..()


INITIALIZE_IMMEDIATE(/atom/movable/renderer)


/atom/movable/renderer/Initialize(mapload, mob/owner)
	. = ..()
	if (. == INITIALIZE_HINT_QDEL)
		return
	src.owner = owner
	if (isnull(group))
		if (istext(render_target_name))
			render_target = render_target_name
		return
	if (istext(render_target_name))
		render_target = render_target_name
	else if (render_target_name)
		render_target = "*[ckey(name)]"
	relay = new
	relay.screen_loc = "CENTER"
	relay.appearance_flags = PASS_MOUSE | NO_CLIENT_COLOR | KEEP_TOGETHER
	relay.name = "[render_target] relay"
	relay.mouse_opacity = mouse_opacity
	relay.render_source = render_target
	relay.layer = (plane + abs(LOWEST_PLANE)) * 0.5
	relay.plane = group
	if (isnull(relay_blend_mode))
		relay.blend_mode = blend_mode
	else
		relay.blend_mode = relay_blend_mode

/**
* Graphic preferences
*
* Some renderers may be able to use a graphic preference to determine how to display effects. For example reduce particle counts or filter variables.
*/
/atom/movable/renderer/proc/GraphicsUpdate()
	return


/**
* Renderers on /mob
* We attach renderers to mobs for their lifespan. Only mobs with clients get
* renderers, and they are removed again when the mob loses its client. Mobs
* get their own unique renderer instances but it would not be inconceivable
* to share them globally.
*/

/// The list of renderers associated with this mob.
/mob/var/list/atom/movable/renderer/renderers


/// Creates the mob's renderers on /Login()
/mob/proc/CreateRenderers()
	if (!renderers)
		renderers = list()
	for (var/atom/movable/renderer/renderer as anything in subtypesof(/atom/movable/renderer))
		renderer = new renderer (null, src)
		renderers[renderer] = renderer.plane // (renderer = plane) format for visual debugging
		if (renderer.relay)
			my_client.screen += renderer.relay
		my_client.screen += renderer


/// Removes the mob's renderers on /Logout()
/mob/proc/RemoveRenderers()
	for(var/atom/movable/renderer/renderer as anything in renderers)
		my_client.screen -= renderer
		if (renderer.relay)
			my_client.screen -= renderer.relay
		qdel(renderer)
	if (renderers)
		renderers.Cut()


/* *
* Plane Renderers
* We treat some renderers as planes with layers. When some atom has the same plane
* as a Plane Renderer, it is drawn by that renderer. The layer of the atom determines
* its draw order within the scope of the renderer. The draw order of same-layered things
* is probably by atom contents order, but can be assumed not to matter - if it's out of
* order, it should have a more appropriate layer value.
* Higher plane values are composited over lower. Here, they are ordered from under to over.
*/

 /// Handles byond internal letterboxing. Avoid touching.
/atom/movable/renderer/letterbox
	name = "Letterbox"
	group = RENDER_GROUP_SCENE
	plane = BLACKNESS_PLANE
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	blend_mode = BLEND_MULTIPLY
	color = list(null, null, null, "#0000", "#000f")
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE


// Draws the game world; live mobs, items, turfs, etc.
/atom/movable/renderer/game
	name = "Game"
	group = RENDER_GROUP_SCENE
	plane = DEFAULT_PLANE


/// Draws observers; ghosts, camera eyes, etc.
/atom/movable/renderer/observers
	name = "Observers"
	group = RENDER_GROUP_SCENE
	plane = OBSERVER_PLANE


/// Draws darkness effects.
/atom/movable/renderer/lighting
	name = "Lighting"
	group = RENDER_GROUP_SCENE
	plane = LIGHTING_PLANE
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	relay_blend_mode = BLEND_MULTIPLY
	color = list(
		-1,  0,  0,  0, // R
		 0, -1,  0,  0, // G
		 0,  0, -1,  0, // B
		 0,  0,  0,  0, // A
		 1,  1,  1,  1  // Mapping
	)
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE


/// Draws visuals that should not be affected by darkness.
/atom/movable/renderer/above_lighting
	name = "Above Lighting"
	group = RENDER_GROUP_SCENE
	plane = EFFECTS_ABOVE_LIGHTING_PLANE


/// Draws full screen visual effects, like pain and bluespace.
/atom/movable/renderer/screen_effects
	name = "Screen Effects"
	group = RENDER_GROUP_SCENE
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE


/// Draws user interface elements.
/atom/movable/renderer/interface
	name = "Interface"
	group = RENDER_GROUP_SCREEN
	plane = HUD_PLANE


/* *
* Group renderers
* We treat some renderers as render groups that other renderers subscribe to. Renderers
* subscribe themselves to groups by setting a group value equal to the plane of a Group
* Renderer. This value is used for the Renderer's relay to include it into the Group, and
* the Renderer's plane is used as the relay's layer.
* Group renderers can subscribe themselves to other Group Renderers. This allows for more
* granular manipulation of how the final scene is composed.
*/

/// Render group for stuff INSIDE the typical game context - people, items, lighting, etc.
/atom/movable/renderer/scene_group
	name = "Scene Group"
	group = RENDER_GROUP_FINAL
	plane = RENDER_GROUP_SCENE


/// Render group for stuff OUTSIDE the typical game context - UI, full screen effects, etc.
/atom/movable/renderer/screen_group
	name = "Screen Group"
	group = RENDER_GROUP_FINAL
	plane = RENDER_GROUP_SCREEN


/// Render group for final compositing before user display.
/atom/movable/renderer/final_group
	name = "Final Group"
	group = RENDER_GROUP_NONE
	plane = RENDER_GROUP_FINAL


/* *
* Effect Renderers
* Some renderers are used to produce complex screen effects. These are drawn using filters
* rather than composition groups, and may be added to another renderer in the following
* fashion. Setting a render_target_name with no group is the expected patter for Effect
* Renderers as it allows them to draw to a slate that will be empty unless a relevant
* behavior, such as the effect atom below, causes them to be noticeable.
*/


/// Renders the /obj/effect/effect/warp example effect as well as gravity catapult effects
/atom/movable/renderer/warp
	name = "Warp Effect"
	group = RENDER_GROUP_NONE
	plane = WARP_EFFECT_PLANE
	render_target_name = "*warp"
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

//Similar to warp but not as strong
/atom/movable/renderer/heat
	name = "Heat Effect"
	group = RENDER_GROUP_NONE
	plane = HEAT_EFFECT_PLANE
	render_target_name = HEAT_COMPOSITE_TARGET
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

	var/obj/gas_heat_object = null

/atom/movable/renderer/heat/proc/Setup()
	var/mob/M = owner

	if(istype(M))
		var/quality = M.get_preference_value(/datum/client_preference/graphics_quality)

		if(gas_heat_object)
			vis_contents -= gas_heat_object

		if (quality == GLOB.PREF_LOW)
			if(!istype(gas_heat_object, /obj/effect/heat))
				QDEL_NULL(gas_heat_object)
				gas_heat_object = new /obj/effect/heat(null)
		else
			if(!istype(gas_heat_object, /obj/particle_emitter/heat))
				QDEL_NULL(gas_heat_object)
				gas_heat_object = new /obj/particle_emitter/heat(null, -1)
			if (quality == GLOB.PREF_MED)
				gas_heat_object.particles?.count = 250
				gas_heat_object.particles?.spawning = 15
			else if (quality == GLOB.PREF_HIGH)
				gas_heat_object.particles?.count = 600
				gas_heat_object.particles?.spawning = 35

		vis_contents += gas_heat_object

/atom/movable/renderer/heat/Initialize()
	. = ..()
	Setup()

/atom/movable/renderer/heat/GraphicsUpdate()
	. = ..()
	Setup()

/atom/movable/renderer/scene_group/Initialize()
	. = ..()
	filters += filter(type = "displace", render_source = "*warp", size = 5)
	filters += filter(type = "displace", render_source = HEAT_COMPOSITE_TARGET, size = 2.5)

/// Example of a warp filter for /renderer use
/obj/effect/effect/warp
	plane = WARP_EFFECT_PLANE
	appearance_flags = PIXEL_SCALE
	icon = 'icons/effects/352x352.dmi'
	icon_state = "singularity_s11"
	pixel_x = -176
	pixel_y = -176
	no_z_overlay = TRUE
