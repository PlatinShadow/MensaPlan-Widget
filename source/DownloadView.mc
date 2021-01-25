using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Communications;
using Toybox.Application.Storage;
using Toybox.Graphics as Gfx;
using Toybox.Lang;

class DownloadView extends WatchUi.View {

    hidden var dwnldProgress    = 0.8;

    function initialize() {
        View.initialize();
    }

    function onReceive(responseCode, data) {
        if(responseCode != 200) {
            return;
        }

        //Clear local Storage
        System.println("Clearing local cache...");
        Storage.clearValues();

        //Write new plan to Storage
        var keys = data.keys();
        var size = keys.size();
        for(var i = 0; i < size; i++) {
            var value = data.get(keys[i]);
            var plan = { };

            //There is only a single word in the string
            //and which probably is a Holiday name
            if(value.find("\n") == null) {
                plan["isHoliday"] = true;
                plan["holidayName"] = value;
                Storage.setValue(keys[i], plan);
                continue;
            }

            //Process data if there is more than one newLine
            //Each line holds one meal
            var index = 0;
            var pos = value.find("\n");
            var meals = [];
            while(pos != null) {
                meals.add(value.substring(0, pos));

                value = value.substring(pos+1, value.length());
                pos = value.find("\n");

                index++;
            }

            //Add last item to array
            meals.add(value.substring(0, value.length()));
            plan["meals"] = meals;
            plan["isHoliday"] = false;


            //Save plan to Storage
            Storage.setValue(keys[i], plan);
        }

        WatchUi.switchToView(new PlanView(), new WatchUi.InputDelegate(), WatchUi.SLIDE_LEFT);
    }

    function onShow() {
            System.println("Starting Plan Download....");

        var options = {                                             
           :method => Communications.HTTP_REQUEST_METHOD_GET,
           :headers => {
                   "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            },

           :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON                                 
       };

        //Send web request to firebase db
        Communications.makeWebRequest("https://georgii-app-6e295.firebaseio.com/Mensa.json", null, options, method(:onReceive));
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Gfx.FONT_TINY, "Loading Plan", Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_CENTER);

        //yes this "progress bar" is basicaly just a prank
        //because you can't update the displays while doing some other task
        //because garmin has never heard of multi threading
        //TODO: implement something that does not have a for loop
        //Or only loop through 20 items at a time and then update display
        dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_BLACK);

        dc.setPenWidth(4);
        dc.drawArc(dc.getWidth() / 2, dc.getHeight() / 2, 110, Gfx.ARC_CLOCKWISE, 90, 90 + (360*dwnldProgress));
    }

    function onHide() {

    }

}
