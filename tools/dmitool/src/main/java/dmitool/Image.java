package dmitool;

import java.io.IOException;
import java.io.OutputStream;

public abstract class Image {
    int w, h;
    
    abstract RGBA getPixel(int x, int y);

    public Image(int w, int h) {
        this.w = w;
        this.h = h;
    }
    
    @Override public boolean equals(Object obj) {
        if(obj == this) return true;
        if(!(obj instanceof Image)) return false;
        
        Image im = (Image) obj;
        
        if(w != im.w || h != im.h) return false;
        
        for(int i=0; i<w; i++) {
            for(int j=0; j<h; j++) {
                if(!getPixel(i, j).equals(im.getPixel(i, j))) return false;
            }
        }
        
        return true;
    }
    
    void dumpToBMP(OutputStream out) throws IOException {
        out.write("BM".getBytes());
        int size = 14 + 40 + w*h*4; // ??
        writeInt(out, size);
        out.write("DMID".getBytes());
        int ptr = 14 + 40; // ??
        writeInt(out, ptr);
        
        // HEADER
        writeInt(out, 40); // size
        writeInt(out, w); // width
        writeInt(out, h); // height
        writeShort(out, (short)1); // color planes
        writeShort(out, (short)32); // bpp
        writeInt(out, 0); // no compression
        writeInt(out, 0); // dummy 0 for size
        writeInt(out, 32); // ppm, horiz
        writeInt(out, 32); // ppm, vert
        writeInt(out, 0); // palette colors
        writeInt(out, 0); // important colors
        
        // IMAGE
        for(int y=h-1; y>=0; y--) {
            for(int x=0; x<w; x++) {
                RGBA px = getPixel(x, y);
                out.write(px.b);
                out.write(px.g);
                out.write(px.r);
                out.write(px.a);
            }
        }
    }
    
    private void writeInt(OutputStream out, int i) throws IOException {
        out.write(i & 0xFF);
        out.write((i>>8) & 0xFF);
        out.write((i>>16) & 0xFF);
        out.write((i>>24) & 0xFF);
    }
    private void writeShort(OutputStream out, short s) throws IOException {
        out.write(s & 0xFF);
        out.write((s>>8) & 0xFF);
    }
}