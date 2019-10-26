library(tidyverse)
library(jsonlite)

trash_locations <- fromJSON("./trash_locations.json")
nested_dfs <- as.data.frame(trash_locations)[,4:5]

coordinates <- unnest(nested_dfs$features.geometry)[,2]
properties_df <- unnest(nested_dfs$features.properties)
properties_df$lat <- coordinates[seq(1, length(coordinates), 2)]
properties_df$lon <- coordinates[seq(2, length(coordinates), 2)]

base <- properties_df %>%
  mutate(TRASHTYPENAME = as.factor(TRASHTYPENAME),
         CONTAINERTYPE = as.factor(TRASHTYPENAME),
         CLEANINGFREQUENCYCODE = recode(CLEANINGFREQUENCYCODE,
                                        "11" = "1x za týden", "12" = "2x za týden", "13" = "3x za týden",
                                        "14" = "4x za týden", "15" = "5x za týden", "16" = "6x za týden",
                                        "17" = "Kazdý den", "21" = "1x za dva týdny", "31" = "1x za tři týdny",
                                        "41" = "1x za čtyři týdny", "51" = "1x za pět týdnů", "61" = "1x za šest týdnů"))
