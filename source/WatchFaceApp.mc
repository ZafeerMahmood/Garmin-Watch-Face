import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Background;
using Toybox.System as Sys;
using Toybox.Application as App;

// var counter=0;
var bgdata=[0,0,0];
// var canDoBG=false;
// var inBackground=false;	

// var OSCOUNTER="oscounter";
var OSDATA="osdata";

(:background)
class WatchFaceApp extends Application.AppBase {

    function initialize() {
        // Sys.println("WatchFaceApp.initialize");
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        // Sys.println("onStart Called");
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        // Sys.println("onStop Called"); 
    	// moved from onHide() - using the "is this background" trick
    	// if(!inBackground) {
	    // 	// var now=Sys.getClockTime();
    	// 	// var ts=now.hour+":"+now.min.format("%02d");        
        // 	// Sys.println("onStop counter="+counter+" "+ts);    
    	// 	// App.getApp().setProperty(OSCOUNTER, counter);     
    	// } else {
    	// 	// Sys.println("onStop");
    	// }
    }

    // Return the initial view of your application here
    function getInitialView() {
        // Sys.println("getInitialView");
    	if(Toybox.System has :ServiceDelegate) {
    		// canDoBG=true;
    		Background.registerForTemporalEvent(new Time.Duration(5 * 60));
    	} else {
    		// Sys.println("****background not available on this device****");
    	}
        return [ new WatchFaceView() ];
    }

    function getServiceDelegate(){
    	// var now=Sys.getClockTime();
    	// var ts=now.hour+":"+now.min.format("%02d");    
    	// Sys.println("getServiceDelegate: "+ts);
        return [new BgServiceDelegate()];
    }

    function onBackgroundData(data) {
    	// counter++;
    	// var now=Sys.getClockTime();
    	// var ts=now.hour+":"+now.min.format("%02d");
        // Sys.println("onBackgroundData="+data+" "+counter+" at "+ts);
        bgdata=data;
        App.getApp().setProperty(OSDATA,bgdata);
        WatchUi.requestUpdate();
    }   

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

}

function getApp() as WatchFaceApp {
    return Application.getApp() as WatchFaceApp;
}