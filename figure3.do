* Run this script from the repository root.
import delimited "stroke_analysis_data.csv", clear

egen nihss_cat = cut(nihss), at(0 5 21 43)
tab nihss_cat onset_within_4_5h

graph bar (count), ///
    over(onset_within_4_5h) ///
    over(nihss_cat, relabel(1 "0 - 4" 2 "5 - 20" 3 "> 20")) ///
    asyvars ///
    bar(1, color("ltblue*0.8")) ///
    bar(2, color("ltblue*1.8")) ///
    blabel(bar, position(outside) format(%9.0f)) ///
    legend(order(1 "Onset > 4.5 h" 2 "Onset ≤ 4.5 h") ///
           rows(1) ///
           position(6) ///
           region(lstyle(none))) ///
    ytitle("Number of patients") ///
    b1title("NIHSS category")


graph export "Figure 3.png", replace width(3000)
