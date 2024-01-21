package com.stroketext;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.text.TextPaint;
import android.util.TypedValue;
import android.view.View;

import com.facebook.react.bridge.GuardedRunnable;
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
    private final Paint strokePaint;

    public StrokeTextView(ThemedReactContext context) {
        super(context);
        textPaint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
        strokePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        Typeface typeface = FontUtil.getFontFromAssets(getContext(), fontFamily);
        textPaint.setTypeface(typeface);
        textPaint.setTextSize(fontSize);
        textPaint.setColor(textColor);
        strokePaint.setStyle(Paint.Style.STROKE);
        strokePaint.setStrokeWidth(strokeWidth);
        strokePaint.setColor(strokeColor);
        strokePaint.setTypeface(typeface);
        strokePaint.setTextSize(fontSize);

        float x = getWidth() / 2f - textPaint.measureText(text) / 2f;
        float y = getHeight() / 2f - (textPaint.descent() + textPaint.ascent()) / 2f;

        canvas.drawText(text, x, y, strokePaint);
        canvas.drawText(text, x, y, textPaint);

        Rect bounds = new Rect();
        textPaint.getTextBounds(text, 0, text.length(), bounds);
        int width = (int) (bounds.width() + getScaledSize(strokeWidth));
        int height = (int) (bounds.height() +  getScaledSize(strokeWidth));
        updateSize(width, height);
    }

    private ThemedReactContext getReactContext() {
        return (ThemedReactContext) getContext();
    }

    private float getScaledSize(float size){
       return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, size, getResources().getDisplayMetrics());
    }

    private void updateSize(int width, int height) {
        //packages/react-native/ReactAndroid/src/main/java/com/facebook/react/views/modal/ReactModalHostView.java
        ReactContext reactContext = getReactContext();
        reactContext.runOnNativeModulesQueueThread(
                new GuardedRunnable(reactContext) {
                    @Override
                    public void runGuarded() {
                        UIManagerModule uiManager =
                                getReactContext()
                                        .getReactApplicationContext()
                                        .getNativeModule(UIManagerModule.class);
                        if (uiManager == null) {
                            return;
                        }
                        uiManager.updateNodeSize(getId(), width, height);
                    }
                });
    }

    public void setText(String text) {
        this.text = text;
        invalidate();
    }

    public void setFontSize(float fontSize) {
        this.fontSize = getScaledSize(fontSize);
        invalidate();
    }

    public void setTextColor(String color) {
        this.textColor = android.graphics.Color.parseColor(color);
        invalidate();
    }

    public void setStrokeColor(String color) {
        this.strokeColor = android.graphics.Color.parseColor(color);
        invalidate();
    }

    public void setStrokeWidth(float strokeWidth) {
        this.strokeWidth = getScaledSize(strokeWidth);
        invalidate();
    }

    public void setFontFamily(String fontFamily) {
        this.fontFamily = fontFamily;
        invalidate();
    }
}