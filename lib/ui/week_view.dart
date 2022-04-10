import 'dart:math';
import 'package:beer_tracker/entry_storage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as com;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import '../helpers/date_helper.dart';

class WeekViewConstants {
  static charts.Color glass = charts.Color.fromHex(code: "#DDDEDF");
  static charts.Color beer = charts.Color.fromHex(code: "#E6A52E");
  static charts.Color white = charts.Color.fromHex(code: "#FFFFFF");
}

class WeekView extends StatelessWidget {
  final String title;
  final String subtitle;

  WeekView({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    var place = FutureBuilder(
        future: EntryStorage.get().countEntriesByDay(),
        builder: (context, AsyncSnapshot<List<int>> snap) {
          if (snap.hasData) {
            final chart = charts.BarChart(
              [
                charts.Series<int, String>(
                  data: snap.requireData,
                  fillColorFn: (datum, index) => WeekViewConstants.beer,
                  domainFn: (datum, index) => WeekdaysNames.short[index!],
                  measureFn: (datum, index) => datum,
                  labelAccessorFn: (datum, index) => '${datum.toString()}',
                  insideLabelStyleAccessorFn: (datum, index) =>
                      charts.TextStyleSpec(color: charts.Color.white, fontWeight: "600"),
                  outsideLabelStyleAccessorFn: (datum, index) => charts.TextStyleSpec(color: charts.Color.white),
                  id: "",
                )
              ],
              animate: true,
              barRendererDecorator: BeerBarRendererDecorator(),
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.NoneRenderSpec(),
              ),
              domainAxis: charts.OrdinalAxisSpec(
                showAxisLine: false,
                renderSpec: GlassBottomRendererSpec(
                    labelStyle: charts.TextStyleSpec(color: WeekViewConstants.glass),
                    lineStyle: charts.LineStyleSpec(color: WeekViewConstants.glass, thickness: 3),
                    tickLengthPx: 10,
                    tickWidth: 34),
              ),
            );
            return chart;
          }
          return Text("loading");
        });
    return SizedBox(
      child: Container(
        child: place,
        padding: EdgeInsets.only(top: 32),
      ),
      height: 300,
      width: 380,
    );
  }
}

class BeerBarRendererDecorator<D> extends charts.BarLabelDecorator<D> {
  BeerBarRendererDecorator() : super(labelAnchor: com.BarLabelAnchor.middle, labelPadding: 7);

  @override
  void decorate(Iterable<com.ImmutableBarRendererElement<D>> barElements, charts.ChartCanvas canvas,
      charts.GraphicsFactory graphicsFactory,
      {required Rectangle<int> drawBounds,
      required double animationPercent,
      required bool renderingVertically,
      bool rtl = false}) {
    super.decorate(barElements, canvas, graphicsFactory,
        drawBounds: drawBounds, animationPercent: animationPercent, renderingVertically: renderingVertically);
    for (var elem in barElements) {
      canvas.drawingView = 'beerDecorator' + elem.index.toString();
      final rect = elem.bounds;
      if (rect != null && elem.datum > 0) {
        final Point tl = Point(rect.left, rect.top - rect.width / 4);
        final Point tr = Point(rect.right, rect.top - rect.width / 4);
        final Point glasstl = Point(rect.left, drawBounds.top);
        final Point glasstr = Point(rect.right, drawBounds.top);
        canvas.drawRRect(Rectangle.fromPoints(tl, rect.topRight),
            fill: WeekViewConstants.white, radius: 10, roundTopLeft: true, roundTopRight: true);
        canvas.drawLine(
            points: [glasstl, glasstr, rect.bottomRight, rect.bottomLeft, glasstl, glasstr],
            stroke: WeekViewConstants.glass,
            strokeWidthPx: 3,
            fill: WeekViewConstants.white);
        canvas.drawingView = null;
      }
    }
  }
}

class GlassBottomDrawStrategy<D> extends com.BaseTickDrawStrategy<D> {
  int tickLength;
  com.LineStyle lineStyle;
  int tickWidth;

  GlassBottomDrawStrategy(ChartContext chartContext, GraphicsFactory graphicsFactory,
      {int? tickLengthPx,
      LineStyleSpec? lineStyleSpec,
      TextStyleSpec? labelStyleSpec,
      LineStyleSpec? axisLineStyleSpec,
      TickLabelAnchor? labelAnchor,
      TickLabelJustification? labelJustification,
      int? labelOffsetFromAxisPx,
      int? labelCollisionOffsetFromAxisPx,
      int? labelOffsetFromTickPx,
      int? labelCollisionOffsetFromTickPx,
      int? minimumPaddingBetweenLabelsPx,
      int? labelRotation,
      int? labelCollisionRotation,
      int? tickWidthPx})
      : tickLength = tickLengthPx ?? 0,
        lineStyle = StyleFactory.style.createGridlineStyle(graphicsFactory, lineStyleSpec),
        this.tickWidth = tickWidthPx ?? 0,
        super(chartContext, graphicsFactory,
            labelStyleSpec: labelStyleSpec,
            axisLineStyleSpec: axisLineStyleSpec ?? lineStyleSpec,
            labelAnchor: labelAnchor,
            labelJustification: labelJustification,
            labelOffsetFromAxisPx: labelOffsetFromAxisPx ?? (tickLengthPx! + 3),
            labelCollisionOffsetFromAxisPx: labelCollisionOffsetFromAxisPx,
            labelOffsetFromTickPx: labelOffsetFromTickPx,
            labelCollisionOffsetFromTickPx: labelCollisionOffsetFromTickPx,
            minimumPaddingBetweenLabelsPx: minimumPaddingBetweenLabelsPx,
            labelRotation: labelRotation,
            labelCollisionRotation: labelCollisionRotation);

  @override
  void draw(
    ChartCanvas canvas,
    com.Tick<D> tick, {
    required com.AxisOrientation orientation,
    required Rectangle<int> axisBounds,
    required Rectangle<int> drawAreaBounds,
    required bool isFirst,
    required bool isLast,
    bool collision = false,
  }) {
    Point<num> a, b, c, d;
    final tickLocationPx = tick.locationPx!;
    num width, height, x, y;
    switch (orientation) {
      case com.AxisOrientation.top:
        x = tickLocationPx - tickWidth / 2;
        y = axisBounds.bottom - tickLength;
        width = tickWidth;
        height = tickLength;
        break;
      case com.AxisOrientation.bottom:
        x = tickLocationPx - tickWidth / 2;
        y = axisBounds.top;
        width = tickWidth;
        height = tickLength;
        break;
      case com.AxisOrientation.right:
        y = tickLocationPx - tickWidth / 2;
        x = axisBounds.left;
        width = tickLength;
        height = tickWidth;
        break;
      case com.AxisOrientation.left:
        y = tickLocationPx - tickWidth / 2;
        x = axisBounds.right - tickLength;
        width = tickLength;
        height = tickWidth;
        break;
    }
    canvas.drawRRect(Rectangle(x, y, width, height),
        fill: lineStyle.color, radius: 3, roundBottomLeft: true, roundBottomRight: true);
    drawLabel(canvas, tick,
        orientation: orientation,
        axisBounds: axisBounds,
        drawAreaBounds: drawAreaBounds,
        isFirst: isFirst,
        isLast: isLast,
        collision: collision);
  }
}

class GlassBottomRendererSpec<D> extends charts.SmallTickRendererSpec<D> {
  final int? tickWidth;
  const GlassBottomRendererSpec({
    TextStyleSpec? labelStyle,
    LineStyleSpec? lineStyle,
    LineStyleSpec? axisLineStyle,
    TickLabelAnchor? labelAnchor,
    TickLabelJustification? labelJustification,
    int? tickLengthPx,
    int? labelOffsetFromAxisPx,
    int? labelCollisionOffsetFromAxisPx,
    int? labelOffsetFromTickPx,
    int? labelCollisionOffsetFromTickPx,
    int? minimumPaddingBetweenLabelsPx,
    int? labelRotation,
    int? labelCollisionRotation,
    int? tickWidth,
  })  : this.tickWidth = tickWidth,
        super(
            labelStyle: labelStyle,
            lineStyle: lineStyle,
            labelAnchor: labelAnchor,
            labelJustification: labelJustification,
            labelOffsetFromAxisPx: labelOffsetFromAxisPx,
            labelCollisionOffsetFromAxisPx: labelCollisionOffsetFromAxisPx,
            labelOffsetFromTickPx: labelOffsetFromTickPx,
            labelCollisionOffsetFromTickPx: labelCollisionOffsetFromTickPx,
            minimumPaddingBetweenLabelsPx: minimumPaddingBetweenLabelsPx,
            labelRotation: labelRotation,
            labelCollisionRotation: labelCollisionRotation,
            tickLengthPx: tickLengthPx,
            axisLineStyle: axisLineStyle);

  @override
  com.BaseTickDrawStrategy<D> createDrawStrategy(ChartContext context, GraphicsFactory graphicsFactory) =>
      GlassBottomDrawStrategy(context, graphicsFactory,
          tickLengthPx: tickLengthPx,
          lineStyleSpec: lineStyle,
          labelStyleSpec: labelStyle,
          axisLineStyleSpec: axisLineStyle,
          labelAnchor: labelAnchor,
          labelJustification: labelJustification,
          labelOffsetFromAxisPx: labelOffsetFromAxisPx,
          labelCollisionOffsetFromAxisPx: labelCollisionOffsetFromAxisPx,
          labelOffsetFromTickPx: labelOffsetFromTickPx,
          labelCollisionOffsetFromTickPx: labelCollisionOffsetFromTickPx,
          minimumPaddingBetweenLabelsPx: minimumPaddingBetweenLabelsPx,
          labelRotation: labelRotation,
          labelCollisionRotation: labelCollisionRotation,
          tickWidthPx: this.tickWidth);
}
