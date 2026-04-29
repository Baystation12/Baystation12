# Profiling!

The Baystation 12 repo includes libraries, tracy.dll and tracy.so, for
profiling the game. It uses [Tracy](https://github.com/wolfpld/tracy), a
frame and sampling profiler, to hunt down performance problems with much more
ease and power than the built-in BYOND profiling tools.

[Here's](https://github.com/ParadiseSS13/byond-tracy) a link to the Github
repo for the BYOND libraries, currently maintained by Paradise.
This fork writes profiling data to disk, which can be replayed back using
rtracy instead of streamed over the network to Tracy, as was in the past.
Now you won't need a huge amount of memory to view long sessions!

## Extra things needed
1. Download the [tracy profiler](https://github.com/wolfpld/tracy/releases).
2. Download [rtracy](https://github.com/Dimach/rtracy/releases).

## How to use
1. Start the game.
2. In the Debug tab, run `Start Profiler`, you'll see the file path it's
   writing to. It's usually in `./data/profiler/`
3. Play the game as normal, data's being collected.
4. Shut the server down once done, or call the `Stop Profiler` verb.
5. Run `rtracy` with one argument, pointing to the file.
    1. There is more arguments for the tool, streaming only a number of frames,
    or skipping a few, detailed in
    [their README](https://github.com/Dimach/rtracy).
6. Start Tracy, and connect! You'll see all the profiling data streamed very
   quickly. Examine away!
