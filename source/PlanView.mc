using Toybox.WatchUi;
using Toybox.Graphics as Gfx;

class PlanView extends WatchUi.View {

    hidden var plan;
    hidden var date;

    function initialize( _plan, _date ) {
        plan = _plan;
        date = _date;
        View.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.PlanLayout(dc));
    }

    function onShow() {
        //Adjust date
        findDrawableById("text_date").setText(date);

        //There is only a single word in the string
        //which probably is a Holiday name
        //TODO: move this to MensPlanApp.mc, and add some cool view
        //      for when there is a holiday
        if(plan.find("\n") == null) {
            findDrawableById("text_food_meat").setText(plan);
            return;
        }

        //Process data if there is more than one newLine
        //Each line holds one meal
        var pos = plan.find("\n");
        var meals = [];
        while(pos != null) {
            meals.add(plan.substring(0, pos));

            plan = plan.substring(pos+1, plan.length());
            pos = plan.find("\n");
        }
        
        //Add last item to array
        meals.add(plan);

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
