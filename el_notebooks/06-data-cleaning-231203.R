# standardise data after meet up

# LOAD DATA ----
library(pacman)
p_load(tidyverse, here)

data_folder <- 
  here(
    'data',
    'el-interim',
    '231126-rename'
  )

data_folder

## load bulk density ------
bd_df <- read_csv(
  here(
    'data',
    'raw',
    'LUCAS 2018',
    'LUCAS-SOIL-2018-data-report-readme-v2',
    'LUCAS-SOIL-2018-v2',
    'BulkDensity_2018_final-2.csv'
  )
)

glimpse(bd_df)

## check unique bd_df pointids
bd_df %>% 
  select(POINT_ID) %>% 
  unique() # 6271 bulk density

bd_long <- 
  bd_df %>% 
  pivot_longer(cols = 2:5,
               names_to = 'depth',
               values_to = 'values')

bd_long
## clean 2018 ------
df_2018 <- 
  read_csv(
    here(
      data_folder,
      'df_2018_soil_a.csv'
    )
  ) 

df_2018_a <- 
  df_2018 %>% 
  select(
    -`OC (20-30 cm)`,
    -`CaCO3 (20-30 cm)`,
    -starts_with(("NUTS")),
    -ends_with('Desc'),
    - SURVEY_DATE,
    - starts_with('Ox'),
    - starts_with('TH')
  ) %>% 
  filter(Depth == '0-20 cm')

glimpse(df_2018)

df_2018 %>% 
  count(POINT_ID)

df_2018 %>% 
  count(Depth)

# merge in bulk density values
glimpse(df_2018_a)

bd_df %>% select(1:3)

df_2018_b <- 
  df_2018_a %>% 
  left_join(
    bd_df %>% select(1:3),
    by = 'POINT_ID'
  ) 
glimpse(df_2018_b)

## export
out_folder <- 
  here(
    "data",
    "el-interim-231203"
  )

out_folder

df_2018_b %>% 
  write_csv(
    here(out_folder,
    "df_2018_with_bd.csv")
  )
