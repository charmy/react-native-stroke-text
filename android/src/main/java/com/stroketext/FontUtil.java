package com.stroketext;

import android.content.Context;
import android.graphics.Typeface;
import java.io.IOException;

public class FontUtil {

    public static Typeface getFontFromAssets(Context context, String fontFamily) {
        String fontPath = findFontFile(context, "fonts/", fontFamily);
        if (fontPath != null) {
            return Typeface.createFromAsset(context.getAssets(), fontPath);
        }
        return null;
    }

    private static String findFontFile(Context context, String folderPath, String fontName) {
        try {
            String[] files = context.getAssets().list(folderPath);
            for (String file : files) {
                if (file.startsWith(fontName) && (file.endsWith(".ttf") || file.endsWith(".otf"))) {
                    return folderPath + file;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
