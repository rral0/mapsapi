% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mp_map.R
\name{mp_map}
\alias{mp_map}
\title{Get static map from the Maps Static API}
\usage{
mp_map(
  center,
  zoom,
  maptype = c("roadmap", "satellite", "terrain", "hybrid"),
  key,
  quiet = FALSE
)
}
\arguments{
\item{center}{Character of length 1 of the form \code{"lat,lon"} or a geometry of class \code{sfg}, \code{sfc} or \code{sf}. If \code{center} is a geometry, the center of the geometry bounding box is passed as map center. Missing Coordinate Reference System (CRS) is assumed WGS84.}

\item{zoom}{Zoom level, a positive integer or zero. The appropriate range is \code{0} to \code{20}.}

\item{maptype}{Map type, one of: \code{"roadmap"}, \code{"satellite"}, \code{"terrain"}, \code{"hybrid"}.}

\item{key}{Google APIs key}

\item{quiet}{Logical; suppress printing URL for Google Maps API call (e.g. to hide API key)}
}
\value{
A \code{stars} raster with the requested map, in Web Mercator CRS (EPSG:3857).
}
\description{
Download a static map from the Maps Static API, given map center and zoom level.
}
\examples{

\dontrun{

library(stars)
key = readLines("~/key")

# Using coordinates
r = mp_map("31.253205,34.791914", 14, key = key)
plot(r)

# Using 'sfc' point - WGS84
pnt = st_point(c(34.791914, 31.253205))
pnt = st_sfc(pnt, crs = 4326)
r = mp_map(pnt, 14, key = key)
plot(r)

# Using 'sfc' point - UTM
pnt = st_point(c(34.791914, 31.253205))
pnt = st_sfc(pnt, crs = 4326)
pnt = st_transform(pnt, 32636)
r = mp_map(pnt, 14, key = key)
plot(r)

# Using 'sfc' polygon
pnt = st_point(c(34.791914, 31.253205))
pnt = st_sfc(pnt, crs = 4326)
pol = st_buffer(pnt, 0.01)
r = mp_map(pol, 14, key = key)
plot(r)

# 'ggplot2'
library(ggplot2)
cols = attr(r[[1]], "colors")
ggplot() +
  geom_stars(data = r, aes(x = x, y = y, fill = color)) +
  scale_fill_manual(values = cols, guide = FALSE) +
  coord_sf()

# 'ggplot2' - map types
r1 = mp_map(pnt, 14, maptype = "roadmap", key = key)
r2 = mp_map(pnt, 14, maptype = "satellite", key = key)
r3 = mp_map(pnt, 14, maptype = "terrain", key = key)
r4 = mp_map(pnt, 14, maptype = "hybrid", key = key)
cols1 = attr(r1[[1]], "colors")
cols2 = attr(r2[[1]], "colors")
cols3 = attr(r3[[1]], "colors")
cols4 = attr(r4[[1]], "colors")
theme1 = theme(
  axis.text = element_blank(),
  axis.title = element_blank(),
  axis.ticks = element_blank()
)
g1 = ggplot() +
  geom_stars(data = r1, aes(x = x, y = y, fill = color)) +
  scale_fill_manual(values = cols1, guide = FALSE) +
  coord_sf() +
  ggtitle("roadmap") +
  theme1
g2 = ggplot() +
  geom_stars(data = r2, aes(x = x, y = y, fill = color)) +
  scale_fill_manual(values = cols2, guide = FALSE) +
  coord_sf() +
  ggtitle("satellite") +
  theme1
g3 = ggplot() +
  geom_stars(data = r3, aes(x = x, y = y, fill = color)) +
  scale_fill_manual(values = cols3, guide = FALSE) +
  coord_sf() +
  ggtitle("terrain") +
  theme1
g4 = ggplot() +
  geom_stars(data = r4, aes(x = x, y = y, fill = color)) +
  scale_fill_manual(values = cols4, guide = FALSE) +
  coord_sf() +
  ggtitle("hybrid") +
  theme1
g1 + g2 + g3 + g4

}
}
\references{
\url{https://developers.google.com/maps/documentation/maps-static/intro}
}
