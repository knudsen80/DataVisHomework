
## Pyber Ride Sharing

## Analysis
 - Observed Trend 1: Average fare is inversely correlated to population density (i.e. rural areas have the highest average fare)
 - Observed Trend 2: Total number of rides is correlated with population density, obviously. It would be interesting to see if a linear relation holds, though. Rural riders might rely on Pyber more than city folk bc of what I assume is a lack of public transportation options vs. the city.
 - Observed Trend 3: The ratio of drivers to riders is higher in the city (77.9% of total vs. 67.5% of total) than rural areas (3.1% of total vs. 5.2% of total). This would lead me to believe that there might be more opportunity for drivers in rural areas and perhaps more opportunity to recruit riders in the city (though they probably have many public transportation options).


```
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

city_data = pd.read_csv("raw_data/city_data.csv")
ride_data = pd.read_csv("raw_data/ride_data.csv")
```


```
ride_data_full = pd.merge(ride_data, city_data, on='city')
ride_data_full.head()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>city</th>
      <th>date</th>
      <th>fare</th>
      <th>ride_id</th>
      <th>driver_count</th>
      <th>type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Sarabury</td>
      <td>2016-01-16 13:49:27</td>
      <td>38.35</td>
      <td>5403689035038</td>
      <td>46</td>
      <td>Urban</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Sarabury</td>
      <td>2016-07-23 07:42:44</td>
      <td>21.76</td>
      <td>7546681945283</td>
      <td>46</td>
      <td>Urban</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Sarabury</td>
      <td>2016-04-02 04:32:25</td>
      <td>38.03</td>
      <td>4932495851866</td>
      <td>46</td>
      <td>Urban</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Sarabury</td>
      <td>2016-06-23 05:03:41</td>
      <td>26.82</td>
      <td>6711035373406</td>
      <td>46</td>
      <td>Urban</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Sarabury</td>
      <td>2016-09-30 12:48:34</td>
      <td>30.30</td>
      <td>6388737278232</td>
      <td>46</td>
      <td>Urban</td>
    </tr>
  </tbody>
</table>
</div>




```
# Average Fare ($) Per City
ride_data_bycity = ride_data_full.groupby("city")
avgfare = ride_data_bycity["fare"].mean()
avgfare = pd.DataFrame(avgfare).reset_index()
avgfare = avgfare.rename(columns={'fare':'avgfare'})
```


```
# Total Number of Rides Per City
numrides = ride_data_bycity["fare"].count()
numrides = pd.DataFrame(numrides).reset_index()
numrides = numrides.rename(columns={'fare':'numrides'})
```


```
# Total Number of Drivers Per City
drivercount = ride_data_full[["city","driver_count"]].drop_duplicates("city")
```


```
# City Type (Urban, Suburban, Rural)
citytype = ride_data_full[["city","type"]].drop_duplicates("city")
```


```
full_table = pd.merge(avgfare,numrides,on="city")
full_table = pd.merge(full_table,drivercount,on="city")
full_table = pd.merge(full_table,citytype,on="city")
```

## Bubble Plot of Ride Sharing Data


```
# Do separately for each city type
urban = full_table.loc[full_table["type"]=="Urban"]
suburban = full_table.loc[full_table["type"]=="Suburban"]
rural = full_table.loc[full_table["type"]=="Rural"]

mag = 4 # Magnify bubbles
ax1 = urban.plot(kind="scatter", x="numrides", y="avgfare", s=mag*full_table['driver_count'], color='coral', alpha=0.5, edgecolor='black', linewidths=1, label='Urban')
ax2 = suburban.plot(kind="scatter", x="numrides", y="avgfare", s=mag*full_table['driver_count'], color='lightblue', alpha=0.5, edgecolor='black', linewidths=1, label='Suburban', ax = ax1)
ax3 = rural.plot(kind="scatter", x="numrides", y="avgfare", s=mag*full_table['driver_count'], color='gold', alpha=0.5, edgecolor='black', linewidths=1, label='Rural', ax = ax1)
```


```
plt.ylim(15,45) # Per example, excludes some outliers
```




    (15, 45)




```
plt.xlim(0,40) # Per example, excludes some outliers
```




    (0, 40)




```
plt.title("Pyber Ride Sharing Data (2016)")
plt.xlabel("Total Number of Rides (Per City)")
plt.ylabel("Average Fare ($)")
plt.grid(True)
```


```
print("Note:")
print("Circle size correlates with driver count per city.")
plt.show()
```

    Note:
    Circle size correlates with driver count per city.



![png](output_14_1.png)


## Total Fares by City Type


```
# Similar exercise as with bubble plots, just on df that has fares and not avgfares
urban_ride = ride_data_full.loc[ride_data_full["type"]=="Urban"]
fare_urban = urban_ride["fare"].sum()

suburban_ride = ride_data_full.loc[ride_data_full["type"]=="Suburban"]
fare_suburban = suburban_ride["fare"].sum()

rural_ride = ride_data_full.loc[ride_data_full["type"]=="Rural"]
fare_rural = rural_ride["fare"].sum()

fare_total = fare_urban + fare_suburban + fare_rural

# Calculate percentages
fare_urban_perc = fare_urban/fare_total
fare_suburban_perc = fare_suburban/fare_total
fare_rural_perc = fare_rural/fare_total
```


```
# Make pie chart

# Labels for the sections of our pie chart
labels = ["Urban","Suburban","Rural"]

# The values of each section of the pie chart
sizes = [fare_urban_perc, fare_suburban_perc, fare_rural_perc]

# The colors of each section of the pie chart
colors = ["coral","lightblue","gold"]

# Tells matplotlib to seperate the "Python" section from the others
explode = (0.1, 0, 0)

# Creates the pie chart based upon the values above
# Automatically finds the percentages of each part of the pie chart
plt.pie(sizes, explode=explode, labels=labels, colors=colors,
        autopct="%1.1f%%", shadow=True, startangle=242)

# Tells matplotlib that we want a pie chart with equal axes
plt.axis("equal")

# Add title
plt.title("% of Total Fares by City Type")

# Prints our pie chart to the screen
plt.show()
```


![png](output_17_0.png)


## Total Rides by City Type


```
rides_urban = urban["numrides"].sum()
rides_urban

rides_suburban = suburban["numrides"].sum()
rides_suburban

rides_rural = rural["numrides"].sum()
rides_rural

rides_total = rides_urban + rides_suburban + rides_rural

# Calculate percentages
rides_urban_perc = rides_urban/rides_total
rides_suburban_perc = rides_suburban/rides_total
rides_rural_perc = rides_rural/rides_total

```


```
# Make pie chart

# Labels for the sections of our pie chart
labels = ["Urban","Suburban","Rural"]

# The values of each section of the pie chart
sizes = [rides_urban_perc, rides_suburban_perc, rides_rural_perc]

# The colors of each section of the pie chart
colors = ["coral","lightblue","gold"]

# Tells matplotlib to seperate the "Python" section from the others
explode = (0.1, 0, 0)

# Creates the pie chart based upon the values above
# Automatically finds the percentages of each part of the pie chart
plt.pie(sizes, explode=explode, labels=labels, colors=colors,
        autopct="%1.1f%%", shadow=True, startangle=235)

# Tells matplotlib that we want a pie chart with equal axes
plt.axis("equal")

# Add title
plt.title("% of Total Rides by City Type")

# Prints our pie chart to the screen
plt.show()

```


![png](output_20_0.png)


## Total Drivers by City Type


```
drivers_urban = urban["driver_count"].sum()
drivers_urban

drivers_suburban = suburban["driver_count"].sum()
drivers_suburban

drivers_rural = rural["driver_count"].sum()
drivers_rural

drivers_total = drivers_urban + drivers_suburban + drivers_rural

# Calculate percentages
drivers_urban_perc = drivers_urban/drivers_total
drivers_suburban_perc = drivers_suburban/drivers_total
drivers_rural_perc = drivers_rural/drivers_total
```


```
# Make pie chart

# Labels for the sections of our pie chart
labels = ["Urban","Suburban","Rural"]

# The values of each section of the pie chart
sizes = [drivers_urban_perc, drivers_suburban_perc, drivers_rural_perc]

# The colors of each section of the pie chart
colors = ["coral","lightblue","gold"]

# Tells matplotlib to seperate the "Python" section from the others
explode = (0.1, 0, 0)

# Creates the pie chart based upon the values above
# Automatically finds the percentages of each part of the pie chart
plt.pie(sizes, explode=explode, labels=labels, colors=colors,
        autopct="%1.1f%%", shadow=True, startangle=235)

# Tells matplotlib that we want a pie chart with equal axes
plt.axis("equal")

# Add title
plt.title("% of Total Drivers by City Type")

# Prints our pie chart to the screen
plt.show()
```


![png](output_23_0.png)



```
# Note, I see that the ordering in the chart is flipped for suburban and rural vs. the example. 
# Guessing that doesn't matter, otherwise, I would simply switch the order in my 'pie chart' code section.
```
