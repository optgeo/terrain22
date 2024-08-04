SRC_DIR = src
DST_DIR = dst
MINZOOM = 9
MAXZOOM = 12
LAYER = terrain22
#N = 44 # Give as environment variable
SHP_PATH = $(SRC_DIR)/Poly_$(N)/Poly_$(N).shp
DBF_PATH = $(SRC_DIR)/Poly_$(N)/GlobalCluster_$(N).dbf

default:
	ogr2ogr -sql "SELECT a.*, b.* FROM Poly_$(N) a \
	LEFT JOIN '$(DBF_PATH)'.GlobalCluster_$(N) b ON a.polyID = b.POLYID" \
	-of GeoJSONSeq -lco COORDINATE_PRECISION=12 /vsistdout/ $(SHP_PATH) | \
	ruby filter.rb | \
	tippecanoe --layer $(LAYER) --minimum-zoom $(MINZOOM) --maximum-zoom $(MAXZOOM) \
	-f -o $(DST_DIR)/$(N).pmtiles

geojsons:
	ogr2ogr -sql "SELECT a.*, b.* FROM Poly_$(N) a \
	LEFT JOIN '$(DBF_PATH)'.GlobalCluster_$(N) b ON a.polyID = b.POLYID" \
	-of GeoJSONSeq -lco COORDINATE_PRECISION=12 /vsistdout/ $(SHP_PATH) | \
	ruby filter.rb | bzip2 -9c > $(SRC_DIR)/$(N).geojsons.bz2

pmtiles:
	ls $(SRC_DIR)/*.bz2 | egrep -v "src/(29|72|74)\.geojsons.bz2" | xargs -n 1 sh -c 'bzcat "$$0" || true' | tippecanoe-json-tool |\
	tippecanoe --layer $(LAYER) --minimum-zoom $(MINZOOM) \
	--maximum-zoom $(MAXZOOM) -f -o $(DST_DIR)/terrain22.pmtiles

upload:
	aws s3 cp $(DST_DIR)/terrain22.pmtiles s3://us-west-2.opendata.source.coop/smartmaps/foil4gr1/

