using Toybox.Background;
using Toybox.System as Sys;
using Toybox.System;
using Toybox.Application.Storage;
using Toybox.Communications;
import Toybox.Lang;
import Toybox.Math;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.

(:background)
class BgServiceDelegate extends Toybox.System.ServiceDelegate {
	function initialize() {
		Sys.ServiceDelegate.initialize();
		// inBackground=true;
	}
	
    function onTemporalEvent() {
        // System.println("onTemporalEvent");
        //make request in background
        makeRequest();
        
    }

    function onReceive(responseCode as Number , data as  Null|Dictionary|String) as Void {
        // System.println("onReceive");
        var health = (Math.rand() %100 +1);
        var prod = (Math.rand() %100 +1);
        var metric = (Math.rand() %100 +1);

        System.println(" Poki: " + data);
        if (responseCode == 200) {
            
            // System.println("Request Successful");        
            // System.println("health: " + health);        
        }
        else {
            // System.println("Response: " + responseCode);           
        }
        Sys.println("bg exit: " + health + " " + prod + " " + metric);
        Background.exit([health,prod,metric]);
    }

    function makeRequest() as Void {
        // System.println("Making Request"); 
        //endpoint to smiluate request
        var url = "https://pokeapi.co/api/v2/pokemon";                       
        var params = {
            "limit" => "1"
        };

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON 
        };                
        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }
    

}
