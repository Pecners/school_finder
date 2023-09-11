library(tidyverse)
library(sf)
library(jsonify)
library(wisconsink12)

# load mke city limits
mke_sf <- st_read("data/milwaukee_citylimit/citylimit.shp") |> 
  st_transform(crs = 4326)

# get center points to manually code into index.html
mke_cent <- st_centroid(mke_sf) |> 
  st_coordinates()

# write geojson file with
st_write(mke_sf, "data/mke_geo.json", 
         driver = "GeoJSON", 
         append = FALSE)


# load geocoded schools

geo_schools <- read_rds("data/geocoded_wi_schools_fixed.rda") 
gs <- geo_schools |> 
  filter(current_status != "CLOSED") |> 
  st_as_sf(coords = c("long", "lat"), crs = 4326) |> 
  left_join(make_wi_rc(exclude_milwaukee = FALSE) |> 
              filter(school_year == "2021-22") |> 
              select(dpi_true_id,
                     accurate_agency_type,
                     overall_score,
                     overall_rating))

mke_sf |> 
  ggplot() +
  geom_sf() +
  geom_sf(data = gs)

st_write(gs, 
         "data/schools_geo.json",
         driver = "GeoJSON", delete_dsn = TRUE)
