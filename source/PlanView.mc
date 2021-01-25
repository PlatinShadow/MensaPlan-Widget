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

        var value = Storage.getValue(dateKey);

        //There is only a single word in the string
        //which probably is a Holiday name
        if(value.find("\n") == null) {
            findDrawableById("text_food_meat").setText(value);
            return;
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


        //Check how many meal entries there are
        //If there are less then 4 then veggie and meat 
        //are the same meal
        if(meals.size() < 4) {
            findDrawableById("text_food_meat").setText(meals[1]);
            findDrawableById("text_food_veggie").setText(meals[1]);
            findDrawableById("text_food_dessert").setText(meals[2]);
        } else {
            findDrawableById("text_food_meat").setText(meals[1]);
            findDrawableById("text_food_veggie").setText(meals[2]);
            findDrawableById("text_food_dessert").setText(meals[3]);
        }
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    function onHide() {
    }

}
