using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Application.Storage;
using Toybox.Time.Gregorian;
using Toybox.Time;

class MensaPlan extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        var time = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateKey = time.day.format("%02d") + time.month.format("%02d") + (time.year - 2000);
        var dateString = time.day.format("%02d") + "." + time.month.format("%02d") + "." + time.year;

        //Check if today is a Weekend Day
        if(time.day_of_week == Gregorian.DAY_SATURDAY || time.day_of_week == Gregorian.DAY_SUNDAY) {
            // Goto Weekend View
            return [ new WeekendView() ];
        }

        //TODO: PLEASE DON'T FORGET TO DELETE THIS LINE LMAO
        //      WE DON'T WANT TO REDOWNLOAD THIS SHIT EVERY TIME WE OPEN THE WIDGET
        ///Storage.clearValues();

        var plan = Storage.getValue(dateKey);

        //Check if the plan is in cache
        if(plan == null) {
            // Goto Download View
            return [ new DownloadView(dateKey, dateString) ];
        }

        //Plan is in cache so goto Plan View
        return [ new PlanView(plan, dateString) ];
    }
}