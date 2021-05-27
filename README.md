# Calculation of Oxford indices for Switzerland

This repository contains a R script to calculate the following indices for Switzerland:

* Stringency index
* Containment and health index

As a basis, data collected by the Swiss Tropical Health Institute is used. These data sets were created to track the implementation and relaxation dates of all non-pharmaceutical measures against SARS-CoV-2 in each canton of Switzerland. These data sets can be found [here](https://github.com/SwissTPH/COVID_measures_by_canton). 

To calculate the indices use has been made of the documentation outlined on the Oxford Covid-19 Government Response Tracker repository [here](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md). Assumptions had to made on the following variables: the recorded binary flag for that indicator (_f<sub>j,t</sub>_) and whether the indicator has a flag (_F<sub>j</sub>). 

![Alt text](stringency_index.png?raw=true "Title")
