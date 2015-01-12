#define MAP_CELL ((y-1)*real_size)+x
#define MAP_CENTRE (((y-1)+size/2)*real_size)+(x+size/2)
#define MAP_TOP_LEFT ((y-1)*real_size)+x
#define MAP_TOP_RIGHT ((y-1)*real_size)+(x+size)
#define MAP_BOTTOM_LEFT (((y+size)-1)*real_size)+x
#define MAP_BOTTOM_RIGHT ((((y+size)-1)*real_size)+(x+size))
#define MAP_MID_TOP MAP_TOP_LEFT + (size/2)
#define MAP_MID_BOTTOM MAP_BOTTOM_LEFT + (size/2)
#define MAP_MID_LEFT (((y-1)+size/2)*real_size)+x
#define MAP_MID_RIGHT (((y-1)+size/2)*real_size)+(x+size)
#define ITERATE_BEFORE_FAIL 200