using Toybox.WatchUi;
using Toybox.Graphics as Gfx;


class ErrorView extends WatchUi.View {

    hidden var errorCode    = null;
    hidden var errorMsg     = null;

    function initialize( _errorCode, _errorMsg ) {
        errorCode = _errorCode;
        errorMsg  = _errorMsg;
        View.initialize();
    }

    function onShow() {
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 15, Gfx.FONT_TINY, errorMsg, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 15, Gfx.FONT_TINY, "Code: " + errorCode, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_CENTER);

        dc.setPenWidth(4);
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_BLACK);
        dc.drawArc(dc.getWidth() / 2, dc.getHeight() / 2, 110, Gfx.ARC_CLOCKWISE, 90, 90);
    }

    function onHide() {

    }

}
