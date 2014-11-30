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
            
            "extract [file] [state] {direction} {frame} [out]\n"+
            "\textract [state] from [file] in bitmap format to [out]; {direction} and {frame} are separately mandatory if [state] has more than one of them\n" +
            "\t{direction} can be 0-7 or S, N, E, W, SE, SW, NE, NW (non-case-sensitive)\n" +
            
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
                if(argq.size() < 4) {
                    System.out.println("Insufficient arguments for command!");
                    System.out.println(helpStr);
                    return;
                }
                String file = argq.pollFirst(),
                       state = argq.pollFirst();
                
                dmi = doDMILoad(file);
                if(VERBOSITY >= 0) dmi.printInfo();
                
                IconState is = dmi.getIconState(state);
                if(is == null) {
                    System.out.println("icon_state '"+state+"' does not exist!");
                    return;
                }
                int dir=0;
                int frame=0;
                
                if(argq.size() < 1 + (is.dirs>1?1:0) + (is.frames>1?1:0)) {
                    int what = (is.dirs > 1 ? 1:0) | (is.frames > 1 ? 2:0);
                    switch(what) {
                        case 1: System.out.println("Direction specifier required!"); break;
                        case 2: System.out.println("Frame specifier required!"); break;
                        case 3: System.out.println("Direction and frame specifiers required!"); break;
                        
                        default: System.out.println("Direction and/or frame specifier required!"); break;
                    }
                    return;
                }
                
                if(is.dirs > 1) {
                    String dString = argq.pollFirst();
                    t: try {
                        dir = Integer.parseInt(dString);
                    } catch(NumberFormatException nfe) {
                        for(int q=0; q<dirs.length && q < is.dirs; q++) {
                            if(dirs[q].equalsIgnoreCase(dString)) {
                                dir = q;
                                break t;
                            }
                        }
                        System.out.println("Unknown or non-existent direction '" + dString + "'!");
                        return;
                    }
                }
                if(is.frames > 1) {
                    String fString = argq.pollFirst();
                    try {
                        frame = Integer.parseInt(fString);
                    } catch(NumberFormatException nfe) {
                        System.out.println("Failed to parse frame number: '" + fString + "'!");
                        return;
                    }
                }
                Image img = is.images[is.dirs*frame + dir];
                img.dumpToBMP(new FileOutputStream(argq.pollFirst()));
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