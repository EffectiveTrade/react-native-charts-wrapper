package com.github.wuxudong.rncharts.markers;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.DashPathEffect;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Point;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.os.Build;
import android.text.SpannableStringBuilder;
import android.text.TextPaint;
import android.text.TextUtils;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.LineHeightSpan;
import android.text.style.MetricAffectingSpan;
import android.util.SizeF;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.facebook.react.views.text.ReactFontManager;
import com.github.mikephil.charting.charts.Chart;
import com.github.mikephil.charting.components.MarkerView;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.utils.ViewPortHandler;
import com.github.wuxudong.rncharts.R;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class RNCustomMarkerView extends MarkerView {

    float density = getResources().getDisplayMetrics().density;

    private Context context;
    private TextView tvContent;
    private Entry entry;
    private SizeF labelSize = new SizeF(0, 0);
    private SizeF size = new SizeF(0, 0);
    private SizeF minimumSize = new SizeF(density * 32, density * 12);
    private SizeF arrowSize = new SizeF(density * 12, density * 6);
    private float radius = density * 4;
    private RectF insets = new RectF(density * 16, density * 12, density * 16, density * 18);
    private RectF topInsets = new RectF(density * 16, density * 18, density * 16, density * 12);
    private RectF flagMarkerInsets = new RectF(density * 16, density * 12, density * 16, density * 12);
    private ViewPortHandler viewPortHandler;
    private int markerColor;


    public RNCustomMarkerView(Context context, ViewPortHandler viewPortHandler) {
        super(context, R.layout.custom_marker);
        this.context = context;
        this.viewPortHandler = viewPortHandler;
        tvContent = new TextView(context);
        markerColor = Color.WHITE;
    }

    private RectF drawRect(Canvas canvas, float posX, float posY) {
        Chart chart = super.getChartView();

        float width = size.getWidth();
        RectF rect = new RectF(posX, posY, posX + size.getWidth(), posY + size.getHeight());

        boolean disableShadow = false;
        if (((Map) entry.getData()).containsKey("disableShadow")) {
            Object data = ((Map) entry.getData()).get("disableShadow");
            if (data != null) {
                disableShadow = (boolean) data;
            }
        }

        if (!disableShadow && Build.VERSION.SDK_INT < Build.VERSION_CODES.P) {
            chart.setHardwareAccelerationEnabled(false);
        }

        boolean isFlagTypeMarker = false;
        if (((Map) entry.getData()).containsKey("isFlagTypeMarker")) {
            Object data = ((Map) entry.getData()).get("isFlagTypeMarker");
            if (data != null) {
                isFlagTypeMarker = (boolean) data;
            }
        }

        int shadowColor = Color.argb(31, 54, 57, 75);
        Paint paint = new Paint();
        paint.setStyle(Paint.Style.FILL);
        paint.setAntiAlias(true);
        paint.setColor(markerColor);
        if (!disableShadow) {
            paint.setShadowLayer(density * 12, 0, density * 4, shadowColor);
        }

        if (isFlagTypeMarker) {

            size = new SizeF(
                    size.getWidth(),
                    Math.max(minimumSize.getHeight(), labelSize.getHeight() + flagMarkerInsets.top + flagMarkerInsets.bottom)
            );
            rect.set(posX, posY, posX + size.getWidth(), posY + size.getHeight());

            if (posY - chart.getHeight() / 3 < 0) {

                rect.set(rect.left, rect.top + (float) chart.getHeight() / 8, rect.right, rect. bottom + (float) chart.getHeight() / 8);

                drawFlagStaff(canvas, 0, new Point((int) posX, (int) posY), viewPortHandler.contentBottom(), true);

                if (posX - chart.getHeight() / 2 < 0) {
                    drawRightFlagRect(canvas, rect, paint);
                } else {
                    rect.set(rect.left - size.getWidth(), rect.top, rect.right - size.getWidth(), rect.bottom);
                    drawLeftFlagRect(canvas, rect, paint);
                }

                rect.set(rect.left + flagMarkerInsets.left, rect.top + flagMarkerInsets.top, rect.right, rect.bottom);

            } else {

                rect.set(rect.left, rect.top - size.getHeight() - (float) chart.getHeight() / 8, rect.right, rect.bottom - size.getHeight() - (float) chart.getHeight() / 8);

                drawFlagStaff(canvas, rect.top, new Point((int) posX, (int) posY), viewPortHandler.contentBottom(), false);

                if (posX - chart.getWidth() / 2 < 0) {
                    drawRightFlagRect(canvas, rect, paint);
                } else {
                    rect.set(rect.left - size.getWidth(), rect.top, rect.right - size.getWidth(), rect.bottom);
                    drawLeftFlagRect(canvas, rect, paint);
                }

                rect.set(rect.left + flagMarkerInsets.left, rect.top + flagMarkerInsets.top, rect.right, rect.bottom);

            }

        } else {

            if (posY - size.getHeight() < 0) {

                if (posX - size.getWidth() / 2 < 0) {
                    drawTopLeftRect(canvas, rect, paint);
                } else if (posX + width - size.getWidth() / 2 > chart.getWidth()) {
                    rect.set(rect.left - size.getWidth(), rect.top, rect.right - size.getWidth(), rect.bottom);
                    drawTopRightRect(canvas, rect, paint);
                } else {
                    rect.set(rect.left - size.getWidth() / 2, rect.top, rect.right - size.getWidth() / 2, rect.bottom);
                    drawTopCenterRect(canvas, rect, paint);
                }

                rect.set(rect.left + topInsets.left, rect.top + topInsets.top, rect.right, rect.bottom);

            } else {

                rect.set(rect.left, rect.top - size.getHeight(), rect.right, rect.bottom - size.getHeight());

                if (posX - size.getWidth() / 2 < 0) {
                    drawLeftRect(canvas, rect, paint);
                } else if (posX + width - size.getWidth() / 2 > chart.getWidth()) {
                    rect.set(rect.left - size.getWidth(), rect.top, rect.right - size.getWidth(), rect.bottom);
                    drawRightRect(canvas, rect, paint);
                } else {
                    rect.set(rect.left - size.getWidth() / 2, rect.top, rect.right - size.getWidth() / 2, rect.bottom);
                    drawCenterRect(canvas, rect, paint);
                }

                rect.set(rect.left + insets.left, rect.top + insets.top, rect.right, rect.bottom);

            }
        }

        return rect;
    }

    private void drawTopLeftRect(Canvas canvas, RectF rect, Paint paint) {
        Path path = new Path();

        path.reset();
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.left + arrowSize.getWidth() / 2, rect.top + arrowSize.getHeight());
        path.lineTo(rect.right - radius, rect.top + arrowSize.getHeight());
        path.arcTo(getArcOval(rect.right - radius, rect.top + arrowSize.getHeight() + radius), -90, 90);
        path.lineTo(rect.right, rect.bottom - radius);
        path.arcTo(getArcOval(rect.right - radius, rect.bottom - radius), 0, 90);
        path.lineTo(rect.left + radius, rect.bottom);
        path.arcTo(getArcOval(rect.left + radius, rect.bottom - radius), 90, 90);
        path.lineTo(rect.left, rect.top);
        path.close();

        canvas.drawPath(path, paint);
    }

    private void drawTopRightRect(Canvas canvas, RectF rect, Paint paint) {
        Path path = new Path();

        path.reset();
        path.moveTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.bottom - radius);
        path.arcTo(getArcOval(rect.right - radius, rect.bottom - radius), 0, 90);
        path.lineTo(rect.left + radius, rect.bottom);
        path.arcTo(getArcOval(rect.left + radius, rect.bottom - radius), 90, 90);
        path.lineTo(rect.left, rect.top + arrowSize.getHeight() - radius);
        path.arcTo(getArcOval(rect.left + radius, rect.top + arrowSize.getHeight() + radius), 180, 90);
        path.lineTo(rect.right - arrowSize.getWidth() / 2, rect.top + arrowSize.getHeight());
        path.lineTo(rect.right, rect.top);
        path.close();

        canvas.drawPath(path, paint);
    }

    private void drawTopCenterRect(Canvas canvas, RectF rect, Paint paint) {
        Path path = new Path();

        path.reset();
        path.moveTo(rect.left + rect.width() / 2, rect.top);
        path.lineTo(rect.left + (rect.width() + arrowSize.getWidth()) / 2, rect.top + arrowSize.getHeight());
        path.lineTo(rect.right - radius, rect.top + arrowSize.getHeight());
        path.arcTo(getArcOval(rect.right - radius, rect.top + arrowSize.getHeight() + radius), -90, 90);
        path.lineTo(rect.right, rect.bottom - radius);
        path.arcTo(getArcOval(rect.right - radius, rect.bottom - radius), 0, 90);
        path.lineTo(rect.left + radius, rect.bottom);
        path.arcTo(getArcOval(rect.left + radius, rect.bottom - radius), 90, 90);
        path.lineTo(rect.left, rect.top + arrowSize.getHeight() + radius);
        path.arcTo(getArcOval(rect.left + radius, rect.top + arrowSize.getHeight() + radius), 180, 90);
        path.lineTo(rect.left + (rect.width() - arrowSize.getWidth()) / 2, rect.top + arrowSize.getHeight());
        path.lineTo(rect.left + rect.width() / 2, rect.top);
        path.close();

        canvas.drawPath(path, paint);
    }

    private void drawLeftRect(Canvas canvas, RectF rect, Paint paint) {
        Path path = new Path();

        path.moveTo(rect.left + radius, rect.top);
        path.lineTo(rect.right - radius, rect.top);
        path.arcTo(getArcOval(rect.right - radius, rect.top + radius), -90, 90);
        path.lineTo(rect.right, rect.bottom - arrowSize.getHeight() - radius);
        path.arcTo(getArcOval(rect.right - radius, rect.bottom - arrowSize.getHeight() - radius), 0, 90);
        path.lineTo(rect.left + arrowSize.getWidth() / 2, rect.bottom - arrowSize.getHeight());
        path.lineTo(rect.left, rect.bottom);
        path.lineTo(rect.left, rect.top + radius);
        path.arcTo(getArcOval(rect.left + radius, rect.top + radius), 180, 90);
        path.close();

        canvas.drawPath(path, paint);
    }

    private void drawRightRect(Canvas canvas, RectF rect, Paint paint) {
        Path path = new Path();

        path.moveTo(rect.left + radius, rect.top);
        path.lineTo(rect.right - radius, rect.top);
        path.arcTo(getArcOval(rect.right - radius, rect.top + radius), -90, 90);
        path.lineTo(rect.right, rect.bottom);
        path.lineTo(rect.right - arrowSize.getWidth() / 2, rect.bottom - arrowSize.getHeight());
        path.lineTo(rect.left + radius, rect.bottom - arrowSize.getHeight());
        path.arcTo(getArcOval(rect.left + radius, rect.bottom - arrowSize.getHeight() - radius), 90, 90);
        path.lineTo(rect.left, rect.top + radius);
        path.arcTo(getArcOval(rect.left + radius, rect.top + radius), 180, 90);
        path.close();

        canvas.drawPath(path, paint);
    }

    private void drawCenterRect(Canvas canvas, RectF rect, Paint paint) {
        Path path = new Path();

        path.moveTo(rect.left + radius, rect.top);
        path.lineTo(rect.right - radius, rect.top);
        path.arcTo(getArcOval(rect.right - radius, rect.top + radius), -90, 90);
        path.lineTo(rect.right, rect.bottom - arrowSize.getHeight());
        path.arcTo(getArcOval(rect.right - radius, rect.bottom - arrowSize.getHeight() - radius), 0, 90);
        path.lineTo(rect.left + (rect.width() + arrowSize.getWidth()) / 2, rect.bottom - arrowSize.getHeight());
        path.lineTo(rect.left + rect.width() / 2, rect.bottom);
        path.lineTo(rect.left + (rect.width() - arrowSize.getWidth()) / 2, rect.bottom - arrowSize.getHeight());
        path.lineTo(rect.left + radius, rect.bottom - arrowSize.getHeight());
        path.arcTo(getArcOval(rect.left + radius, rect.bottom - arrowSize.getHeight() - radius), 90, 90);
        path.lineTo(rect.left, rect.top + radius);
        path.arcTo(getArcOval(rect.left + radius, rect.top + radius), 180, 90);
        path.close();

        canvas.drawPath(path, paint);
    }

    private void drawRightFlagRect(Canvas canvas, RectF rect, Paint paint) {
        Path path = new Path();

        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right - radius, rect.top);
        path.arcTo(getArcOval(rect.right - radius, rect.top + radius), -90, 90);
        path.lineTo(rect.right, rect.bottom - radius);
        path.arcTo(getArcOval(rect.right - radius, rect.bottom - radius), 0, 90);
        path.lineTo(rect.left, rect.bottom);
        path.lineTo(rect.left, rect.bottom);
        path.close();

        canvas.drawPath(path, paint);
    }

    private void drawLeftFlagRect(Canvas canvas, RectF rect, Paint paint) {
        Path path = new Path();

        path.moveTo(rect.left + radius, rect.top);
        path.lineTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.bottom);
        path.lineTo(rect.left + radius, rect.bottom);
        path.arcTo(getArcOval(rect.left + radius, rect.bottom - radius), 90, 90);
        path.lineTo(rect.left, rect.top + radius);
        path.arcTo(getArcOval(rect.left + radius, rect.top + radius), 180, 90);
        path.close();

        canvas.drawPath(path, paint);
    }

    private void drawFlagStaff(Canvas canvas, float origin, Point point, float chartBound, boolean toTop) {
        Path path = new Path();

        float offset = density * 8;

        if (toTop) {
            path.reset();
            path.moveTo(point.x, point.y + offset);
            path.lineTo(point.x, chartBound);
        } else {
            path.reset();
            path.moveTo(point.x, origin);
            path.lineTo(point.x, point.y - offset);
            path.moveTo(point.x, point.y + offset);
            path.lineTo(point.x, chartBound);
        }

        Paint paint = new Paint();
        paint.setAntiAlias(true);
        paint.setColor(markerColor);
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(density * 2);
        paint.setPathEffect(new DashPathEffect(new float[]{ density * 4, density * 4 }, 0));

        canvas.drawPath(path, paint);
    }


    private RectF getArcOval(float centerX, float centerY) {
        return new RectF(centerX - radius, centerY - radius, centerX + radius, centerY + radius);
    }


    @Override
    public void draw(Canvas canvas, float posX, float posY) {

        if (tvContent == null || tvContent.getText().length() == 0) {
            return;
        }

        int saveId = canvas.save();

        RectF rect = drawRect(canvas, posX, posY);
        LinearLayout layout = new LinearLayout(context);

        if(tvContent.getParent() != null) {
            ((ViewGroup)tvContent.getParent()).removeView(tvContent);
        }
        layout.addView(tvContent);

        layout.measure(canvas.getWidth(), canvas.getHeight());
        layout.layout(0, 0, canvas.getWidth(), canvas.getHeight());

        canvas.translate(rect.left, rect.top);
        layout.draw(canvas);
        canvas.restoreToCount(saveId);
    }


    @Override
    public void refreshContent(Entry e, Highlight highlight) {
        entry = e;

        SpannableStringBuilder spannableText = new SpannableStringBuilder();

        tvContent.setTextColor(Color.BLACK);

        if (e.getData() instanceof Map) {

            if (((Map) e.getData()).containsKey("markerTextSpans")) {

                List<String> markerTextSpans = new ArrayList<>();
                List<Integer> textColors = new ArrayList<>();
                List<Integer> textSizes = new ArrayList<>();
                List<String> textFontFamilies = new ArrayList<>();

                Object markerData = ((Map) e.getData()).get("markerTextSpans");
                if (markerData != null) {
                    markerTextSpans = (List) markerData;
                }

                if (((Map) e.getData()).containsKey("markerColor")) {
                    Object data = ((Map) e.getData()).get("markerColor");
                    if (data != null) {
                        markerColor = (int) data;
                    }
                }

                if (((Map) e.getData()).containsKey("markerTextColors")) {
                    Object data = ((Map) e.getData()).get("markerTextColors");
                    if (data != null) {
                        textColors = (List) data;
                    }
                }

                if (((Map) e.getData()).containsKey("markerTextSizes")) {
                    Object data = ((Map) e.getData()).get("markerTextSizes");
                    if (data != null) {
                        textSizes = (List) data;
                    }
                }

                if (((Map) e.getData()).containsKey("markerTextFontFamilies")) {
                    Object data = ((Map) e.getData()).get("markerTextFontFamilies");
                    if (data != null) {
                        textFontFamilies = (List) data;
                    }
                }

                for (int i = 0; i < markerTextSpans.size(); i++) {

                    int start = spannableText.length();

                    spannableText.append(markerTextSpans.get(i));

                    int end = spannableText.length();

                    spannableText.setSpan(new LineHeightSpanImpl((int) density * 3), start, end, 0);

                    if (i < textColors.size()) {
                        spannableText.setSpan(new ForegroundColorSpan(textColors.get(i)), start, end, 0);
                    }

                    if (i < textSizes.size()) {
                        spannableText.setSpan(new AbsoluteSizeSpan(textSizes.get(i), true), start, end, 0);
                    }

                    if (i < textFontFamilies.size()) {

                        spannableText.setSpan(
                                new CustomTypefaceSpan(this.getTypeFace(textFontFamilies.get(i))),
                                start,
                                end,
                                0
                        );
                    }
                }

            }
        }


        if (TextUtils.isEmpty(spannableText)) {
            tvContent.setText(spannableText);
            tvContent.setVisibility(INVISIBLE);
        } else {
            tvContent.setText(spannableText);
            tvContent.setVisibility(VISIBLE);

            tvContent.measure(0, 0);
            float tvContentWidth = tvContent.getMeasuredWidth();
            float tvContentHeight = tvContent.getMeasuredHeight();
            labelSize = new SizeF(tvContentWidth, tvContentHeight);

            size = new SizeF(
                    Math.max(minimumSize.getWidth(), labelSize.getWidth() + insets.left + insets.right),
                    Math.max(minimumSize.getHeight(), labelSize.getHeight() + insets.top + insets.bottom)
            );
        }

        super.refreshContent(e, highlight);
    }

    private Typeface getTypeFace(String fontFamily) {
        Chart chart = getChartView();

        return ReactFontManager.getInstance().getTypeface(fontFamily,
                Typeface.NORMAL,
                chart.getContext().getAssets());
    }
}

class LineHeightSpanImpl implements LineHeightSpan {

    private final int height;

    LineHeightSpanImpl(int height) {
        this.height = height;
    }

    @Override
    public void chooseHeight(CharSequence text, int start, int end, int spanstartv, int v, Paint.FontMetricsInt fm) {
        fm.descent += height;
    }
}

class CustomTypefaceSpan extends MetricAffectingSpan {
    private Typeface typeface;

    CustomTypefaceSpan(Typeface typeface) {
        this.typeface = typeface;
    }

    @Override
    public void updateDrawState(TextPaint paint) {
        paint.setTypeface(this.typeface);
        paint.baselineShift += getBaselineShift(paint);
    }

    @Override
    public void updateMeasureState(TextPaint paint) {
        paint.setTypeface(this.typeface);
        paint.baselineShift += getBaselineShift(paint);
    }

    private int getBaselineShift(TextPaint paint) {
        float total = paint.ascent() + paint.descent();
        return (int) (total) / 4;
    }
}
