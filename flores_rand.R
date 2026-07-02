library(tidyverse)
setwd("C:/Users/lgriv/Downloads/isa stuff")
data = read_csv("Flores_RandHRS_Dataset.csv")

colnames(data)
nrow(data)
sum(!is.na(data$RAVETRN))
sum(data$RAVETRN == 1, na.rm = TRUE)

#FILTERING BY VET STATUS
data2 = data %>%
  filter(data$RAVETRN == 1, na.rm = TRUE) 
 
#VET RACE
summary(data2$RARACEM)
sum(data2$RARACEM == 1, na.rm = TRUE)
sum(data2$RARACEM == 2, na.rm = TRUE)
sum(data2$RARACEM == 3, na.rm = TRUE)

sum(data2$RAHISPAN == 1, na.rm = TRUE)
#ONLY 271 / 4315.. 7% are hispanic

sum(data2$RARACEM == 1 & data2$RAHISPAN == 1, na.rm = TRUE)
sum(data2$RARACEM == 2 & data2$RAHISPAN == 1, na.rm = TRUE)
sum(data2$RARACEM == 3 & data2$RAHISPAN == 1, na.rm = TRUE)


sum(data2$GENDER == 1, na.rm = TRUE)
sum(data2$GENDER == 2, na.rm = TRUE)
#NO WOMEN????
                                 
  ##arrange(year_military_begin, fire_weapon) %>%
  ##group_by()  
  ##mutate()


#ravetrn R Veteran Status 
#r9shlf Self-report of health 
#r9hsp Hospital stay, prv 2 yrs
#r9hspnit Nights in hosp
#r9doctor // r9doctim- doctor visit, prv 2 yrs
#r9depres Felt depressed
#r9sleepr Sleep was restless
#r9hibp R reports high BP this wv
#r9diab R reports diabetes this wv 
#r9cancr R reports cancer this wv 
#r9lung R reports lung disease this wv
#r9heart R reports heart prob this wv
#r9strok R reports stroke this wv
#r9psych R reports psych prob this wv
#r9arthr R reports arthritis this wv 
#r9slfmem Self Rated Memory
#r1hlthlm Hlth problems limit work 
#r1drink R ever drinks any alcohol 
#h1atotb Total all Assets inc. 2nd Hm
#r1iearn Income:R Earnings ************
#h1itot Incm: Total HHold / R+Sp only ****************
#rassrecv R Receives SocSec 
#rassageb Age R Start Rec. SocSec 
#r1higov R is covered by Gov plan 
#r1liv75 R Probability to live 75+
#r1agey_b R Age (years) at Ivw BegMon (age when interviewed)
#inw1 in the wave
#r1iwstat R Interview Status 
#rawtsamp Sampling Weight
#r1wtresp Wave Person-Level Analysis Weight
#racohbyr Cohort based on birth yr ***************
#rabyear R birth year
#radyear R death year 
#racacem R Race-masked
#rahispan R Hispanic 
#raedegrm R Highest Degree-masked 

