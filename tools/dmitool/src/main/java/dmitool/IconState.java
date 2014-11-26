package dmitool;

import java.util.Arrays;

public class IconState {
    String name;
    int dirs;
    int frames;
    float[] delays;
    Image[] images; // dirs come first
    boolean rewind;
    int loop;
    String hotspot;
    boolean movement;
    
    @Override public IconState clone() {
        IconState is = new IconState(name, dirs, frames, images.clone(), delays==null ? null : delays.clone(), rewind, loop, hotspot, movement);
        is.delays = delays != null ? delays.clone() : null;
        is.rewind = rewind;
        
        return is;
    }

    public IconState(String name, int dirs, int frames, Image[] images, float[] delays, boolean rewind, int loop, String hotspot, boolean movement) {
        if(delays != null) {
            if(Main.STRICT && delays.length != frames) {
                throw new IllegalArgumentException("Delays and frames must be the same length!");
            }
        }
        this.name = name;
        this.dirs = dirs;
        this.frames = frames;
        this.images = images;
        this.rewind = rewind;
        this.loop = loop;
        this.hotspot = hotspot;
        this.delays = delays;
        this.movement = movement;
    }
    void setDelays(float[] delays) {
        this.delays = delays;
    }
    void setRewind(boolean b) {
        rewind = b;
    }
    @Override public boolean equals(Object obj) {
        if(obj == this) return true;
        if(!(obj instanceof IconState)) return false;
        
        IconState is = (IconState)obj;
        
        if(!is.name.equals(name)) return false;
        if(is.dirs != dirs) return false;
        if(is.frames != frames) return false;
        if(!Arrays.equals(images, is.images)) return false;
        if(is.rewind != rewind) return false;
        if(is.loop != loop) return false;
        if(!Arrays.equals(delays, is.delays)) return false;
        if(!(is.hotspot == null ? hotspot == null : is.hotspot.equals(hotspot))) return false;
        if(is.movement != movement) return false;
        
        return true;
    }
    public String infoStr() {
        return "[" + frames + " frame(s), " + dirs + " dir(s)]";
    }
    public String getDescriptorFragment() {
        String s = "";
        String q = "\"";
        String n = "\n";
        s += "state = " + q + name + q + n;
        s += "\tdirs = " + dirs + n;
        s += "\tframes = " + frames + n;
        if(delays != null) {
            s += "\tdelay = " + delayArrayToString(delays) + n;
        }
        if(rewind) {
            s += "\trewind = 1\n";
        }
        if(loop != -1) {
            s += "\tloop = " + loop + n;
        }
        if(hotspot != null) {
            s += "\thotspot = " + hotspot + n;
        }
        if(movement) {
            s += "\tmovement = 1\n";
        }
        return s;
    }
    
    private static String delayArrayToString(float[] d) {
        String s = "";
        for(float f: d) {
            s += ","+f;
        }
        return s.substring(1);
    }
}