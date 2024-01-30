using Toybox.Application as App;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Time.Gregorian as Date;
using Toybox.ActivityMonitor as Mon;

class WatchFaceView extends Ui.WatchFace {

    var width,height;
    var u=0;
    var x,y;

    function initialize() {
        WatchFace.initialize();
        //loadBackground data from OS
        // Sys.println("WATCHFACE View: initialize ");
        var temp=App.getApp().getProperty(OSDATA);
        if(temp!=null) {bgdata=temp;}
        
        // var now=Sys.getClockTime();
    	// var ts=now.hour+":"+now.min.format("%02d");
        // // Sys.println("From OS: data="+bgdata+" "+counter+" at "+ts);  
    }

    // Load your resources here
    function onLayout(dc) as Void {
        width=dc.getWidth();
        height=dc.getHeight();
        x=width/2;
        y=height/2;
        
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc) as Void {
        var clockTime = Sys.getClockTime();    
        var hour12 = clockTime.hour % 12;
        hour12 = (hour12 == 0) ? 12 : hour12;    
        var timeString = Lang.format("$1$:$2$", [hour12, clockTime.min.format("%02d")]);
        var battery = getBattery();
        var date = getDate();
        var stepCount = getStepCountDisplay();
        var heartRate = getHeartRate();
        dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_TRANSPARENT);
        dc.drawText(x,height/2.75,Gfx.FONT_SYSTEM_NUMBER_THAI_HOT,timeString,Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width/2.85,height/4.5,Gfx.FONT_SYSTEM_TINY,battery,Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width/2.85,height/1.6,Gfx.FONT_SYSTEM_TINY,date,Gfx.TEXT_JUSTIFY_CENTER);
        dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_BLACK);
        dc.drawText(width/1.45,height/4.5,Gfx.FONT_SYSTEM_TINY,heartRate,Gfx.TEXT_JUSTIFY_CENTER);
        dc.setColor(Gfx.COLOR_BLUE,Gfx.COLOR_BLACK);
        dc.drawText(width/1.45,height/1.6,Gfx.FONT_SYSTEM_TINY,stepCount,Gfx.TEXT_JUSTIFY_CENTER);




        //draw arcs 
        dc.setColor(Gfx.COLOR_GREEN,Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(10);
        var arr=valueToArcAngles(bgdata[0]);
        dc.drawArc(x,y, height/2.08,Gfx.ARC_COUNTER_CLOCKWISE,arr[0], arr[1]);
        dc.setColor(Gfx.COLOR_BLUE,Gfx.COLOR_TRANSPARENT);
        arr=valueToArcAngles(bgdata[1]);
        dc.drawArc(x,y, height/2.3,Gfx.ARC_COUNTER_CLOCKWISE,arr[0], arr[1]);
        dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_TRANSPARENT);
        arr=valueToArcAngles(bgdata[2]);
        dc.drawArc(x,y, height/2.6,Gfx.ARC_COUNTER_CLOCKWISE,arr[0], arr[1]);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    function valueToArcAngles(value) as Array<Number>{
        var startAngle = 90;
        if(value==0){
            value=1;
        }
        var endAngle = startAngle + (value / 100.0) * 360;
        return [startAngle, endAngle];
    }

    function getBattery() {
        var battery = Sys.getSystemStats().battery;
        return Lang.format( "$1$%", [ battery.format( "%2d" ) ] );
    }
    function getDate() {
        var now = Time.now();
        var date = Date.info(now, Time.FORMAT_MEDIUM); 
        var dateString = Lang.format("$1$ $2$", [ date.day,date.month]);
        return dateString;
    }
    function getStepCountDisplay() {
    	var stepCount = Mon.getInfo().steps.toString();		    
        return Lang.format( "$1$", [ stepCount ] );	
    }
    function getHeartRate(){
        var heartRate=null;
        if (Mon has :getHeartRateHistory) {
            heartRate = Activity.getActivityInfo().currentHeartRate;
            if(heartRate==null) {
                var HRH=Mon.getHeartRateHistory(1, true);
                var HRS=HRH.next();
                if(HRS!=null && HRS.heartRate!= Mon.INVALID_HR_SAMPLE){
                    heartRate = HRS.heartRate;
                }
            }

            if(heartRate!=null) {
                heartRate = heartRate.toString();
            }
            else{
                heartRate = "--";
            }
        }
    return heartRate;
    }
}
