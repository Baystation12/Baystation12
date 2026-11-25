// Shared defines for the tractor rig

/// Contact kinds.
#define TRACTOR_CONTACT_RESOURCE "resource"
#define TRACTOR_CONTACT_HAZARD "hazard"
#define TRACTOR_CONTACT_THREAT "threat"

/// What a hazard does when the claw touches it.
#define TRACTOR_EFFECT_NONE null
/// Knocks one latched item loose.
#define TRACTOR_EFFECT_SHAKE "shake"
/// Drains the capacitors: slows down reel
#define TRACTOR_EFFECT_DRAIN "drain"
/// Snaps the beam: the cast ends and everything latched is lost.
#define TRACTOR_EFFECT_SNAP "snap"
/// Ship threat: the cast ends, everything is lost, and something happens to the ship
#define TRACTOR_EFFECT_THREAT "threat"

/// Session states.
#define TRACTOR_STATE_IDLE "idle"
#define TRACTOR_STATE_DROPPING "dropping"
#define TRACTOR_STATE_REELING "reeling"
#define TRACTOR_STATE_COOLDOWN "cooldown"

/// Playfield size in pixels (20 x 17 tiles with 32 world pixel size).
#define TRACTOR_FIELD_WIDTH 640
#define TRACTOR_FIELD_HEIGHT 544
/// Screen y (from the bottom of the playfield) of the hull's underside, where depth 0 is.
#define TRACTOR_HULL_Y 496
/// Pixels per metre of depth.
#define TRACTOR_PX_PER_M 16
/// Deepest the field goes, in metres.
#define TRACTOR_MAX_DEPTH_M 30
/// Half the claw's hit box, in pixels. Matches the opaque part of the claw sprite. (increase if game is too hard)
#define TRACTOR_CLAW_HALF_WIDTH 12
#define TRACTOR_CLAW_HALF_HEIGHT 10
/// How finely a drop is checked for hits, in deciseconds.
#define TRACTOR_HIT_STEP 0.25
/// Claw drop speed and reel speed, in pixels per decisecond.
#define TRACTOR_DROP_SPEED 6
#define TRACTOR_REEL_SPEED 9
/// Seconds of warning the landing bay gets before a haul materialises.
#define TRACTOR_ARRIVAL_TIME (10 SECONDS)
/// How long the intake hatch takes to open, in deciseconds, before the haul comes through.
#define TRACTOR_INTAKE_OPEN_TIME 9
/// Deciseconds a payload takes per tile to fly from the intake to where it lands.
#define TRACTOR_FLIGHT_TIME_PER_TILE 1.2
/// Deciseconds between one payload launching and the next.
#define TRACTOR_PAYLOAD_STAGGER 4
/// Deciseconds the containment field takes to ripple one tile out from the intake.
#define TRACTOR_FIELD_RIPPLE 0.6
/// Clear floor tiles the landing bay needs before the console will cast.
#define TRACTOR_BAY_MIN_CLEAR 6
/// Fastest the ship can move (in the helm's Gm/h) and still hold a lock. TODO: Actually balance this
#define TRACTOR_MAX_LOCK_SPEED 1

/// What the rig's rotating alarms show.
#define TRACTOR_ALARM_OFF "off"
/// Amber: the claw is out.
#define TRACTOR_ALARM_WORKING "working"
/// Green: a clean catch, or a haul landed.
#define TRACTOR_ALARM_GOOD "good"
/// Blue: a haul is coming aboard through the intake.
#define TRACTOR_ALARM_INBOUND "inbound"
/// Red: the claw hit a hazard, filled up or snapped.
#define TRACTOR_ALARM_DANGER "danger"
/// Red with a klaxon: the claw struck a ship threat.
#define TRACTOR_ALARM_THREAT "threat"

/// Palette shared by the playfield labels and the side panel.
#define TRACTOR_COLOUR_BRIGHT "#5dff92"
#define TRACTOR_COLOUR_MID "#2fb35c"
#define TRACTOR_COLOUR_DIM "#1a6b36"
#define TRACTOR_COLOUR_HOT "#c8ffdb"
#define TRACTOR_COLOUR_AMBER "#ffb000"
#define TRACTOR_COLOUR_THREAT "#ff5a36"
#define TRACTOR_COLOUR_GLASS "#020a05"
/// The landing bay's containment field: the intake's light and the glow on things flying in.
#define TRACTOR_COLOUR_FIELD "#70c8ff"
/// Deciseconds for the radar sweep to cross the field. No effect, it's just visual
#define TRACTOR_SWEEP_TIME 40

/// Plane for everything on the playfield map, so its plane master's filters cover the whole screen.
#define TRACTOR_PLANE 1100

/// Skin ids for the operator's popup window and its controls.
#define TRACTOR_WINDOW "tractorrig"
#define TRACTOR_MAP "tractorrig_map"
#define TRACTOR_PANEL "tractorrig_panel"


/// Modulo that works on non-integers and always returns a value in [0, divisor).
/proc/tractor_rig_mod(value, divisor)
	return value - divisor * floor(value / divisor)
