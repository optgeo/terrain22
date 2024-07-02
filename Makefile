SRC_DIR = src
DST_DIR = dst
MINZOOM = 8
MAXZOOM = 14
N = 44
SHP_PATH = $(SRC_DIR)/Poly_$(N)/Poly_$(N).shp
DBF_PATH = $(SRC_DIR)/Poly_$(N)/GlobalCluster_$(N).dbf

default:
	ogr2ogr -sql "SELECT a.*, b.* FROM Poly_$(N) a \
	LEFT JOIN '$(DBF_PATH)'.GlobalCluster_$(N) b ON a.polyID = b.POLYID" \
	-of GeoJSONSeq -lco COORDINATE_PRECISION=12 /vsistdout/ $(SHP_PATH) | \
	ruby filter.rb | head -n 20000 | \
	tippecanoe --minimum-zoom $(MINZOOM) --maximum-zoom $(MAXZOOM) -f -o $(DST_DIR)/$(N).pmtiles

