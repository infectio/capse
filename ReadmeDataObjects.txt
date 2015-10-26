

inf_list

This list contains the coordinates of cells which are infected.  It also contains the initial virus amount at the time of infection as well as the interpolated table of the rate of intensity increase over time.
This list is created with these values to save time.  Firstly, for each step of the CA, only the cells that are infected must be examined.  Since infected cells are the only ones that will change states in time steps of the CA, this reduces the amount of cells that need to be checked.
Computational savings is also obtained by only interpolating the rate of intensity increase once, instead of for every time step.

{:,1:2} - CA grid index
{:,3} - initial infection virion amount
{:, 4} - interpolated table

 
