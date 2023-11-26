# merge df together

library(pacman)
p_load(tidyverse, janitor, here, sf,
       DT, readxl
       )


working_dir <- getwd()
working_dir

data_folder <- here(
  working_dir,
  'data'
)

raw_data_folder <- 
  here(
    data_folder,
    'raw'
  )

raw_2009 <- here(raw_data_folder, 'LUCAS 2009')
raw_2015 <- here(raw_data_folder, 'LUCAS 2015')
raw_2018 <- here(raw_data_folder, 'LUCAS 2018')

# LOAD DATA ------

## 2009 -------
df_2009_points <- read_sf(
  here(
    raw_2009,
    'LUCAS_21681_points',
    'LUCAS_Points.shp'
  )
)
df_2009_points # long, lat

df_2009_soil <- 
  read_delim(
    here(
      raw_2009,
      'LUCAS_21681_points',
      'NoSensitive.csv'
    )
  ) %>% 
  as_tibble()

# export to csv
df_2009_soil_colnames <- 
  df_2009_soil %>% 
  colnames() %>%
  as_tibble()  # %>% 
  #write_csv(here('data', 'cleaned', 'colnames_check',2009_soil_colnames.csv'))

df_2009_soil_colnames

## 2015 -------

df_2015_soil <- 
  read_csv(
    here(
      raw_data_folder,
      'LUCAS 2015',
      'LUCAS2015_topsoildata_20200323',
      'LUCAS_Topsoil_2015_20200323.csv'
    )
  )

df_2015_soil

## export colnames
df_2015_soil_colnames <- 
  df_2015_soil %>% 
  colnames() %>% 
  as_tibble() %>% 
  clean_names()

df_2015_soil_colnames %>% 
  write_csv(
    here(
      'data',
      'cleaned',
      'colnames_check',
      '2015_soil_colnames.csv'
    )
  )


## 2018 soil-------
df_2018_soil <- 
  read_csv(
    here(
      'data',
      'raw',
      'LUCAS 2018',
      'LUCAS-SOIL-2018-data-report-readme-v2',
      'LUCAS-SOIL-2018-v2',
      'LUCAS-SOIL-2018.csv'
    )
  )

df_2018_soil

## export columns
df_2018_soil_colnames <- 
  df_2018_soil %>% 
  colnames() %>% 
  as_tibble() %>% 
  clean_names()

df_2018_soil_colnames %>% 
  write_csv(
    here(
    'data',
    'cleaned',
    'colnames_check',
    '2018_soil_colnames.csv')
  )


## 2018 erosion
df_2018_erosion <- 
  read_csv(
    here(
      'data',
      'raw',
      'LUCAS 2018',
      'LUCAS-SOIL-2018-data-report-readme-v2',
      'LUCAS-SOIL-2018-v2',
      'LUCAS2018_EROSION.csv'
    )
  )


df_2018_erosion_colnames <- 
  df_2018_erosion %>% 
  colnames() %>% 
  as_tibble()

df_2018_erosion_colnames %>% 
  write_csv(
    here(
      'data',
      'cleaned',
      'colnames_check',
      '2018_erosion_colnames.csv'
    )
  )

glimpse(df_2018_erosion)

## 2018 org ------
df_2018_org <- 
  read_csv(
    here(
      'data',
      'raw',
      'LUCAS 2018',
      'LUCAS-SOIL-2018-data-report-readme-v2',
      'LUCAS-SOIL-2018-v2',
      'LUCAS2018_ORG.csv'
    )
  )

df_2018_org_colnames <- 
  df_2018_org %>% 
  colnames() %>% 
  as_tibble()

df_2018_org_colnames %>% 
  write_csv(
    here(
      'data',
      'cleaned',
      'colnames_check',
      '2018_org_colnames.csv'
    )
  )

## 2018 bd ------
df_2018_bd <- 
  read_csv(
    here(
      'data',
      'raw',
      'LUCAS 2018',
      'LUCAS-SOIL-2018-data-report-readme-v2',
      'LUCAS-SOIL-2018-v2',
      'BulkDensity_2018_final-2.csv'
    )
  )

df_2018_bd_colnames <- 
  df_2018_bd %>% 
  colnames() %>% 
  as_tibble()

df_2018_bd_colnames %>% 
  write_csv(
    here(
      'data',
      'cleaned',
      'colnames_check',
      '2018_bd_colnames.csv'
    )
  )
  

# CLEANING -------
## output folder
folder <- 
  here(
    "data",
    "el-interim",
    '231126-rename'
  )
folder

save_output <- function(df, filename){
  df %>% 
    write_csv(
      here(
        folder,
        filename
      )
    )
}

df_2009_soil_a <- 
  df_2009_soil %>% 
  rename("pH_H2O" = "pH_in_H2O") %>% 
  rename("pH_CaCl2" = "pH_in_CaCl") %>% 
  rename("P" = "P_x") %>% 
  rename("NUTS_3" = "nuts3") %>% 
  rename("NUTS_0" = "nuts0") %>% 
  rename("NUTS_1" = "nuts1") %>% 
  rename("NUTS_2" = "nuts2") %>% 
  rename("Elevation" = "Elevation(m)")

glimpse(df_2009_soil_a)
save_output(df_2009_soil_a, 'df_2009_soil_a.csv')

df_2015_soil_a <- 
  df_2015_soil %>% 
  rename("POINT_ID" = "Point_ID") %>% 
  rename("pH_H2O" = "pH(H2O)") %>% 
  rename("pH_CaCl2" = "pH(CaCl2)") %>% 
  rename('coarse' = 'Coarse') %>% 
  rename('clay' = 'Clay') %>% 
  rename('sand' = 'Sand') %>% 
  rename('silt' = 'Silt')

glimpse(df_2015_soil_a)
save_output(df_2015_soil_a, 'df_2015_soil_a.csv')

df_2018_soil_a <- 
  df_2018_soil %>% 
  rename("POINT_ID" = "POINTID") %>% 
  rename("LU1" = "LU") %>% 
  rename("LC1" = "LC") %>% 
  rename("Elevation" = "Elev")

glimpse(df_2018_soil_a)
save_output(df_2018_soil_a, 'df_2018_soil_a.csv')

df_2018_soil_a %>% 
  count(LU1_Desc) %>% 
  arrange(desc(n))

df_2018_soil_a %>% 
  count(LC1_Desc) %>% 
  arrange(desc(n))

df_2009_soil_a 