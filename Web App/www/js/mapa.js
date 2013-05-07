var watchID = null;
var mylat = null;
var mylng = null;
var tskloc = null;
var myloc = null;
var bimage;
var gimage;
var shadow;

$('#page-map').live('pageinit', function(event) {
    $('#map_canvas').gmap('addControl', 'controls', google.maps.ControlPosition.BOTTOM_CENTER);
    $('div#controls').css('display', 'inline').css('opacity', '0.7');

    $('div#controls a#myloc').click(function() {
        startwatching();
    });

});
$('#page-map').live('pageshow', function() {
    if (isconnected) {
        //Create blue, green and shadow images for custom markers
        bimage = new google.maps.MarkerImage('img/markers/bimage.png',
        new google.maps.Size(20, 34), new google.maps.Point(0, 0),
        new google.maps.Point(10, 34));

        gimage = new google.maps.MarkerImage('img/markers/gimage.png',
        new google.maps.Size(20, 34), new google.maps.Point(0, 0),
        new google.maps.Point(10, 34));

        shadow = new google.maps.MarkerImage('img/markers/shadow.png',
        new google.maps.Size(40, 34), new google.maps.Point(0, 0),
        new google.maps.Point(10, 34));
    }
    var info = "Task Location";
    if (window.localStorage.getItem("scriptlat0") && window.localStorage.getItem("scriptlng0")) tskloc = new google.maps.LatLng((window.localStorage.getItem("scriptlat0") + 0.0), (window.localStorage.getItem("scriptlng0") + 0.0));
    else tskloc = new google.maps.LatLng(window.localStorage.getItem("campuslat"), window.localStorage.getItem("campuslng"));
    $('#map_canvas').gmap('addMarker', {
        'position': tskloc,
        'icon': bimage,
        animation: google.maps.Animation.DROP,
        'shadow': shadow,
        'shape': shadowShape,
        'bounds': true
    }).click(function(e) {
        $('#map_canvas').gmap('openInfoWindow', {
            'content': info
        }, this);
    });

    //startwatching();
});


$('#page-map').live("pagehide", function() {
    // Remove all markers when leaving map page - user may edit markers
    $('#map_canvas').gmap('clear', 'markers');
    //google.maps.event.clearInstanceListeners(marker);
    mylat = null;
    mylng = null;
    //clearWatch();
});

//function getroute() {
//
//    if (mylat != null && mylng != null) {
//        $('#map_canvas').gmap('clear', 'markers');
//        $('#map_canvas').gmap('displayDirections', {
//            'origin': new google.maps.LatLng(mylat, mylng),
//            'destination': new google.maps.LatLng(43.676082, -79.410038),
//            'travelMode': google.maps.DirectionsTravelMode.DRIVING
//        },
//
//        function(result, status) {
//            if (status === 'OK') {
//                var center = result.routes[0].bounds.getCenter();
//                $('#map_canvas').gmap('option', 'center', center);
//                $('#map_canvas').gmap('refresh');
//            } else {
//                alert('Unable to get route');
//            }
//        });
//    } else {
//        alert("Your location has not been found yet!");
//    }
//
//}


function startwatching() {
    showloading();
    var options = {
        enableHighAccuracy: true
    };
    // watchID = navigator.geolocation.watchPosition(onSuccess, onError, options);
    navigator.geolocation.getCurrentPosition(onSuccess, onError, options);
}


// onSuccess Geolocation
//

function onSuccess(position) {
    mylat = position.coords.latitude;
    mylng = position.coords.longitude;
    myloc = new google.maps.LatLng(mylat, mylng);
    var info = getdistance(tskloc.lat(), tskloc.lng(), mylat, mylng).toFixed(3);
    if (info < 1) info = (info * 1000) + " m";
    else info += " km";
    $('#map_canvas').gmap('find', 'markers', {
        'property': 'tags',
        'value': 'myloc'
    }, function(marker, isFound) {
        if (isFound) {
            marker.setMap(null);
        }
    });
    $('#map_canvas').gmap('addMarker', {
        'tags': 'myloc',
        'position': myloc,
        animation: google.maps.Animation.DROP,
        'icon': gimage,
        'shadow': shadow,
        'shape': shadowShape,
        'bounds': true
    }).click(function(e) {
        $('#map_canvas').gmap('openInfoWindow', {
            'content': 'You are ' + info + ' far from task.'
        }, this); ///////SET REAL CONTENT HERE
    });
    hideloading();
    //clearWatch();
}

// clear the watch that was started earlier
//

function clearWatch() {
    if (watchID !== null) {
        //navigator.geolocation.clearWatch(watchID);
        //navigator.compass.clearWatch(watchID);

        watchID = null;
    }
}
// onError Callback receives a PositionError object
//

function onError(error) {
    hideloading();
    alert('code: ' + error.code + '\n' +
        'message: ' + error.message + '\n');
}


var shadowShape = {
    'type': 'poly',
    'coords': [13, 0, 15, 1, 16, 2, 17, 3, 18, 4, 18, 5, 19, 6, 19, 7, 19, 8,
    19, 9, 19, 10, 19, 11, 19, 12, 19, 13, 18, 14, 18, 15, 17, 16, 16,
    17, 15, 18, 14, 19, 14, 20, 13, 21, 13, 22, 12, 23, 12, 24, 12, 25,
    12, 26, 11, 27, 11, 28, 11, 29, 11, 30, 11, 31, 11, 32, 11, 33, 8,
    33, 8, 32, 8, 31, 8, 30, 8, 29, 8, 28, 8, 27, 8, 26, 7, 25, 7, 24,
    7, 23, 6, 22, 6, 21, 5, 20, 5, 19, 4, 18, 3, 17, 2, 16, 1, 15, 1,
    14, 0, 13, 0, 12, 0, 11, 0, 10, 0, 9, 0, 8, 0, 7, 0, 6, 1, 5, 1, 4,
    2, 3, 3, 2, 4, 1, 6, 0, 13, 0]
};


function getdistance(originlat, originlng, destinationlat, destinationlng) {
    var R = 6371; // km
    var dLat = toRad(destinationlat - originlat);
    var dLon = toRad(destinationlng - originlng);
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(toRad(originlat)) * Math.cos(toRad(destinationlat)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c;
    return d;
}

function toRad(value) {
    return value * Math.PI / 180;
}
