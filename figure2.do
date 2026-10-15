* Run this script from the repository root.
import delimited "stroke_analysis_data.csv", clear

preserve

*------------------------------------------------------------
* 1. Obtain absolute frequencies for each intervention x mRS
*------------------------------------------------------------
contract intervention discharge_mrs, freq(n) nomiss

*------------------------------------------------------------
* 2. Calculate percentages within each intervention group
*------------------------------------------------------------
bysort intervention: egen total = total(n)
gen pct = 100 * n / total

*------------------------------------------------------------
* 3. Calculate beginning, end and centre of each segment
*------------------------------------------------------------
sort intervention discharge_mrs

by intervention: gen upper = sum(pct)
gen lower = upper - pct
gen middle = lower + pct/2

*------------------------------------------------------------
* 4. Plot stacked percentages and show absolute counts
*------------------------------------------------------------
twoway ///
    (rbar lower upper intervention if discharge_mrs==0, ///
        horizontal barwidth(.7) color("ltblue*0.4")) ///
    (rbar lower upper intervention if discharge_mrs==1, ///
        horizontal barwidth(.7) color("ltblue*0.7")) ///
    (rbar lower upper intervention if discharge_mrs==2, ///
        horizontal barwidth(.7) color(ltblue)) ///
    (rbar lower upper intervention if discharge_mrs==3, ///
        horizontal barwidth(.7) color("ltblue*1.4")) ///
    (rbar lower upper intervention if discharge_mrs==4, ///
        horizontal barwidth(.7) color("ltblue*1.7")) ///
    (rbar lower upper intervention if discharge_mrs==5, ///
        horizontal barwidth(.7) color("ltblue*2.4")) ///
    (rbar lower upper intervention if discharge_mrs==6, ///
        horizontal barwidth(.7) color("ltblue*2.7")) ///
    (scatter intervention middle, ///
        msymbol(none) ///
        mlabel(n) ///
        mlabposition(0) ///
        mlabcolor(black) ///
        mlabsize(small)), ///
    ylabel(0 "Without RT" 1 "With RT", angle(0)) ///
    xlabel(0(20)100) ///
    xtitle("Percentage of patients") ///
    ytitle("") ///
    legend(order(1 "0" 2 "1" 3 "2" 4 "3" ///
                 5 "4" 6 "5" 7 "6") ///
           rows(2) ///
           title("mRS at discharge", position(9)) ///
           position(12))

graph export "Figure 2.png", replace width(3000)
restore
