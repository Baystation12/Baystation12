package dmitool;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Set;

public class Main {
    public static int VERBOSITY = 0;
    public static boolean STRICT = false;
    
    public static final String[] dirs = new String[] {
        "S", "N", "E", "W", "SE", "SW", "NE", "NW"
    };
    
    public static final String helpStr =
            "help\n" +
            "\tthis text\n" +
            
            "verify [file]\n" +
            "\tattempt to load the given file to check format\n" +
            
            "diff [file1] [file2]\n" +
            "\tdiff between [file1] and [file2]\n" +
            
            "sort [file]\n" +
            "\tsort the icon_states in [file] into ASCIIbetical order\n" +
            
            "merge [base] [file1] [file2] [out]\n" +
            "\tmerge [file1] and [file2]'s changes from a common ancestor [base], saving the result in [out]\n" +
            "\tconflicts will be placed in [out].conflict.dmi\n" +
            
            "extract [file] [state] [out] {args}\n"+
            "\textract [state] from [file] in PNG format to [out]\n" +
            "\targs specify direction and frame; input 'f' followed by a frame specifier, and/or 'd' followed by a direction specifier\n" +
            "\tframe specifier can be a single number or number-number for a range\n" +
            "\tdirection specifier can be a single direction, or direction-direction\n" +
            "\tdirection can be 0-7 or S, N, E, W, SE, SW, NE, NW (non-case-sensitive)\n" +
            
            "";
    
    public static void main(String[] args) throws FileNotFoundException, IOException, DMIException {
        Deque<String> argq = new ArrayDeque<>();
        for(String s: args) {
            argq.addLast(s);
        }
        if(argq.size() == 0) {
            System.out.println("No command found; use 'help' for help");
            return;
        }
        String switches = argq.peekFirst();
        if(switches.startsWith("-")) {
            for(char c: switches.substring(1).toCharArray()) {
                switch(c) {
                    case 'v': VERBOSITY++; break;
                    case 'q': VERBOSITY--; break;
                    case 'S': STRICT = true; break;
                }
            }
            argq.pollFirst();
        }
        String op = argq.pollFirst();
        
        switch(op) {
            case "diff":
                if(argq.size() < 2) {
                    System.out.println("Insufficient arguments for command!");
                    System.out.println(helpStr);
                    return;
                }
                String a = argq.pollFirst();
                String b = argq.pollFirst();
                
                if(VERBOSITY >= 0) System.out.println("Loading " + a);
                DMI dmi = doDMILoad(a);
                if(VERBOSITY >= 0) dmi.printInfo();

                if(VERBOSITY >= 0) System.out.println("Loading " + b);
                DMI dmi2 = doDMILoad(b);
                if(VERBOSITY >= 0) dmi2.printInfo();

                DMIDiff dmid = new DMIDiff(dmi, dmi2);
                System.out.println(dmid);
                break;
            case "sort":
                if(argq.size() < 1) {
                    System.out.println("Insufficient arguments for command!");
                    System.out.println(helpStr);
                    return;
                }
                String f = argq.pollFirst();
                
                if(VERBOSITY >= 0) System.out.println("Loading " + f);
                dmi = doDMILoad(f);
                if(VERBOSITY >= 0) dmi.printInfo();
                
                if(VERBOSITY >= 0) System.out.println("Saving " + f);
                dmi.writeDMI(new FileOutputStream(f), true);
                break;
            case "merge":
                if(argq.size() < 4) {
                    System.out.println("Insufficient arguments for command!");
                    System.out.println(helpStr);
                    return;
                }
                String baseF = argq.pollFirst(),
                       aF = argq.pollFirst(),
                       bF = argq.pollFirst(),
                       mergedF = argq.pollFirst();
                if(VERBOSITY >= 0) System.out.println("Loading " + baseF);
                DMI base = doDMILoad(baseF);
                if(VERBOSITY >= 0) base.printInfo();
                
                if(VERBOSITY >= 0) System.out.println("Loading " + aF);
                DMI aDMI = doDMILoad(aF);
                if(VERBOSITY >= 0) aDMI.printInfo();
                
                if(VERBOSITY >= 0) System.out.println("Loading " + bF);
                DMI bDMI = doDMILoad(bF);
                if(VERBOSITY >= 0) bDMI.printInfo();
                
                DMIDiff aDiff = new DMIDiff(base, aDMI);
                DMIDiff bDiff = new DMIDiff(base, bDMI);
                DMIDiff mergedDiff = new DMIDiff();
                DMI conflictDMI = new DMI(32, 32);
                
                Set<String> cf = aDiff.mergeDiff(bDiff, conflictDMI, mergedDiff, aF, bF);
                
                mergedDiff.applyToDMI(base);
                
                base.writeDMI(new FileOutputStream(mergedF));
                
                if(!cf.isEmpty()) {
                    if(VERBOSITY >= 0) for(String s: cf) {
                        System.out.println(s);
                    }
                    conflictDMI.writeDMI(new FileOutputStream(mergedF + ".conflict.dmi"), true);
                    System.out.println("Add/modify conflicts placed in '" + mergedF + ".conflict.dmi'");
                    System.exit(1); // Git expects non-zero on merge conflict
                } else {
                    System.out.println("No conflicts");
                    System.exit(0);
                }
                break;
            case "extract":
                if(argq.size() < 3) {
                    System.out.println("Insufficient arguments for command!");
                    System.out.println(helpStr);
                    return;
                }
                String file = argq.pollFirst(),
                       state = argq.pollFirst(),
                       outFile = argq.pollFirst();
                
                dmi = doDMILoad(file);
                if(VERBOSITY >= 0) dmi.printInfo();
                
                IconState is = dmi.getIconState(state);
                if(is == null) {
                    System.out.println("icon_state '"+state+"' does not exist!");
                    return;
                }
                // minDir, Maxdir, minFrame, Maxframe
                int mDir=0, Mdir=is.dirs-1;
                int mFrame=0, Mframe=is.frames-1;
                
                while(argq.size() > 1) {
                    String arg = argq.pollFirst();
                    
                    switch(arg) {
                        case "d":
                        case "dir":
                        case "dirs":
                        case "direction":
                        case "directions":
                            String dString = argq.pollFirst();
                            if(dString.contains("-")) {
                                String[] splitD = dString.split("-");
                                if(splitD.length == 2) {
                                    mDir = parseDir(splitD[0], is);
                                    Mdir = parseDir(splitD[1], is);
                                } else {
                                    System.out.println("Illegal dir string: '" + dString + "'!");
                                    return;
                                }
                            } else {
                                mDir = parseDir(dString, is);
                                Mdir = mDir;
                            }
                            // Invalid value check, warnings are printed in parseDir()
                            if(mDir == -1 || Mdir == -1) return;
                            if(Mdir < mDir) {
                                System.out.println("Maximum dir greater than minimum dir!");
                                System.out.println("Textual direction order is S, N, E, W, SE, SW, NE, NW increasing 0 (S) to 7 (NW)");
                                return;
                            }
                            break;
                        case "f":
                        case "frame":
                        case "frames":
                            String fString = argq.pollFirst();
                            if(fString.contains("-")) {
                                String[] splitF = fString.split("-");
                                if(splitF.length == 2) {
                                    mFrame = parseFrame(splitF[0], is);
                                    Mframe = parseFrame(splitF[1], is);
                                } else {
                                    System.out.println("Illegal frame string: '" + fString + "'!");
                                    return;
                                }
                            } else {
                                mFrame = parseFrame(fString, is);
                                Mframe = mFrame;
                            }
                            // Invalid value check, warnings are printed in parseFrame()
                            if(mFrame == -1 || Mframe == -1) return;
                            if(Mframe < mFrame) {
                                System.out.println("Maximum frame greater than minimum frame!");
                                return;
                            }
                            break;
                        default:
                            System.out.println("Unknown argument '" + arg + "' detected, ignoring.");
                    }
                }
                if(!argq.isEmpty()) {
                    System.out.println("Extra argument '" + argq.pollFirst() + "' detected, ignoring.");
                }
                is.dumpToPNG(new FileOutputStream(outFile), mDir, Mdir, mFrame, Mframe);
                break;
            case "verify":
                if(argq.size() < 1) {
                    System.out.println("Insufficient arguments for command!");
                    System.out.println(helpStr);
                    return;
                }
                String vF = argq.pollFirst();
                if(VERBOSITY >= 0) System.out.println("Loading " + vF);
                DMI v = doDMILoad(vF);
                if(VERBOSITY >= 0) v.printInfo();
                break;
            default:
                System.out.println("Command '" + op + "' not found!");
            case "help":
                System.out.println(helpStr);
                break;
        }
    }
    
    static int parseDir(String s, IconState is) {
        try {
            int i = Integer.parseInt(s);
            if(0 <= i && i < is.dirs) {
                return i;
            } else {
                System.out.println("Direction not in valid range [0, "+(is.dirs-1)+"]!");
                return -1;
            }
        } catch(NumberFormatException nfe) {
            for(int q=0; q<dirs.length && q < is.dirs; q++) {
                if(dirs[q].equalsIgnoreCase(s)) {
                    return q;
                }
            }
            String dSummary = "";
            for(int i=0; i<is.dirs; i++) {
                dSummary += ", " + dirs[i];
            }
            dSummary = dSummary.substring(2);
            System.out.println("Unknown or non-existent direction '" + s + "'!");
            System.out.println("Valid range: [0, "+(is.dirs-1)+"], or " + dSummary);
            return -1;
        }
    }
    
    static int parseFrame(String s, IconState is) {
        try {
            int i = Integer.parseInt(s);
            if(0 <= i && i < is.frames) {
                return i;
            } else {
                System.out.println("Frame not in valid range [0, "+(is.frames-1)+"]!");
                return -1;
            }
        } catch(NumberFormatException nfe) {
            System.out.println("Failed to parse frame number: '" + s + "'!");
            return -1;
        }
    }
    
    static DMI doDMILoad(String file) {
        try {
            DMI dmi = new DMI(file);
            return dmi;
        } catch(DMIException dmie) {
            System.out.println("Failed to load " + file + ": " + dmie.getMessage());
        } catch(FileNotFoundException fnfe) {
            System.out.println("File not found: " + file);
        }
        System.exit(3);
        return null;
    }
}