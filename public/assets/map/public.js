(function(){this.Map=function(){function o(){}return o.map,o.markers,o.openedInfo=null,o.attachMessage=function(e){google.maps.event.addListener(o.markers[e].marker,"click",function(){o.openedInfo&&o.openedInfo.close(),o.markers[e].window&&o.markers[e].window.open(o.markers[e].marker.getMap(),o.markers[e].marker),o.openedInfo=o.markers[e].window})},o.load=function(e){var n;n={center:new google.maps.LatLng(35.392915,139.442888),zoom:5,mapTypeId:google.maps.MapTypeId.ROADMAP,panControl:!1,zoomControl:!0,zoomControlOptions:{style:google.maps.ZoomControlStyle.LARGE},mapTypeControl:!0,scaleControl:!0,scrollwheel:!0,streetViewControl:!0,overviewMapControl:!0,overviewMapControlOptions:{opened:!0}},o.map=new google.maps.Map(e,n)},o.setMarkers=function(e){var n,a;o.markers=e,n=new google.maps.LatLngBounds,$.each(o.markers,function(e,a){var t,r,s;o.markers[e].marker=new google.maps.Marker(a.image?{position:new google.maps.LatLng(a.loc[0],a.loc[1]),icon:a.image,map:o.map}:{position:new google.maps.LatLng(a.loc[0],a.loc[1]),map:o.map}),n.extend(new google.maps.LatLng(a.loc[0],a.loc[1])),a.html?(t=a.html,o.markers[e].window=new google.maps.InfoWindow({content:t})):(a.name||a.text)&&(r=a.name,s=a.text,t='<div class="marker-info">',""!==r&&(t+="<p>"+r+"</p>"),""!==s&&$.each(s.split(/[\r\n]+/),function(){return t+=this.match(/^https?:\/\//)?'<p><a href="'+this+'">'+this+"</a></p>":"<p>"+this+"</p>"}),t+="</div>",o.markers[e].window=new google.maps.InfoWindow({content:t})),o.attachMessage(e)}),$.isEmptyObject(o.markers)||(a=google.maps.event.addListener(o.map,"bounds_changed",function(){return this.getZoom()>13&&this.initialZoom===!0&&(this.setZoom(13),this.initialZoom=!1),google.maps.event.removeListener(a)}),o.map.initialZoom=!0,o.map.fitBounds(n))},o}()}).call(this);