package com.stroketext;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.View;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.UIManagerModule;

import java.util.HashMap;
import java.util.Map;

class StrokeTextView extends View {
    private String text = "";
    private float fontSize = 14;
    private int textColor = 0xFF000000;
    private int strokeColor = 0xFFFFFFFF;
    private float strokeWidth = 1;
    private String fontFamily = "sans-serif";
    private int numberOfLines = 0;
    private boolean ellipsis = false;
    private final TextPaint textPaint;
    private final TextPaint strokePaint;
    private Layout.Alignment alignment = Layout.Alignment.ALIGN_CENTER;
    private StaticLayout textLayout;
    private StaticLayout strokeLayout;
    private boolean layoutDirty = true;
    private float customWidth = 0;
    private int width = 0;
    private int height = 0;
    private final Map<String, Typeface> fontCache = new HashMap<>();

    public StrokeTextView(ThemedReactContext context) {
        super(context);
        textPaint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
        strokePaint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
    }

    private void ensureLayout() {
        if (layoutDirty) {
            Typeface typeface = getFont(fontFamily);
            textPaint.setTypeface(typeface);
            textPaint.setTextSize(fontSize);
            textPaint.setColor(textColor);
            strokePaint.setStyle(Paint.Style.STROKE);
            strokePaint.setStrokeJoin(Paint.Join.ROUND);
            strokePaint.setStrokeCap(Paint.Cap.ROUND);
            strokePaint.setStrokeWidth(strokeWidth);
            strokePaint.setColor(strokeColor);
            strokePaint.setTypeface(typeface);
            strokePaint.setTextSize(fontSize);

            int width = (int) getCanvasWidth();
            CharSequence ellipsizedText = ellipsis ? TextUtils.ellipsize(text, textPaint, width, TextUtils.TruncateAt.END) : text;
            textLayout = new StaticLayout(ellipsizedText, textPaint, width, alignment, 1.0f, 0.0f, false);
            if (numberOfLines > 0 && numberOfLines < textLayout.getLineCount()) {
                int lineEnd = textLayout.getLineEnd(numberOfLines - 1);
                ellipsizedText = ellipsizedText.subSequence(0, lineEnd);
                textLayout = new StaticLayout(ellipsizedText, textPaint, width, alignment, 1.0f, 0.0f, false);
            }
            strokeLayout = new StaticLayout(ellipsizedText, strokePaint, width, alignment, 1.0f, 0.0f, false);

            layoutDirty = false;
        }
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        layoutDirty = true;
        ensureLayout();
    }

    private float getCanvasWidth() {
        if (customWidth > 0) {
            return getScaledSize(customWidth);
        }

        String[] lines = text.split("\n");
        float maxLineWidth = 0;
        for (String line : lines) {
            float lineWidth = textPaint.measureText(line);
            if (lineWidth > maxLineWidth) {
                maxLineWidth = lineWidth;
            }
        }

        maxLineWidth += getScaledSize(strokeWidth) / 2;
        return maxLineWidth;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        ensureLayout();
        strokeLayout.draw(canvas);
        textLayout.draw(canvas);
        updateSize(textLayout.getWidth(), textLayout.getHeight());
    }

    private float getScaledSize(float size) {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, size, getResources().getDisplayMetrics());
    }

    private void updateSize(int width, int height) {
        if (this.width == width && this.height == height) {
            return;
        }
        this.width = width;
        this.height = height;
        ReactContext reactContext = (ReactContext) getContext();
        reactContext.runOnNativeModulesQueueThread(
                new Runnable() {
                    @Override
                    public void run() {
                        UIManagerModule uiManager = reactContext.getNativeModule(UIManagerModule.class);
                        if (uiManager != null) {
                            uiManager.updateNodeSize(getId(), width, height);
                        }
                    }
                });
    }

    public void setText(String text) {
        if (!this.text.equals(text)) {
            this.text = text;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setFontSize(float fontSize) {
        float scaledFontSize = getScaledSize(fontSize);
        if (this.fontSize != scaledFontSize) {
            this.fontSize = scaledFontSize;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setTextColor(String color) {
        int parsedColor = parseColor(color);
        if (this.textColor != parsedColor) {
            this.textColor = parsedColor;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setStrokeColor(String color) {
        int parsedColor = parseColor(color);
        if (this.strokeColor != parsedColor) {
            this.strokeColor = parsedColor;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setStrokeWidth(float strokeWidth) {
        float scaledStrokeWidth = getScaledSize(strokeWidth);
        if (this.strokeWidth != scaledStrokeWidth) {
            this.strokeWidth = scaledStrokeWidth;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setFontFamily(String fontFamily) {
        if (!this.fontFamily.equals(fontFamily)) {
            this.fontFamily = fontFamily;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setTextAlignment(String alignment) {
        Layout.Alignment newAlignment;
        if ("left".equals(alignment)) {
            newAlignment = Layout.Alignment.ALIGN_NORMAL;
        } else if ("right".equals(alignment)) {
            newAlignment = Layout.Alignment.ALIGN_OPPOSITE;
        } else if ("center".equals(alignment)) {
            newAlignment = Layout.Alignment.ALIGN_CENTER;
        } else {
            newAlignment = this.alignment;
        }
        if (this.alignment != newAlignment) {
            this.alignment = newAlignment;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setNumberOfLines(int numberOfLines) {
        if (this.numberOfLines != numberOfLines) {
            this.numberOfLines = numberOfLines;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setEllipsis(boolean ellipsis) {
        if (this.ellipsis != ellipsis) {
            this.ellipsis = ellipsis;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setCustomWidth(float width) {
        if (!(this.customWidth == width)) {
            this.customWidth = width;
            layoutDirty = true;
            invalidate();
        }
    }

    private int parseColor(String color) {
        if (color.startsWith("#")) {
            return Color.parseColor(color);
        } else if (color.startsWith("rgb")) {
            return parseRgbColor(color);
        }

        return 0xFF000000;
    }

    private int parseRgbColor(String color) {
        String[] parts = color.replaceAll("[rgba()\\s]", "").split(",");
        int r = Integer.parseInt(parts[0]);
        int g = Integer.parseInt(parts[1]);
        int b = Integer.parseInt(parts[2]);
        int a = parts.length > 3 ? (int) (Float.parseFloat(parts[3]) * 255) : 255;
        return Color.argb(a, r, g, b);
    }

    private Typeface getFont(String fontFamily) {
        if (fontCache.containsKey(fontFamily)) {
            return fontCache.get(fontFamily);
        } else {
            Typeface typeface = FontUtil.getFont(getContext(), fontFamily);
            fontCache.put(fontFamily, typeface);
            return typeface;
        }
    }
}
