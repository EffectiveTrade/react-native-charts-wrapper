//
//  CustomMarker.swift
//  application
//

import Foundation

import Charts

import SwiftyJSON


open class CustomMarker: MarkerView {
    open var color = UIColor.white
    open var arrowSize = CGSize(width: 12, height: 6)
    open var radius = CGFloat(4)
    open var font: UIFont?
    open var textColor: UIColor?
    open var minimumSize = CGSize(width: 32, height: 12)
    open var entry: ChartDataEntry?
    open var viewPortHandler: ViewPortHandler

    fileprivate var insets = UIEdgeInsets.init(top: 12.0, left: 16.0, bottom: 18.0, right: 16.0)
    fileprivate var topInsets = UIEdgeInsets.init(top: 18.0, left: 16.0, bottom: 12.0, right: 16.0)
    fileprivate var flagMarkerInsets = UIEdgeInsets.init(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)

    fileprivate var labelns: NSAttributedString?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _size: CGSize = CGSize()


    public init(viewPortHandler: ViewPortHandler) {
        self.viewPortHandler = viewPortHandler
        super.init(frame: CGRect.zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }


    func drawRect(context: CGContext, point: CGPoint) -> CGRect{

        let chart = super.chartView

        let width = _size.width

        context.saveGState()

        let shadowColor = UIColor(red: 0.21, green: 0.22, blue: 0.29, alpha: 0.12)

        var disableShadow = false
        if let object = entry?.data as? JSON {
            if object["disableShadow"].exists() {
                disableShadow = object["disableShadow"].boolValue
            }
        }


        if !disableShadow {
            context.setShadow(
                offset: CGSize(width: 0, height: 4),
                blur: 12.0,
                color: shadowColor.cgColor)
        }


        var rect = CGRect(origin: point, size: _size)

        var isFlagTypeMarker = false
        if let object = entry?.data as? JSON {
            if object["isFlagTypeMarker"].exists() {
                isFlagTypeMarker = object["isFlagTypeMarker"].boolValue
            }
        }

        if isFlagTypeMarker {

            _size.height = _labelSize.height + self.flagMarkerInsets.top + self.flagMarkerInsets.bottom
            _size.height = max(minimumSize.height, _size.height)
            rect = CGRect(origin: point, size: _size)


            if point.y - (chart?.bounds.height)! / 3 < 0 {

                rect.origin.y += (chart?.bounds.height)! / 8

                drawFlagStaff(context: context, origin: 0, point: point, chartBound: viewPortHandler.contentBottom, toTop: true)

                if point.x - (chart?.bounds.width)! / 2 < 0 {
                    drawRightFlagRect(context: context, rect: rect)
                } else {
                    rect.origin.x -= _size.width
                    drawLeftFlagRect(context: context, rect: rect)
                }

                rect.origin.x += self.flagMarkerInsets.left
                rect.origin.y += self.flagMarkerInsets.top
                rect.size.height -= self.flagMarkerInsets.top + self.flagMarkerInsets.bottom

            } else {

                rect.origin.y -= (chart?.bounds.height)! / 8 + _size.height

                drawFlagStaff(context: context, origin: rect.origin.y, point: point, chartBound: viewPortHandler.contentBottom, toTop: false)

                if point.x - (chart?.bounds.width)! / 2 < 0 {
                    drawRightFlagRect(context: context, rect: rect)
                } else {
                    rect.origin.x -= _size.width
                    drawLeftFlagRect(context: context, rect: rect)
                }

                rect.origin.x += self.flagMarkerInsets.left
                rect.origin.y += self.flagMarkerInsets.top
                rect.size.height -= self.flagMarkerInsets.top + self.flagMarkerInsets.bottom

            }

        } else {

            if point.y - _size.height < 0 {

                if point.x - _size.width / 2.0 < 0 {
                    drawTopLeftRect(context: context, rect: rect)
                } else if (chart != nil && point.x + width - _size.width / 2.0 > (chart?.bounds.width)!) {
                    rect.origin.x -= _size.width
                    drawTopRightRect(context: context, rect: rect)
                } else {
                    rect.origin.x -= _size.width / 2.0
                    drawTopCenterRect(context: context, rect: rect)
                }

                rect.origin.x += self.topInsets.left
                rect.origin.y += self.topInsets.top
                rect.size.height -= self.topInsets.top + self.topInsets.bottom

            } else {

                rect.origin.y -= _size.height

                if point.x - _size.width / 2.0 < 0 {
                    drawLeftRect(context: context, rect: rect)
                } else if (chart != nil && point.x + width - _size.width / 2.0 > (chart?.bounds.width)!) {
                    rect.origin.x -= _size.width
                    drawRightRect(context: context, rect: rect)
                } else {
                    rect.origin.x -= _size.width / 2.0
                    drawCenterRect(context: context, rect: rect)
                }

                rect.origin.x += self.insets.left
                rect.origin.y += self.insets.top
                rect.size.height -= self.insets.top + self.insets.bottom

            }
              }

        context.restoreGState()

        return rect
    }

    func drawCenterRect(context: CGContext, rect: CGRect) {
        context.setFillColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x + radius, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + radius), radius: radius, startAngle: CGFloat(-90 * Double.pi / 180), endAngle: CGFloat(0 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + rect.size.height - arrowSize.height - radius), radius: radius, startAngle: CGFloat(0 * Double.pi / 180), endAngle: CGFloat(90 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height - arrowSize.height - radius), radius: radius, startAngle: CGFloat(90 * Double.pi / 180), endAngle: CGFloat(180 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + radius))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + radius), radius: radius, startAngle: CGFloat(180 * Double.pi / 180), endAngle: CGFloat(-90 * Double.pi / 180), clockwise: false)
        context.fillPath()
    }

    func drawLeftRect(context: CGContext, rect: CGRect) {
        context.setFillColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x + radius, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + radius), radius: radius, startAngle: CGFloat(-90 * Double.pi / 180), endAngle: CGFloat(0 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - arrowSize.height - radius))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + rect.size.height - arrowSize.height - radius), radius: radius, startAngle: CGFloat(0 * Double.pi / 180), endAngle: CGFloat(90 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + arrowSize.width / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + radius))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + radius), radius: radius, startAngle: CGFloat(180 * Double.pi / 180), endAngle: CGFloat(-90 * Double.pi / 180), clockwise: false)
        context.fillPath()
    }

    func drawRightRect(context: CGContext, rect: CGRect) {
        context.setFillColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x + radius, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + radius), radius: radius, startAngle: CGFloat(-90 * Double.pi / 180), endAngle: CGFloat(0 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x  + rect.size.width - arrowSize.width / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height - arrowSize.height - radius), radius: radius, startAngle: CGFloat(90 * Double.pi / 180), endAngle: CGFloat(180 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + radius))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + radius), radius: radius, startAngle: CGFloat(180 * Double.pi / 180), endAngle: CGFloat(-90 * Double.pi / 180), clockwise: false)
        context.fillPath()
    }

    func drawTopCenterRect(context: CGContext, rect: CGRect) {
        context.setFillColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + arrowSize.height))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + arrowSize.height + radius), radius: radius, startAngle: CGFloat(-90 * Double.pi / 180), endAngle: CGFloat(0 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - radius))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + rect.size.height - radius), radius: radius, startAngle: CGFloat(0 * Double.pi / 180), endAngle: CGFloat(90 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height - radius), radius: radius, startAngle: CGFloat(90 * Double.pi / 180), endAngle: CGFloat(180 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + arrowSize.height + radius))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + arrowSize.height + radius), radius: radius, startAngle: CGFloat(180 * Double.pi / 180), endAngle: CGFloat(-90 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y))
        context.fillPath()
    }

    func drawTopLeftRect(context: CGContext, rect: CGRect) {
        context.setFillColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + arrowSize.width / 2.0, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + arrowSize.height))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + arrowSize.height + radius), radius: radius, startAngle: CGFloat(-90 * Double.pi / 180), endAngle: CGFloat(0 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - radius))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + rect.size.height - radius), radius: radius, startAngle: CGFloat(0 * Double.pi / 180), endAngle: CGFloat(90 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height - radius), radius: radius, startAngle: CGFloat(90 * Double.pi / 180), endAngle: CGFloat(180 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.fillPath()
    }

    func drawTopRightRect(context: CGContext, rect: CGRect) {
        context.setFillColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - radius))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + rect.size.height - radius), radius: radius, startAngle: CGFloat(0 * Double.pi / 180), endAngle: CGFloat(90 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height - radius), radius: radius, startAngle: CGFloat(90 * Double.pi / 180), endAngle: CGFloat(180 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + arrowSize.height - radius))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + arrowSize.height + radius), radius: radius, startAngle: CGFloat(180 * Double.pi / 180), endAngle: CGFloat(-90 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width - arrowSize.width / 2.0, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
        context.fillPath()
    }

    func drawRightFlagRect(context: CGContext, rect: CGRect) {
        context.setFillColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + radius), radius: radius, startAngle: CGFloat(-90 * Double.pi / 180), endAngle: CGFloat(0 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - radius))
        context.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radius, y: rect.origin.y + rect.size.height - radius), radius: radius, startAngle: CGFloat(0 * Double.pi / 180), endAngle: CGFloat(90 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.fillPath()
    }

    func drawLeftFlagRect(context: CGContext, rect: CGRect) {
        context.setFillColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x + radius, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height - radius), radius: radius, startAngle: CGFloat(90 * Double.pi / 180), endAngle: CGFloat(180 * Double.pi / 180), clockwise: false)
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + radius))
        context.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + radius), radius: radius, startAngle: CGFloat(180 * Double.pi / 180), endAngle: CGFloat(-90 * Double.pi / 180), clockwise: false)
        context.fillPath()
    }

    func drawFlagStaff(context: CGContext, origin: CGFloat, point: CGPoint, chartBound: CGFloat, toTop: Bool) {
        let offset = CGFloat(8)

        if toTop {
            context.beginPath()
            context.move(to: CGPoint(x: point.x, y: point.y + offset))
            context.addLine(to: CGPoint(x: point.x, y: chartBound))
        } else {
            context.beginPath()
            context.move(to: CGPoint(x: point.x, y: origin))
            context.addLine(to: CGPoint(x: point.x, y: toTop ? point.y + offset : point.y - offset))
            context.move(to: CGPoint(x: point.x, y: toTop ? point.y - offset : point.y + offset))
            context.addLine(to: CGPoint(x: point.x, y: chartBound))
        }

        context.setStrokeColor(color.cgColor)
        context.setLineWidth(2)
        context.setLineDash(phase: 0, lengths: [4, 4])

        context.strokePath()
    }


    open override func draw(context: CGContext, point: CGPoint) {
        if (labelns == nil || labelns?.length == 0) {
            return
        }

        context.saveGState()

        let rect = drawRect(context: context, point: point)

        UIGraphicsPushContext(context)

        labelns?.draw(in: rect)

        UIGraphicsPopContext()

        context.restoreGState()
    }

    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {

        self.entry = entry

        let attrString = NSMutableAttributedString()

        if let object = entry.data as? JSON {

            var textSpans = [] as [String]
            var textFontFamilies = [] as [String]
            var textColors = [] as [Int]
            var textSizes = [] as [Int]

            if object["markerTextSpans"].exists() {
                textSpans = object["markerTextSpans"].arrayValue.map { $0.stringValue }
            }

            if object["markerColor"].exists() {
                let markerColor = object["markerColor"].intValue
                color = RCTConvert.uiColor(markerColor)
            } else {
                color = UIColor.white
            }

            if object["markerTextFontFamilies"].exists() {
                textFontFamilies = object["markerTextFontFamilies"].arrayValue.map { $0.stringValue }
            }

            if object["markerTextColors"].exists() {
                textColors = object["markerTextColors"].arrayValue.map { $0.intValue }
            }

            if object["markerTextSizes"].exists() {
                textSizes = object["markerTextSizes"].arrayValue.map { $0.intValue }
            }

            for (index, element) in textSpans.enumerated() {
                let fontName = index < textFontFamilies.count ? textFontFamilies[index] : UIFont.systemFont(ofSize: 12).familyName
                let fontSize = index < textSizes.count ? textSizes[index] : 12
                let fontColor = index < textColors.count ? RCTConvert.uiColor(textColors[index]) ?? UIColor.black : UIColor.black

                let attributes = [NSAttributedString.Key.font: UIFont(name: fontName, size: CGFloat(fontSize)) ?? UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: fontColor, NSAttributedString.Key.baselineOffset: 4] as [NSAttributedString.Key : Any]

                attrString.append(NSMutableAttributedString(string: String(element), attributes: attributes))
            }
        }

        labelns = attrString as NSAttributedString

        _labelSize = labelns?.size() ?? CGSize.zero
        _size.width = _labelSize.width + self.insets.left + self.insets.right
        _size.height = _labelSize.height + self.insets.top + self.insets.bottom
        _size.width = max(minimumSize.width, _size.width)
        _size.height = max(minimumSize.height, _size.height)
    }
}
