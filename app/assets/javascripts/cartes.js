/*handler = Gmaps.build('Google');
 handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
 //markers = handler.addMarkers(<%=raw @hash.to_json %>);
 markers = handler.addMarkers([
 {
 "lat": 0,
 "lng": 0,
 "picture": {
 "url": "http://people.mozilla.com/~faaborg/files/shiretoko/firefoxIcon/firefox-32.png",
 "width":  32,
 "height": 32
 },
 "infowindow": "hello!"
 }
 ]);
 handler.bounds.extendWith(markers);
 handler.fitMapToBounds();
 });*/
var geojsonObject = {
    'type': 'FeatureCollection',
    'crs': {
        'type': 'name',
        'properties': {
            'name': 'EPSG:3857'
        }
    },
    'features': [{
        'type': 'Feature',
        'geometry': {
            'type': 'Point',
            'coordinates': [0, 0]
        }
    }, {
        'type': 'Feature',
        'geometry': {
            'type': 'LineString',
            'coordinates': [[4e6, -2e6], [8e6, 2e6]]
        }
    }, {
        'type': 'Feature',
        'geometry': {
            'type': 'LineString',
            'coordinates': [[4e6, 2e6], [8e6, -2e6]]
        }
    }, {
        'type': 'Feature',
        'geometry': {
            'type': 'Polygon',
            'coordinates': [[[-5e6, -1e6], [-4e6, 1e6], [-3e6, -1e6]]]
        }
    }, {
        'type': 'Feature',
        'geometry': {
            'type': 'MultiLineString',
            'coordinates': [
                [[-1e6, -7.5e5], [-1e6, 7.5e5]],
                [[1e6, -7.5e5], [1e6, 7.5e5]],
                [[-7.5e5, -1e6], [7.5e5, -1e6]],
                [[-7.5e5, 1e6], [7.5e5, 1e6]]
            ]
        }
    }, {
        'type': 'Feature',
        'geometry': {
            'type': 'MultiPolygon',
            'coordinates': [
                [[[-5e6, 6e6], [-5e6, 8e6], [-3e6, 8e6], [-3e6, 6e6]]],
                [[[-2e6, 6e6], [-2e6, 8e6], [0, 8e6], [0, 6e6]]],
                [[[1e6, 6e6], [1e6, 8e6], [3e6, 8e6], [3e6, 6e6]]]
            ]
        }
    }, {
        'type': 'Feature',
        'geometry': {
            'type': 'GeometryCollection',
            'geometries': [{
                'type': 'LineString',
                'coordinates': [[-5e6, -5e6], [0, -5e6]]
            }, {
                'type': 'Point',
                'coordinates': [4e6, -5e6]
            }, {
                'type': 'Polygon',
                'coordinates': [[[1e6, -6e6], [2e6, -4e6], [3e6, -6e6]]]
            }]
        }
    }]
};
var geoJsonLayout;

$.getJSON('troncon_routes.json', function(data) {
    geoJsonLayout = data;
});
var vectorSource = new ol.source.Vector({
    features: (new ol.format.GeoJSON()).readFeatures(geoJsonLayout)
});
var vectorLayer = new ol.layer.Vector({
    source: vectorSource
});
var map = new ol.Map({
    projection: new ol.proj.Projection("EPSG:3857"),
    displayProjection: new ol.proj.Projection("EPSG:3857"),
    layers: [
        new ol.layer.Tile({
            source: new ol.source.MapQuest({layer: 'osm'})
        }),
        vectorLayer
    ],
    target: 'map',
    controls: ol.control.defaults({
        attributionOptions:({
            collapsible: false
        })
    }),
    view: new ol.View({
        center: [0, 0],
        zoom: 3
    })
});
/*
 var gmap = new google.maps.Map(document.getElementById('gmap'), {
 disableDefaultUI: true,
 keyboardShortcuts: false,
 draggable: false,
 disableDoubleClickZoom: true,
 scrollwheel: false,
 streetViewControl: false
 });

 var view = new ol.View({
 // make sure the view doesn't go beyond the 22 zoom levels of Google Maps
 maxZoom: 21
 });
 view.on('change:center', function() {
 var center = ol.proj.transform(view.getCenter(), 'EPSG:3857', 'EPSG:4326');
 gmap.setCenter(new google.maps.LatLng(center[1], center[0]));
 });
 view.on('change:resolution', function() {
 gmap.setZoom(view.getZoom());
 });

 var vector = new ol.layer.Vector({
 source: new ol.source.TileJSON({
 url: 'https://raw.githubusercontent.com/glynnbird/countriesgeojson/master/france.geojson',
 projection: 'EPSG:3857'
 }),
 style: new ol.style.Style({
 fill: new ol.style.Fill({
 color: 'rgba(255, 255, 255, 0.6)'
 }),
 stroke: new ol.style.Stroke({
 color: '#319FD3',
 width: 1
 })
 })
 });

 var olMapDiv = document.getElementById('olmap');
 var map = new ol.Map({
 layers: [vector],
 interactions: ol.interaction.defaults({
 altShiftDragRotate: false,
 dragPan: false,
 rotate: false
 }).extend([new ol.interaction.DragPan({kinetic: null})]),
 target: olMapDiv,
 view: view
 });
 view.setCenter([0, 0]);
 view.setZoom(1);

 olMapDiv.parentNode.removeChild(olMapDiv);
 gmap.controls[google.maps.ControlPosition.TOP_LEFT].push(olMapDiv);
 */