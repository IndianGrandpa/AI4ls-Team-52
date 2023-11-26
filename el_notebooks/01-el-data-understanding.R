# AI4LS
# Created on 24 Nov 2023

library(pacman)

p_load(
  here, tidyverse, janitor, ggthemes,
  SmartEDA,
  readxl, sf #shapfile
)

# LOAD DATA -----
df_org <- read_csv(
  '/Users/evelyn/Desktop/ai4ls/data/LUCAS 2018/LUCAS-SOIL-2018-data-report-readme-v2/LUCAS-SOIL-2018-v2/LUCAS2018_ORG.csv'
)

glimpse(df_org) # POINT_ID


df_erosion <- 
  read_csv(
    '/Users/evelyn/Desktop/ai4ls/data/LUCAS 2018/LUCAS-SOIL-2018-data-report-readme-v2/LUCAS-SOIL-2018-v2/LUCAS2018_EROSION.csv'
  )
glimpse(df_erosion)


df_soil <- 
  read_xls(
    '/Users/evelyn/Desktop/ai4ls/data/LUCAS 2018/LUCAS-SOIL-2018-data-report-readme-v2/LUCAS-SOIL-2018-v2/LUCAS-SOIL-2018.xls'
  ) %>% 
  rename('POINT_ID' = 'POINTID')

glimpse(df_soil)

## Data dictionary: df_soil ------
# Depth: value indicating the depth of the sample
# PointID: UID of the LUCAS Survey Point
# pH(CaCl2): pH measured in cacl2 solution (2-10)
# ph(h2o): pH measured in soil in water (2-10) <-- can drop
# EC: electrical conductivity
# OC: organic carbon content (at depth 0-20cm topsoil)
# CaCO3: carbonates content (topsoil)
# P: Phosphorus content
# N: Nitrogen content
# K: Potassium content
# OC: organic carbon content at depth 20-30cm
# CaCO3: carbonates content at depth 20-30cm
# Ox_Al: Al oxylate
# Ox_Fe: Fe Oxylate

# Drop if LOD?
# drop soil_ph water, just look at cacl2?

## Bulk density -----
## it reflects soil compaction and is commonly used to assess 
# this threat to soil. It is also required to estimate soil organic 
# carbon stock
df_bd <- 
  read_csv(
    '/Users/evelyn/Desktop/ai4ls/data/LUCAS 2018/LUCAS-SOIL-2018-data-report-readme-v2/LUCAS-SOIL-2018-v2/BulkDensity_2018_final-2.csv'
  )

glimpse(df_bd)


df_coords <- sf::read_sf(
  '/Users/evelyn/Desktop/ai4ls/data/LUCAS 2018/LUCAS-SOIL-2018-data-report-readme-v2/LUCAS-SOIL-2018-v2/LUCAS-SOIL-2018 .shp'
) %>% 
  rename('POINT_ID' = 'POINTID')

df_coords 


# EDA on bd_soil ------
## SMART EDA
glimpse(df_soil) # 18,984 rows, 27 cols

## merge in other datasets using full_join -----

df_soil_cleaned_a <- 
  df_soil %>% 
  full_join(df_bd, by = 'POINT_ID') %>% 
  full_join(df_erosion, by = 'POINT_ID') %>% 
  full_join(df_org, by = 'POINT_ID') %>% 
  mutate_at(vars(pH_CaCl2:Ox_Fe), as.double)

glimpse(df_soil_cleaned_a)

## overview
ExpData(data=df_soil_cleaned_a,type=1)

# num
ExpNumViz(
  df_soil_cleaned_a,
  target=NULL,
  type=1,
  nlim=25,
  fname = file.path('/Users/evelyn/Desktop/ai4ls',"df_soil_cleaned_a"))

# cat
ExpCTable(
  df_soil_cleaned_a,
  Target=NULL,
  margin=1,
  clim=10,
  nlim=5,
  round=2,
  bin=NULL,
  per=T)

# eda report
ExpReport(
  df_soil_cleaned_a,
  label=NULL,
  op_file="test.html",
  op_dir=getwd(),
  sc=2,
  sn=2,
  Rc="Yes")
