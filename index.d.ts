declare module 'react-native-charts-wrapper' {
    import * as React from 'react';
    import { ViewProps } from 'react-native';

    export interface IDescription {
        text?: string;
        textColor?: number;
        textSize?: number;

        positionX?: number;
        positionY?: number;

        fontFamily?: string;
        fontStyle?: number;
    }

    export interface ILegend {
        enabled?: boolean;

        textColor?: number;
        textSize?: number;
        fontFamily?: string;
        fontStyle?: number;
        fontWeight?: number;

        wordWrapEnabled?: boolean;
        maxSizePercent?: number;

        horizontalAlignment?: 'LEFT' | 'CENTER' | 'RIGHT';
        verticalAlignment?: 'TOP' | 'CENTER' | 'BOTTOM';
        orientation?: 'HORIZONTAL' | 'VERTICAL';
        drawInside?: boolean;
        direction?: 'LEFT_TO_RIGHT' | 'RIGHT_TO_LEFT';

        form?: 'NONE' | 'EMPTY' | 'DEFAULT' | 'SQUARE' | 'CIRCLE' | 'LINE';
        formSize?: number;
        xEntrySpace?: number;
        yEntrySpace?: number;
        formToTextSpace?: number;

        custom?: {
            colors?: number[];
            labels?: string[];
        };
    }

    export interface IGridDashedLine {
        lineLength?: number;
        spaceLength?: number;
        phase?: number;
    }

    export interface IAxis {
        // what is drawn
        enabled?: boolean;
        drawLabels?: boolean;
        drawAxisLine?: boolean;
        drawGridLines?: boolean;

        // style
        textColor?: number;
        textSize?: number;
        fontFamily?: string;
        fontStyle?: string;
        fontWeight?: string; // must be number ?
        gridColor?: number;
        yOffset?: number;
        gridLineWidth?: number;
        axisLineColor?: number;
        axisLineWidth?: number;
        gridDashedLine?: IGridDashedLine;

        // limit lines
        limitLines?: Array<{
            limit: number;
            label?: string;
            lineColor?: number;
            lineWidth?: number;
            valueTextColor?: number;
            valueFont?: number;
            labelPosition?: 'LEFT_TOP' | 'LEFT_BOTTOM' | 'RIGHT_TOP' | 'RIGHT_BOTTOM' | 'AXIS';
            lineDashPhase?: number;
            lineDashLengths?: number[];
            labelBgEnabled?: boolean;
            labelBgColor?: number;
            labelPadding?: number;
            labelRadius?: number;
        }>;

        drawLimitLinesBehindData?: boolean;

        axisMaximum?: number;
        axisMinimum?: number;
        granularity?: number;
        granularityEnabled?: boolean;

        labelCount?: number;
        labelCountForce?: boolean;

        labelBgEnabled?: boolean;
        labelBgColor?: number;
        labelPadding?: number;
        labelRadius?: number;

        /** Centers the axis labels instead of drawing them at their original position. This is useful especially for grouped BarChart. */
        centerAxisLabels?: boolean;

        valueFormatter?: ('largeValue' | 'percent' | 'date') | string | string[];

        /** valueFormatterPattern, since, timeUnit are used when valueFormatter is 'date'
         * since: milliseconds of 2018-6-1, timeUnit: DAYS, x:9, valueFormatterPattern: YYYY-MM-dd
         * will display 2018-6-10
         *
         * Note: for iOS/Charts, double is used for x, but in MpAndroidChart, float is used for x.
         * so in android, there will be precision loss when you use MILLISECONDS/SECOND/MINUTES as x value.
         * you can use a different since like seconds of 2019 or use timeUnit DAYS, then x value will be within a valid range.
         */

        valueFormatterPattern?: string;
        /** milliseconds from 1970-1-1 when x=0 */
        since?: number;
        /** timeUnit of x */
        timeUnit?: 'MILLISECONDS' | 'SECONDS' | 'MINUTES' | 'HOURS' | 'DAYS';
    }

    export interface IXAxis extends IAxis {
        labelRotationAngle?: number;
        avoidFirstLastClipping?: boolean;
        position?: 'TOP' | 'BOTTOM' | 'BOTH_SIDED' | 'TOP_INSIDE' | 'BOTTOM_INSIDE';
    }

    export interface IYAxis extends IAxis {
        inverted?: boolean;
        spaceTop?: number;
        spaceBottom?: number;

        position?: 'INSIDE_CHART' | 'OUTSIDE_CHART';

        maxWidth?: number;
        minWidth?: number;

        zeroLine?: {
            enabled?: boolean;
            lineWidth?: number;
            lineColor?: number;
        };
    }

    type EasingType = 'Linear' | 'EaseInQuad' | 'EaseOutQuad' | 'EaseInOutQuad' | 'EaseInCubic' | 'EaseOutCubic' | 'EaseInOutCubic' |
        'EaseInQuart' | 'EaseOutQuart' | 'EaseInOutQuart' | 'EaseInSine' | 'EaseOutSine' | 'EaseInOutSine' | 'EaseInExpo' | 'EaseOutExpo' |
        'EaseInOutExpo' | 'EaseInCirc' | 'EaseOutCirc' | 'EaseInOutCirc' | 'EaseInElastic' | 'EaseOutElastic' | 'EaseInOutElastic' |
        'EaseInBack' | 'EaseOutBack' | 'EaseInOutBack' | 'EaseInBounce' | 'EaseOutBounce' | 'EaseInOutBounce';

    export interface IChart extends ViewProps {
        animation?: {
            /** Milliseconds */
            durationX?: number;
            /** Milliseconds */
            durationY?: number;
            easingX?: EasingType;
            easingY?: EasingType;
        };

        chartBackgroundColor?: number;
        logEnabled?: boolean;
        noDataText?: string;
        noDataTextColor?: number;

        touchEnabled?: boolean;
        dragDecelerationEnabled?: boolean;
        /** Value must be number and between 0 and 1 */
        dragDecelerationFrictionCoef?: number;

        highlightPerTapEnabled?: boolean;
        chartDescription?: IDescription;
        legend?: ILegend;
        xAxis?: IXAxis;

        marker?: {
            enabled?: boolean;
            longPressDelay?: number; // only ios
            digits?: number;
            markerType: 'circle' | 'custom';
            markerColor?: number;
            textColor?: number;
            textSize?: number;
            fontFamily?: string;
            labelCount?: number;
            gridDashedLine?: IGridDashedLine;
            position?: string | 'INSIDE_CHART' | 'OUTSIDE_CHART';
        };

        /** stackIndex for StackBarChart */
        highlights?: Array<{
            x: number;
            /** this is used in stacked bar chart */
            dataSetIndex?: number;
            /** this is necessary in combined chart when default highlight is set. the default sequence is line, bar, scatter, candle, bubble */
            dataIndex?: number;
            y?: number;
            stackIndex?: number;
        }>;

        // TODO: Проверить, работает ли
        viewPortOffsets?: { left?: number, top?: number, right?: number, bottom?: number };
    }

    // Datasets config types

    export interface ICommonDataSet {
        color?: number;
        colors?: number[];
        highlightEnabled?: boolean;
        drawValues?: boolean;
        valueTextSize?: number;
        valueTextColor?: number;
        visible?: boolean;
        valueFormatter?: ('largeValue' | 'percent' | 'date') | string | string[];
        valueFormatterPattern?: string;
        axisDependency?: 'LEFT' | 'RIGHT';
    }

    export interface IBarLineScatterCandleBubbleDataSet {
        highlightColor?: number;
    }

    export interface ILineScatterCandleRadarDataSet {
        drawVerticalHighlightIndicator?: boolean;
        drawHorizontalHighlightIndicator?: boolean;
        highlightLineWidth?: number;
    }

    export interface ILineRadarDataSet {
        fillGradient?: {
            colors?: number[],
            /** iOS */
            positions?: number[],
            angle?: number,
            /** Android.
             * TOP_BOTTOM draw the gradient from the top to the bottom
             * TR_BL draw the gradient from the top-right to the bottom-left
             * RIGHT_LEFT draw the gradient from the right to the left
             * BR_TL draw the gradient from the bottom-right to the top-left
             * BOTTOM_TOP draw the gradient from the bottom to the top
             * BL_TR draw the gradient from the bottom-left to the top-right
             * LEFT_RIGHT draw the gradient from the left to the right
             * TL_BR draw the gradient from the top-left to the bottom-right
             */
            orientation?: 'TOP_BOTTOM' | 'TR_BL' | 'RIGHT_LEFT' | 'BR_TL' | 'BOTTOM_TOP' | 'BL_TR' | 'LEFT_RIGHT' | 'TL_BR',
        };
        fillColor?: number;
        fillAlpha?: number;
        drawFilled?: boolean;
        /** Value must be number and between 0.2f and 10f */
        lineWidth?: number;
    }

    export interface ILineDataSetConfig extends ICommonDataSet, IBarLineScatterCandleBubbleDataSet, ILineScatterCandleRadarDataSet, ILineRadarDataSet {
        circleRadius?: number;
        drawCircles?: boolean;
        mode?: 'LINEAR' | 'STEPPED' | 'CUBIC_BEZIER' | 'HORIZONTAL_BEZIER';
        drawCubicIntensity?: number;
        circleColor?: number;
        circleColors?: number[];
        circleHoleColor?: number;
        drawCircleHole?: boolean;
        dashedLine?: { lineLength: number, spaceLength: number, phase?: number };
    }

    export interface IBarDataSetConfig extends ICommonDataSet, IBarLineScatterCandleBubbleDataSet {
        barShadowColor?: number;
        /** using android format (0-255), not ios format(0-1), the conversion is x/255 */
        highlightAlpha?: number;
        stackLabels?: string[];
    }

    export interface IBubbleDataSetConfig extends ICommonDataSet, IBarLineScatterCandleBubbleDataSet { }

    export type CandlePaintStyle =  'FILL' | 'STROKE' | 'FILL_AND_STROKE';

    export interface ICandleDataSetConfig extends ICommonDataSet, IBarLineScatterCandleBubbleDataSet, ILineScatterCandleRadarDataSet {
        barSpace?: number;
        shadowWidth?: number;
        shadowColor?: number;
        shadowColorSameAsCandle?: boolean;
        neutralColor?: number;
        decreasingColor?: number;
        decreasingPaintStyle?: CandlePaintStyle;
        increasingColor?: number;
        increasingPaintStyle?: CandlePaintStyle;
    }

    export interface IPieDataSetConfig extends ICommonDataSet {
        sliceSpace?: number;
        selectionShift?: number;
        xValuePosition?: 'INSIDE_SLICE' | 'OUTSIDE_SLICE';
        yValuePosition?: 'INSIDE_SLICE' | 'OUTSIDE_SLICE';
        valueLinePart1Length?: number;
        valueLinePart2Length?: number;
        valueLineColor?: number;
        valueLineWidth?: number;
        valueLinePart1OffsetPercentage?: number;
        valueLineVariableLength?: boolean;
    }

    export interface IRadarDataSetConfig extends ICommonDataSet, ILineScatterCandleRadarDataSet, ILineRadarDataSet { }

    export interface IScatterDataSetConfig extends ICommonDataSet, IBarLineScatterCandleBubbleDataSet, ILineScatterCandleRadarDataSet {
        scatterShapeSize?: number;
        scatterShape?: 'SQUARE' | 'CIRCLE' | 'TRIANGLE' | 'CROSS' | 'X';
        scatterShapeHoleColor?: number;
        scatterShapeHoleRadius?: number;
    }

    // Data types
    interface ChartPoint {
        x: number;
        y: number;
        marker?: string;
        /* Следующие параметры используются только при "custom" markerType */

        /* Отдельные span-элементы текста, которым можно задать собственные стили, используются вместо marker для "custom" markerType.
         * Для переноса строки используется символ переноса - \n */
        markerTextSpans?: string[];
        markerColor?: number;
        // Маркер в форме флага
        isFlagTypeMarker?: boolean;
        /* Каждый элемент массива применяется к своему абзацу */
        markerTextColors?: number[];
        markerTextSizes?: number[];
        markerTextFontFamilies?: string[];
        disableShadow?: boolean;
    }

    export interface ILineDataSet {
        values: Array<number | ChartPoint>;
        label: string;
        config: ILineDataSetConfig;
    }

    export interface ILineData {
        dataSets: ILineDataSet[];
    }

    export interface IBarData {
        dataSets: Array<{
            values: Array<{ x?: number, y: number | number[], marker?: string | string[]} | number | number[]>
            label: string;
            config: IBarDataSetConfig;
        }>;
        config?: { barWidth?: number; group?: { fromX: number, groupSpace: number, barSpace: number } };
    }

    export interface IBubbleData {
        dataSets: Array<{
            values: Array<{ x?: number, y: number, size: number, marker?: string }>;
            label: string;
            config: IBubbleDataSetConfig;
        }>;
    }

    export interface ICandleData {
        dataSets: Array<{
            values: Array<{ x?: number, shadowH: number, shadowL: number, open: number, close: number, marker?: string }>;
            label: string;
            config: ICandleDataSetConfig;
        }>;
    }

    export interface IPieData {
        dataSets: Array<{
            values: Array<number | { value: number, label?: string }>;
            label: string;
            config: IPieDataSetConfig;
        }>;
    }

    export interface IRadarData {
        dataSets: Array<{
            values: Array<{ value: number } | number>;
            label: string;
            config: IRadarDataSetConfig;
        }>;
        labels: string[];
    }

    export interface IScatterData {
        dataSets: Array<{
            values: Array<{ x?: number, y: number, marker?: string } | number>;
            label: string;
            config: IScatterDataSetConfig;
        }>;
    }

    export interface ICombinedData {
        lineData?: ILineData;
        barData?: IBarData;
        scatterData?: IScatterData;
        candleData?: ICandleData;
        bubbleData?: IBubbleData;
    }

    // Props types

    export interface IViewPortOffsets {
        left?: number;
        top?: number;
        right?: number;
        bottom?: number;
    }

    export interface IVisibleRange {
        x?: { min?: number, max?: number };
        y?: { left?: { min?: number, max?: number }, right?: { min?: number, max?: number } };
    }

    export interface IBarLineChartBaseProps extends IChart {
        maxHighlightDistance?: number;
        drawGridBackground?: boolean;
        gridBackgroundColor?: number;

        drawBorders?: boolean;
        borderColor?: number;
        borderWidth?: number;

        minOffset?: number;
        maxVisibleValueCount?: number;
        visibleRange?: IVisibleRange;
        autoScaleMinMaxEnabled?: boolean;
        keepPositionOnRotation?: boolean;

        highlightPerDragEnabled?: boolean;

        scaleEnabled?: boolean;
        scaleXEnabled?: boolean;
        scaleYEnabled?: boolean;
        dragEnabled?: boolean;
        pinchZoom?: boolean;
        doubleTapToZoomEnabled?: boolean;

        yAxis?: { left?: IYAxis, right?: IYAxis };
        zoom?: { scaleX: number, scaleY: number, xValue: number, yValue: number, axisDependency?: 'LEFT' | 'RIGHT' };
        viewPortOffsets?: IViewPortOffsets;
        extraOffsets?: { left?: number, top?: number, right?: number, bottom?: number };

        group?: string;
        identifier?: string;
        syncX?: boolean;
        syncY?: boolean;

        onSelect?(event: any): void;
        onChange?(event: any): void;
        onTouchStart?(event: any): void;
        onTouchEnd?(event: any): void;
    }

    export interface IPieRadarChartBaseProps extends IChart {
        minOffset?: number;
        rotationEnabled?: number;
        rotationAngle?: number;
        onSelect?(event: any): void;
        onChange?(event: any): void;
        onTouchStart?(event: any): void;
        onTouchEnd?(event: any): void;
    }

    export interface ILineChartProps extends IBarLineChartBaseProps {
        data: ILineData;
    }

    export interface IBarChartProps extends IBarLineChartBaseProps {
        data: IBarData;
        drawValueAboveBar?: boolean;
        drawBarShadow?: boolean;
        highlightFullBarEnabled?: boolean;
    }

    export interface IBubbleChartProps extends IBarLineChartBaseProps {
        data: IBubbleData;
    }

    export interface ICandleStickChartProps extends IBarLineChartBaseProps {
        data: ICandleData;
    }

    export interface ICombinedChartProps extends IBarLineChartBaseProps {
        drawOrder?: Array<'BAR' | 'BUBBLE' | 'LINE' | 'CANDLE' | 'SCATTER'>;
        drawValueAboveBar?: boolean;
        highlightFullBarEnabled?: boolean;
        drawBarShadow?: boolean;
        data: ICombinedData;
    }

    export interface IHorizontalBarChartProps extends IBarLineChartBaseProps {
        data: IBarData;
        drawValueAboveBar?: boolean;
        drawBarShadow?: boolean;
        highlightFullBarEnabled?: boolean;
    }

    export interface IPieChartProps extends IPieRadarChartBaseProps {
        data: IPieData;

        extraOffsets?: { left?: number, top?: number, right?: number, bottom?: number };
        drawEntryLabels?: boolean;
        usePercentValues?: boolean;

        centerText?: string;
        styledCenterText?: { text?: string; color?: number; size?: number; fontFamily?: string };
        centerTextRadiusPercent?: number;
        holeRadius?: number;
        holeColor?: number;
        transparentCircleRadius?: number;
        transparentCircleColor?: number;

        entryLabelColor?: number;
        entryLabelTextSize?: number;
        entryLabelFontFamily?: string;
        maxAngle?: number;
    }

    export interface IRadarChartProps extends IPieRadarChartBaseProps {
        data: IRadarData;

        yAxis?: IYAxis;

        drawWeb?: boolean;
        skipWebLineCount?: number;

        webLineWidth?: number;
        webLineWidthInner?: number;
        webAlpha?: number;
        webColor?: number;
        webColorInner?: number;
    }

    export interface IScatterChartProps extends IBarLineChartBaseProps {
        data: IScatterData;
    }

    // Charts types

    export class LineChart extends React.PureComponent<ILineChartProps> {}
    export class BarChart extends React.PureComponent<IBarChartProps> {}
    export class BubbleChart extends React.PureComponent<IBubbleChartProps> {}
    export class CandleStickChart extends React.PureComponent<ICandleStickChartProps> {}
    export class CombinedChart extends React.PureComponent<ICombinedChartProps> {}
    export class HorizontalBarChart extends React.PureComponent<IHorizontalBarChartProps> {}
    export class PieChart extends React.PureComponent<IPieChartProps> {}
    export class RadarChart extends React.PureComponent<IRadarChartProps> {}
    export class ScatterChart extends React.PureComponent<IScatterChartProps> {}
}
