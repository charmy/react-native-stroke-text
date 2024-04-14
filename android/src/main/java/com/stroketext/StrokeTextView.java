package com.stroketext;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.util.TypedValue;
import android.view.View;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.UIManagerModule;

class StrokeTextView extends View {
    private String text = "";
    private float fontSize = 14;
    private int textColor = 0xFF000000;
    private int strokeColor = 0xFFFFFFFF;
    private float strokeWidth = 1;
    private String fontFamily = "sans-serif";
    private final TextPaint textPaint;
    private final TextPaint strokePaint;
    private Layout.Alignment alignment = Layout.Alignment.ALIGN_CENTER;
    private StaticLayout textLayout;
    private StaticLayout strokeLayout;
    private boolean layoutDirty = true;

    public StrokeTextView(ThemedReactContext context) {
        super(context);
        textPaint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
        strokePaint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
    }

    private void ensureLayout() {
        if (layoutDirty) {
            Typeface typeface = FontUtil.getFontFromAssets(getContext(), fontFamily);
            textPaint.setTypeface(typeface);
            textPaint.setTextSize(fontSize);
            textPaint.setColor(textColor);
            strokePaint.setStyle(Paint.Style.STROKE);
            strokePaint.setStrokeWidth(strokeWidth);
            strokePaint.setColor(strokeColor);
            strokePaint.setTypeface(typeface);
            strokePaint.setTextSize(fontSize);

            String[] lines = text.split("\n");
            float maxLineWidth = 0;
            for (String line : lines) {
                float lineWidth = textPaint.measureText(line);
                if (lineWidth > maxLineWidth) {
                    maxLineWidth = lineWidth;
                }
            }

            maxLineWidth += (int) (getScaledSize(strokeWidth) / 2);
            int width = (int) Math.ceil(maxLineWidth);

            textLayout = new StaticLayout(text, textPaint, width, alignment, 1.0f, 0.0f, false);
            strokeLayout = new StaticLayout(text, strokePaint, width, alignment, 1.0f, 0.0f, false);

            layoutDirty = false;
        }
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        ensureLayout();
        strokeLayout.draw(canvas);
        textLayout.draw(canvas);
        updateSize(textLayout.getWidth(), textLayout.getHeight());
    }

    private float getScaledSize(float size){
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, size, getResources().getDisplayMetrics());
    }

    private void updateSize(int width, int height) {
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
        int parsedColor = android.graphics.Color.parseColor(color);
        if (this.textColor != parsedColor) {
            this.textColor = android.graphics.Color.parseColor(color);
            invalidate();
        }
    }

    public void setStrokeColor(String color) {
        int parsedColor = android.graphics.Color.parseColor(color);
        if (this.strokeColor != parsedColor) {
            this.strokeColor = android.graphics.Color.parseColor(color);
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
        Layout.Alignment newAlignment = switch (alignment) {
            case "left" -> Layout.Alignment.ALIGN_NORMAL;
            case "right" -> Layout.Alignment.ALIGN_OPPOSITE;
            case "center" -> Layout.Alignment.ALIGN_CENTER;
            default -> this.alignment;
        };
        if (this.alignment != newAlignment) {
            this.alignment = newAlignment;
            layoutDirty = true;
            invalidate();
        }
    }
}
