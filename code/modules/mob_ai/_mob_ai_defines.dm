#define AI_WANDER		1
#define AI_HOSTILE		2
#define AI_RETALIATE	4
#define AI_COWARD		8

#define flees			(behaviour&AI_COWARD)
#define is_aggressive	(behaviour&(AI_HOSTILE|AI_RETALIATE))
#define is_idle			(stance == HOSTILE_STANCE_IDLE)
#define is_hostile		(behaviour&AI_HOSTILE)
#define retaliates		(behaviour&AI_RETALIATE)
#define wanders			(behaviour&AI_WANDER)
