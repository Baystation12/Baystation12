#define TICK_LIMIT_RUNNING 80
#define TICK_LIMIT_TO_RUN 78
#define TICK_LIMIT_MC 70
#define TICK_LIMIT_MC_INIT_DEFAULT 98

#define TICK_CHECK ( world.tick_usage > Master.current_ticklimit )
#define CHECK_TICK if TICK_CHECK stoplag()
