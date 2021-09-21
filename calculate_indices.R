# Load the libraries
library(tidyverse)

# Read the covid measures from the Swiss TPH repo
url_to_read <- "https://raw.githubusercontent.com/SwissTPH/COVID_measures_by_canton/master/COVID_measures_CH.csv"

df <- readr::read_csv(url(url_to_read))



# The codebook is given here
# https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md
# Max and flag values
# Flag values are not given in data set
# At the moment hard-coded, can be transferred to a file
c1_max <- 3
c1_flag <- 1
c2_max <- 3
c2_flag <- 1
c3_max <- 2
c3_flag <- 1
c4_max <- 4
c4_flag <- 1
c5_max <- 2
c5_flag <- 1
c6_max <- 3
c6_flag <- 1
c7_max <-  2
c7_flag <- 1
c8_max <- 4
c8_flag <- 1
h1_max <- 2
h1_flag <- 1
h2_max <-  3
h2_flag <- 1
h3_max <- 2
h3_flag <- 1
h6_max <- 4 
h6_flag <- 1



# Function to calculate index
calc_sub_index <- function(recorded_value_v,recorded_binary_flag_f,has_flag_F,max_value_N){
  
  # Calculate function_F_f seperately
  function_F_f <- if_else(coalesce(recorded_value_v,0)>0,0.5*(has_flag_F-recorded_binary_flag_f),0)
  # Calculate the subindex
  subindex <- 100*(coalesce(recorded_value_v,0)-function_F_f)/max_value_N
  
  return(subindex)
}



calc_indices <- function(df)
{
  df_extended <- df %>% 
    rowwise() %>%
    mutate(index_c1=calc_sub_index(C1_oxford_school_closing,1,c1_flag,c1_max),
           index_c2=calc_sub_index(C2_oxford_workplace_closing,1,c2_flag,c2_max),
           index_c3=calc_sub_index(C3_oxford_cancel_public_events,1,c3_flag,c3_max),
           index_c4=calc_sub_index(C4_oxford_restrictions_on_gatherings,1,c4_flag,c4_max),
           index_c5=calc_sub_index(C5_oxford_close_public_transport,1,c5_flag,c5_max),
           index_c6=calc_sub_index(C6_oxford_stay_at_home,1,c6_flag,c6_max),
           index_c7=calc_sub_index(C7_oxford_restriction_internal_movement,1,c7_flag,c7_max),
           index_c8=calc_sub_index(C8_oxford_international_travel_control,1,c8_flag,c8_max),
           index_h1=calc_sub_index(H1_oxford_public_info_campaigns,1,h1_flag,h1_max),
           index_h2=calc_sub_index(H2_oxford_testing_policy,1,h2_flag,h2_max),
           index_h3=calc_sub_index(H3_oxford_contact_tracing,1,h3_flag,h3_max),
           index_h6=calc_sub_index(H6_oxford_facial_coverings,1,h6_flag,h6_max))%>%
    ungroup %>%
    mutate(stringency_index= rowMeans(dplyr::select(.,index_c1:index_h1),na.rm=T),
           containment_health_index= rowMeans(dplyr::select(.,index_c1:index_h6),na.rm=T))
  
  
  return(df_extended)

}

# Tests function
# This should return 66 (https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md)
calc_sub_index(2,1,1,3)
# This should return 0 (https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md)
calc_sub_index(NA,NA,1,3)
# Calculate the indices
# We do not have the f in the data which is time dependent

df_indices <- calc_indices(df)

readr::write_csv(df_indices,"offene_datenwerkstatt_indices.csv")
View(df_indices)
# Plot the index over time
ggplot(df_indices,aes(x=date,y=stringency_index,colour=canton))+
  geom_line()+
  theme_bw()

# Plot the index over time
ggplot(df_indices,aes(x=date,y=containment_health_index,colour=canton))+
  geom_line()+
  theme_bw()


