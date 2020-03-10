package dustin.diaz.comp4400.utils;

import dustin.diaz.comp4400.view.boxes.ConfirmBox;

public abstract class Computer {
    public static String src;
    public static String pathChar;

    public static void closeProgram() {
        boolean answer = ConfirmBox.display("Close Application", "Are you sure you want to quit?");
        if (answer) System.exit(0);
    }
}
