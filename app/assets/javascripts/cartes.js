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
    var crs = {'type': 'name', 'properties': {'name': 'EPSG:2154'}};
    src.crs = crs;
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
    /* Projection */
    var extent = [99127,6049547,1242475,7110624];
    var projection = new ol.proj.Projection({
        code: 'EPSG:2154',
        extent: [-378305.81, 6093283.21, 1212610.74, 7186901.68]
    });
    /* Vue */
    var vue = new ol.View({
        projection: projection,
        center: ol.proj.fromLonLat([2.351, 48.8567], projection),
        extent: extent,
        zoom: 5,
        maxZoom: 18,
        minZoom: 2
    });
    /* Carte */
    var select = new ol.interaction.Select();

    map = new ol.Map({
        //projection: "EPSG:2154",
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
    getJson();
}


$(document).ready(function () {
    init();

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

