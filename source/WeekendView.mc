using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Graphics;

class AnimationDelegate extends WatchUi.AnimationDelegate {
    var view = null;

    function initialize( v ) {
        view = v;
        WatchUi.AnimationDelegate.initialize();
    }

    function onAnimationEvent(event, options)
    {
        if( event == WatchUi.ANIMATION_EVENT_COMPLETE ) {
           view.play();
        }
    }
}


class WeekendView extends WatchUi.View {
    hidden var animLayer    = null;
    hidden var drawLayer    = null;
    hidden var animDelegate = null;
    hidden var drawLayerDc  = null;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        if(Toybox.WatchUi has :AnimationLayer) {
            animLayer = new WatchUi.AnimationLayer(Rez.Drawables.fireworks, null);
            animDelegate = new AnimationDelegate(self);
            addLayer(animLayer);
        }

        drawLayer = new WatchUi.Layer({});
        addLayer(drawLayer);

        drawLayerDc  = drawLayer.getDc();
    }

    function onShow() {
        if(Toybox.WatchUi has :AnimationLayer) {
            play();
        }
    }

    function play() {
        animLayer.play({:delegate => animDelegate});
    }

    function onUpdate(dc) {
        if(Toybox.WatchUi has :AnimationLayer) {
            drawLayerDc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        } else {
            drawLayerDc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        }
        
        drawLayerDc.clear();

        drawLayerDc.drawText(drawLayerDc.getWidth() / 2, drawLayerDc.getHeight() / 2, Gfx.FONT_TINY, "It's Gaming Time", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

    function onHide() {

    }
}
