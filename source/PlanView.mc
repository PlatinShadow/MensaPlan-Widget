using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Communications;
using Toybox.Application.Storage;
using Toybox.Graphics as Gfx;

class PlanView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.PlanLayout(dc));
    }

    function onShow() {
        //Get the time / date
        var time = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        var dateString = time.day.format("%02d") + "." + time.month.format("%02d") + "." + time.year;
        var dateKey    = time.day.format("%02d") +       time.month.format("%02d") +       (time.year - 2000);

        //Adjust date
        findDrawableById("text_date").setText(dateString);

        var plan = Storage.getValue(dateKey);

        //Check if today is a holiday
        if(plan["isHolidy"] == true) {
            findDrawableById("text_food_meat").setText(plan["holidayName"]);
            return;
        }

        //Check how many meal entries there are
        //If there are less then 4 then veggie and meat 
        //are the same meal
        if(plan["meals"].size() < 4) {
            findDrawableById("text_food_meat").setText(plan["meals"][1]);
            findDrawableById("text_food_veggie").setText(plan["meals"][1]);
            findDrawableById("text_food_dessert").setText(plan["meals"][2]);
        } else {
            findDrawableById("text_food_meat").setText(plan["meals"][1]);
            findDrawableById("text_food_veggie").setText(plan["meals"][2]);
            findDrawableById("text_food_dessert").setText(plan["meals"][3]);
        }
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    function onHide() {
    }

}
