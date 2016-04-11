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

/* Export PDF constantes */
var dimensions = {
    a0: [1189, 841],
    a1: [841, 594],
    a2: [594, 420],
    a3: [420, 297],
    a4: [297, 210],
    a5: [210, 148]
};

var loading = 0;
var loaded = 0;

/* Variables */
var map;
var mapquest;
function getJson() {
    var geoJsonLayout =  $.getJSON('troncon_routes.json', function (data) {
        geoJsonLayer(data);
    });
}
function geoJsonLayer(data) {
    var src = data;
    var crs = {'type': 'name', 'properties': {'name': 'EPSG:3857'}};
    src.crs = crs;
    //console.log(geojsonObject);
    console.log(src);
    var vectorSource = new ol.source.Vector({
        features: (new ol.format.GeoJSON()).readFeatures(src)
    });
    var vectorLayer = new ol.layer.Vector({
        source: vectorSource,
        visible: true,
        name: 'troncons'
    });
    map.addLayer(vectorLayer);
}
function init() {

    /* Layer de base */
    mapquest = new ol.layer.Tile({
        source: new ol.source.MapQuest({layer: 'osm'}),
        visible: true,
        name: 'mapquest'
    });
    /* Vue */
    var vue = new ol.View({
        center: ol.proj.fromLonLat([2.351, 48.8567]),
        zoom: 5,
        maxZoom: 18,
        minZoom: 2
    });
    /* Carte */
    var select = new ol.interaction.Select();
    map = new ol.Map({
        //projection: new ol.proj.Projection("EPSG:3857"),
        //displayProjection: new ol.proj.Projection("EPSG:3857"),
        renderer: 'canvas',
        layers: [
            mapquest
        ],
        target: 'map',
        controls: ol.control.defaults().extend([
            new ol.control.ScaleLine(),
            new ol.control.ZoomSlider(),
            new ol.control.FullScreen()
        ]),
        view: vue,
        interactions: ol.interaction.defaults().extend([select])
    });
}


$(document).ready(function () {
    init();
    getJson();
    var geolocation = new ol.Geolocation({
        projection: map.getView().getProjection(),
        tracking: true
    });
    $('#geolocation').click(function () {
        var position = geolocation.getPosition();

        var point = new ol.layer.Vector({
            source: new ol.source.Vector({
                features: [
                    new ol.Feature({
                        geometry: new ol.geom.Point(position)
                    })
                ]
            })
        });
        map.addLayer(point);
        map.getView().setCenter(position);
        map.getView().setResolution(2.388657133911758);
        return false;
    });

    /*
     Librairie: https://github.com/MrRio/jsPDF
     Référence: OpenLayers 3 API
     */
    var button_pdf = document.getElementById('export-pdf');
    $('#export-pdf').click(function () {

        button_pdf.disabled = true;
        document.body.style.cursor = 'progress';

        var format = document.getElementById('format').value;
        var resolution = document.getElementById('resolution').value;
        var dimension = dimensions[format];
        var width = Math.round(dimension[0] * resolution / 25.4);
        var height = Math.round(dimension[1] * resolution / 25.4);
        var size = /** @type {ol.Size} */ (map.getSize());
        var extent = map.getView().calculateExtent(size);

        var source = mapquest.getSource();

        var tileLoadStart = function () {
            ++loading;
        };

        var tileLoadEnd = function () {
            ++loaded;
            if (loading === loaded) {
                var canvas = this;
                window.setTimeout(function () {
                    loading = 0;
                    loaded = 0;
                    var date_time = new Date();
                    var data = canvas.toDataURL('image/png');
                    var pdf = new jsPDF('landscape', undefined, format);
                    pdf.addImage(data, 'JPEG', 0, 0, dimension[0], dimension[1]);
                    pdf.save('Roadquest-map-' + date_time + '.pdf');
                    source.un('tileloadstart', tileLoadStart);
                    source.un('tileloadend', tileLoadEnd, canvas);
                    source.un('tileloaderror', tileLoadEnd, canvas);
                    map.setSize(size);
                    map.getView().fit(extent, size);
                    map.renderSync();
                    button_pdf.disabled = false;
                    document.body.style.cursor = 'auto';
                }, 100);
            }
        };

        map.once('postcompose', function (event) {
            source.on('tileloadstart', tileLoadStart);
            source.on('tileloadend', tileLoadEnd, event.context.canvas);
            source.on('tileloaderror', tileLoadEnd, event.context.canvas);
        });

        map.setSize([width, height]);
        map.getView().fit(extent, /** @type {ol.Size} */ (map.getSize()));
        map.renderSync();
        return false;

    });

    var button_png = document.getElementById('export-png');
    button_png.addEventListener('click', function () {
        button_png.setAttribute('download', 'Roadquest-map-' + new Date() + '.png');
        map.once('postcompose', function (event) {
            document.body.style.cursor = 'progress';
            var canvas = event.context.canvas;
            button_png.href = canvas.toDataURL('image/png');
            document.body.style.cursor = 'auto';
        });
        map.renderSync();
    }, false);
});

