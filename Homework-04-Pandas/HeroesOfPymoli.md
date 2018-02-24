
# Heroes of Pymoli Data Analysis

Observable trends:
1. Males (80%+) and ages 15-29 (75%+) are the core market.
2. Even the most popular items have only been purchased by less than 2% of users (11/573), so there might be an opportunity to market these more, perhaps through peer pressure (i.e. sending messages like "look what items your friends are buying").
3. On this note, there seems to be strong demand for products that cost 2x the most popular ones. For example, the retribution axe costs over $4, but is still the third highest selling item. Would need more info, but perhaps there is room to raise the price on some items. Would want to better understand "why" certain items get bought. I mean, are the most profitable items also more powerful in the game, or is it just a branding thing?


```python
import pandas as pd

purchase_data_json = "purchase_data.json"
purchase_data_df = pd.read_json(purchase_data_json)
```

## Player Count


```python
player_count = len(purchase_data_df["SN"].unique())
player_count_df = pd.DataFrame({"Total Players": [player_count]})
player_count_df
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
      <th>Total Players</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>573</td>
    </tr>
  </tbody>
</table>
</div>



## Purchasing Analysis (Total)


```python
unique_item_count = len(purchase_data_df["Item ID"].unique())
avg_purchase_price = purchase_data_df["Price"].mean()
total_num_purchases = len(purchase_data_df)
total_revenue = purchase_data_df["Price"].sum()

purchasing_analysis_df = pd.DataFrame({"Number of Unique Items": [unique_item_count], 
                                       "Average Price": [avg_purchase_price], 
                                       "Number of Purchases": [total_num_purchases], 
                                       "Total Revenue": [total_revenue]})

# Formatting
purchasing_analysis_df["Average Price"] = purchasing_analysis_df["Average Price"].map("${:,.2f}".format)
purchasing_analysis_df["Total Revenue"] = purchasing_analysis_df["Total Revenue"].map("${:,.2f}".format)
purchasing_analysis_df.head()
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
      <th>Average Price</th>
      <th>Number of Purchases</th>
      <th>Number of Unique Items</th>
      <th>Total Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>$2.93</td>
      <td>780</td>
      <td>183</td>
      <td>$2,286.33</td>
    </tr>
  </tbody>
</table>
</div>



## Gender Demographics


```python
gender_name_data_df = purchase_data_df[["SN","Gender"]]
gender_name_data_df = gender_name_data_df.drop_duplicates(["SN"])

gender_counts = gender_name_data_df["Gender"].value_counts()

gender_percentages = 100*gender_counts/player_count
gender_percentages = gender_percentages.map("{:,.2f}".format)

gender_demographics_df = pd.DataFrame({"Percentage of Players":gender_percentages,
                                       "Total Count":gender_counts})
gender_demographics_df
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
      <th>Percentage of Players</th>
      <th>Total Count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Male</th>
      <td>81.15</td>
      <td>465</td>
    </tr>
    <tr>
      <th>Female</th>
      <td>17.45</td>
      <td>100</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>1.40</td>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>



## Purchasing Analysis (Gender)


```python
gender_purchase_data_df = purchase_data_df.groupby(['Gender'])

gender_purchase_count = gender_purchase_data_df["SN"].count()

gender_avg_purchase_price = gender_purchase_data_df["Price"].mean()
gender_avg_purchase_price = gender_avg_purchase_price.map("${:,.2f}".format)

gender_total_purchase_value = gender_purchase_data_df["Price"].sum()

gender_purchasing_analysis_df = pd.DataFrame({"Purchase Count":gender_purchase_count,
                                              "Average Purchase Price":gender_avg_purchase_price, 
                                              "Total Purchase Value": gender_total_purchase_value, 
                                              #"Normalized Totals": gender_normalized_purchase_price
                                             })

# Adding normalized column
gender_demo_normalized_df = gender_demographics_df.merge(gender_purchasing_analysis_df, left_index = True,right_index = True)

normalized_totals = gender_demo_normalized_df["Total Purchase Value"]/gender_demo_normalized_df["Total Count"]
normalized_totals_df = pd.DataFrame(normalized_totals,columns=["Normalized Totals"])

gender_demo_normalized_df = gender_demo_normalized_df.merge(normalized_totals_df, left_index = True,right_index = True)

new_gender_purchasing_analysis_df = gender_demo_normalized_df[["Purchase Count",
                                              "Average Purchase Price", 
                                              "Total Purchase Value", 
                                              "Normalized Totals"
                                                              ]]

# Formatting
new_gender_purchasing_analysis_df['Total Purchase Value'] = new_gender_purchasing_analysis_df['Total Purchase Value'].map("${:,.2f}".format)
new_gender_purchasing_analysis_df['Normalized Totals'] = new_gender_purchasing_analysis_df['Normalized Totals'].map("${:,.2f}".format)
new_gender_purchasing_analysis_df
```

    /Users/knudsen80/anaconda3/lib/python3.6/site-packages/ipykernel_launcher.py:31: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
    /Users/knudsen80/anaconda3/lib/python3.6/site-packages/ipykernel_launcher.py:32: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy





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
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
      <th>Normalized Totals</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Male</th>
      <td>633</td>
      <td>$2.95</td>
      <td>$1,867.68</td>
      <td>$4.02</td>
    </tr>
    <tr>
      <th>Female</th>
      <td>136</td>
      <td>$2.82</td>
      <td>$382.91</td>
      <td>$3.83</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>11</td>
      <td>$3.25</td>
      <td>$35.74</td>
      <td>$4.47</td>
    </tr>
  </tbody>
</table>
</div>



## Age Demographics


```python
# Note: They ask for "bins of 4 years" but give an example of 5 year bins.
bins = [0,9,14,19,24,29,34,39,199]
group_names = ['<10','10-14','15-19','20-24','25-29','30-34','35-39','40+']

age_purchase_data_df = purchase_data_df[["SN","Age","Price"]]
age_name_data_df = age_purchase_data_df.drop_duplicates(["SN"])

pd.cut(age_name_data_df["Age"], bins, labels=group_names)
age_name_data_df["Age Buckets"] = pd.cut(age_name_data_df["Age"], bins, labels=group_names)

age_name_data_groups_df = age_name_data_df.groupby("Age Buckets")

age_counts = age_name_data_groups_df["Age"].count()

age_percentages = 100*age_counts/player_count
age_percentages = age_percentages.map("{:,.2f}".format)

age_demographics_df = pd.DataFrame({"Percentage of Players":age_percentages,
                                       "Total Count":age_counts})
age_demographics_df
```

    /Users/knudsen80/anaconda3/lib/python3.6/site-packages/ipykernel_launcher.py:9: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
      if __name__ == '__main__':





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
      <th>Percentage of Players</th>
      <th>Total Count</th>
    </tr>
    <tr>
      <th>Age Buckets</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>&lt;10</th>
      <td>3.32</td>
      <td>19</td>
    </tr>
    <tr>
      <th>10-14</th>
      <td>4.01</td>
      <td>23</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>17.45</td>
      <td>100</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>45.20</td>
      <td>259</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>15.18</td>
      <td>87</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>8.20</td>
      <td>47</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>4.71</td>
      <td>27</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>1.92</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



## Purchasing Analysis (Age)


```python
pd.cut(age_purchase_data_df["Age"], bins, labels=group_names)
age_purchase_data_df["Age Buckets"] = pd.cut(age_purchase_data_df["Age"], bins, labels=group_names)

age_purchase_data_groups_df = age_purchase_data_df.groupby("Age Buckets")

age_purchase_count = age_purchase_data_groups_df["SN"].count()

age_avg_purchase_price = age_purchase_data_groups_df["Price"].mean()
age_avg_purchase_price = age_avg_purchase_price.map("${:,.2f}".format)

age_total_purchase_value = age_purchase_data_groups_df["Price"].sum()

age_purchasing_analysis_df = pd.DataFrame({"Purchase Count":age_purchase_count,
                                              "Average Purchase Price":age_avg_purchase_price, 
                                              "Total Purchase Value": age_total_purchase_value, 
                                              #"Normalized Totals": age_normalized_totals
                                             })

# Adding normalized column
age_demo_normalized_df = age_demographics_df.merge(age_purchasing_analysis_df, left_index = True,right_index = True)

age_normalized_totals = age_demo_normalized_df["Total Purchase Value"]/age_demo_normalized_df["Total Count"]
age_normalized_totals_df = pd.DataFrame(age_normalized_totals,columns=["Normalized Totals"])

age_demo_normalized_df = age_demo_normalized_df.merge(age_normalized_totals_df, left_index = True,right_index = True)

new_age_purchasing_analysis_df = age_demo_normalized_df[["Purchase Count",
                                              "Average Purchase Price", 
                                              "Total Purchase Value", 
                                              "Normalized Totals"
                                                              ]]

# Formatting
new_age_purchasing_analysis_df['Total Purchase Value'] = new_age_purchasing_analysis_df['Total Purchase Value'].map("${:,.2f}".format)
new_age_purchasing_analysis_df['Normalized Totals'] = new_age_purchasing_analysis_df['Normalized Totals'].map("${:,.2f}".format)
new_age_purchasing_analysis_df
```

    /Users/knudsen80/anaconda3/lib/python3.6/site-packages/ipykernel_launcher.py:2: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
      
    /Users/knudsen80/anaconda3/lib/python3.6/site-packages/ipykernel_launcher.py:34: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
    /Users/knudsen80/anaconda3/lib/python3.6/site-packages/ipykernel_launcher.py:35: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy





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
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
      <th>Normalized Totals</th>
    </tr>
    <tr>
      <th>Age Buckets</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>&lt;10</th>
      <td>28</td>
      <td>$2.98</td>
      <td>$83.46</td>
      <td>$4.39</td>
    </tr>
    <tr>
      <th>10-14</th>
      <td>35</td>
      <td>$2.77</td>
      <td>$96.95</td>
      <td>$4.22</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>133</td>
      <td>$2.91</td>
      <td>$386.42</td>
      <td>$3.86</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>336</td>
      <td>$2.91</td>
      <td>$978.77</td>
      <td>$3.78</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>125</td>
      <td>$2.96</td>
      <td>$370.33</td>
      <td>$4.26</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>64</td>
      <td>$3.08</td>
      <td>$197.25</td>
      <td>$4.20</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>42</td>
      <td>$2.84</td>
      <td>$119.40</td>
      <td>$4.42</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>17</td>
      <td>$3.16</td>
      <td>$53.75</td>
      <td>$4.89</td>
    </tr>
  </tbody>
</table>
</div>



## Top Spenders


```python
sn_purchase_data_df = purchase_data_df.groupby(['SN'])

sn_purchase_count = sn_purchase_data_df["SN"].count()

sn_avg_purchase_price = sn_purchase_data_df["Price"].mean()

sn_total_purchase_value = sn_purchase_data_df["Price"].sum()

sn_purchasing_analysis_df = pd.DataFrame({"Purchase Count":sn_purchase_count,
                                              "Average Purchase Price":sn_avg_purchase_price, 
                                              "Total Purchase Value":sn_total_purchase_value, 
                                             })

sorted_sn_purchasing_analysis_df = sn_purchasing_analysis_df.sort_values("Total Purchase Value",ascending=False).head(5)

sorted_sn_purchasing_analysis_df.style.format({
    'Average Purchase Price': '${:,.2f}'.format,
    'Total Purchase Value': '${:,.2f}'.format
    })
```




<style  type="text/css" >
</style>  
<table id="T_9a64ac62_191c_11e8_921c_acde48001122" > 
<thead>    <tr> 
        <th class="blank level0" ></th> 
        <th class="col_heading level0 col0" >Average Purchase Price</th> 
        <th class="col_heading level0 col1" >Purchase Count</th> 
        <th class="col_heading level0 col2" >Total Purchase Value</th> 
    </tr>    <tr> 
        <th class="index_name level0" >SN</th> 
        <th class="blank" ></th> 
        <th class="blank" ></th> 
        <th class="blank" ></th> 
    </tr></thead> 
<tbody>    <tr> 
        <th id="T_9a64ac62_191c_11e8_921c_acde48001122level0_row0" class="row_heading level0 row0" >Undirrala66</th> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row0_col0" class="data row0 col0" >$3.41</td> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row0_col1" class="data row0 col1" >5</td> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row0_col2" class="data row0 col2" >$17.06</td> 
    </tr>    <tr> 
        <th id="T_9a64ac62_191c_11e8_921c_acde48001122level0_row1" class="row_heading level0 row1" >Saedue76</th> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row1_col0" class="data row1 col0" >$3.39</td> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row1_col1" class="data row1 col1" >4</td> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row1_col2" class="data row1 col2" >$13.56</td> 
    </tr>    <tr> 
        <th id="T_9a64ac62_191c_11e8_921c_acde48001122level0_row2" class="row_heading level0 row2" >Mindimnya67</th> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row2_col0" class="data row2 col0" >$3.18</td> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row2_col1" class="data row2 col1" >4</td> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row2_col2" class="data row2 col2" >$12.74</td> 
    </tr>    <tr> 
        <th id="T_9a64ac62_191c_11e8_921c_acde48001122level0_row3" class="row_heading level0 row3" >Haellysu29</th> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row3_col0" class="data row3 col0" >$4.24</td> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row3_col1" class="data row3 col1" >3</td> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row3_col2" class="data row3 col2" >$12.73</td> 
    </tr>    <tr> 
        <th id="T_9a64ac62_191c_11e8_921c_acde48001122level0_row4" class="row_heading level0 row4" >Eoda93</th> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row4_col0" class="data row4 col0" >$3.86</td> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row4_col1" class="data row4 col1" >3</td> 
        <td id="T_9a64ac62_191c_11e8_921c_acde48001122row4_col2" class="data row4 col2" >$11.58</td> 
    </tr></tbody> 
</table> 



## Most Popular Items


```python
item_purchase_data_df = purchase_data_df.groupby(['Item ID'])

item_purchase_count = pd.DataFrame(item_purchase_data_df["Item ID"].count())
item_purchase_count.rename(columns = {"Item ID": "Purchase Count"}, inplace = True)

item_total_purchase_value = pd.DataFrame(item_purchase_data_df["Price"].sum())
item_total_purchase_value.rename(columns = {"Price": "Total Purchase Value"}, inplace = True)

item_list = purchase_data_df.drop_duplicates('Item ID')
item_list.rename(columns = {"Price":"Item Price"}, inplace = True)

item_purchasing_analysis_df = item_list.merge(item_purchase_count, left_on="Item ID", right_index = True)
item_purchasing_analysis_df = item_purchasing_analysis_df.merge(item_total_purchase_value, left_on="Item ID", right_index = True)

item_purchasing_analysis_df = item_purchasing_analysis_df[["Item ID","Item Name","Purchase Count","Item Price","Total Purchase Value"]] 

sorted_popular_item_df = item_purchasing_analysis_df.sort_values("Purchase Count",ascending=False).head(5)

sorted_popular_item_df.style.format({
    'Item Price': '${:,.2f}'.format,
    'Total Purchase Value': '${:,.2f}'.format
    })
```

    /Users/knudsen80/anaconda3/lib/python3.6/site-packages/pandas/core/frame.py:2746: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
      **kwargs)





<style  type="text/css" >
</style>  
<table id="T_9afeabbe_191c_11e8_8729_acde48001122" > 
<thead>    <tr> 
        <th class="blank level0" ></th> 
        <th class="col_heading level0 col0" >Item ID</th> 
        <th class="col_heading level0 col1" >Item Name</th> 
        <th class="col_heading level0 col2" >Purchase Count</th> 
        <th class="col_heading level0 col3" >Item Price</th> 
        <th class="col_heading level0 col4" >Total Purchase Value</th> 
    </tr></thead> 
<tbody>    <tr> 
        <th id="T_9afeabbe_191c_11e8_8729_acde48001122level0_row0" class="row_heading level0 row0" >61</th> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row0_col0" class="data row0 col0" >39</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row0_col1" class="data row0 col1" >Betrayal, Whisper of Grieving Widows</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row0_col2" class="data row0 col2" >11</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row0_col3" class="data row0 col3" >$2.35</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row0_col4" class="data row0 col4" >$25.85</td> 
    </tr>    <tr> 
        <th id="T_9afeabbe_191c_11e8_8729_acde48001122level0_row1" class="row_heading level0 row1" >116</th> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row1_col0" class="data row1 col0" >84</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row1_col1" class="data row1 col1" >Arcane Gem</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row1_col2" class="data row1 col2" >11</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row1_col3" class="data row1 col3" >$2.23</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row1_col4" class="data row1 col4" >$24.53</td> 
    </tr>    <tr> 
        <th id="T_9afeabbe_191c_11e8_8729_acde48001122level0_row2" class="row_heading level0 row2" >81</th> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row2_col0" class="data row2 col0" >175</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row2_col1" class="data row2 col1" >Woeful Adamantite Claymore</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row2_col2" class="data row2 col2" >9</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row2_col3" class="data row2 col3" >$1.24</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row2_col4" class="data row2 col4" >$11.16</td> 
    </tr>    <tr> 
        <th id="T_9afeabbe_191c_11e8_8729_acde48001122level0_row3" class="row_heading level0 row3" >35</th> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row3_col0" class="data row3 col0" >13</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row3_col1" class="data row3 col1" >Serenity</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row3_col2" class="data row3 col2" >9</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row3_col3" class="data row3 col3" >$1.49</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row3_col4" class="data row3 col4" >$13.41</td> 
    </tr>    <tr> 
        <th id="T_9afeabbe_191c_11e8_8729_acde48001122level0_row4" class="row_heading level0 row4" >56</th> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row4_col0" class="data row4 col0" >31</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row4_col1" class="data row4 col1" >Trickster</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row4_col2" class="data row4 col2" >9</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row4_col3" class="data row4 col3" >$2.07</td> 
        <td id="T_9afeabbe_191c_11e8_8729_acde48001122row4_col4" class="data row4 col4" >$18.63</td> 
    </tr></tbody> 
</table> 



## Most Profitable Items


```python
sorted_profitable_item_df = item_purchasing_analysis_df.sort_values("Total Purchase Value",ascending=False).head(5)

sorted_profitable_item_df.style.format({
    'Item Price': '${:,.2f}'.format,
    'Total Purchase Value': '${:,.2f}'.format
    })
```




<style  type="text/css" >
</style>  
<table id="T_9bf84714_191c_11e8_adc2_acde48001122" > 
<thead>    <tr> 
        <th class="blank level0" ></th> 
        <th class="col_heading level0 col0" >Item ID</th> 
        <th class="col_heading level0 col1" >Item Name</th> 
        <th class="col_heading level0 col2" >Purchase Count</th> 
        <th class="col_heading level0 col3" >Item Price</th> 
        <th class="col_heading level0 col4" >Total Purchase Value</th> 
    </tr></thead> 
<tbody>    <tr> 
        <th id="T_9bf84714_191c_11e8_adc2_acde48001122level0_row0" class="row_heading level0 row0" >57</th> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row0_col0" class="data row0 col0" >34</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row0_col1" class="data row0 col1" >Retribution Axe</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row0_col2" class="data row0 col2" >9</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row0_col3" class="data row0 col3" >$4.14</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row0_col4" class="data row0 col4" >$37.26</td> 
    </tr>    <tr> 
        <th id="T_9bf84714_191c_11e8_adc2_acde48001122level0_row1" class="row_heading level0 row1" >107</th> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row1_col0" class="data row1 col0" >115</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row1_col1" class="data row1 col1" >Spectral Diamond Doomblade</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row1_col2" class="data row1 col2" >7</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row1_col3" class="data row1 col3" >$4.25</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row1_col4" class="data row1 col4" >$29.75</td> 
    </tr>    <tr> 
        <th id="T_9bf84714_191c_11e8_adc2_acde48001122level0_row2" class="row_heading level0 row2" >50</th> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row2_col0" class="data row2 col0" >32</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row2_col1" class="data row2 col1" >Orenmir</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row2_col2" class="data row2 col2" >6</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row2_col3" class="data row2 col3" >$4.95</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row2_col4" class="data row2 col4" >$29.70</td> 
    </tr>    <tr> 
        <th id="T_9bf84714_191c_11e8_adc2_acde48001122level0_row3" class="row_heading level0 row3" >100</th> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row3_col0" class="data row3 col0" >103</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row3_col1" class="data row3 col1" >Singed Scalpel</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row3_col2" class="data row3 col2" >6</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row3_col3" class="data row3 col3" >$4.87</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row3_col4" class="data row3 col4" >$29.22</td> 
    </tr>    <tr> 
        <th id="T_9bf84714_191c_11e8_adc2_acde48001122level0_row4" class="row_heading level0 row4" >164</th> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row4_col0" class="data row4 col0" >107</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row4_col1" class="data row4 col1" >Splitter, Foe Of Subtlety</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row4_col2" class="data row4 col2" >8</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row4_col3" class="data row4 col3" >$3.61</td> 
        <td id="T_9bf84714_191c_11e8_adc2_acde48001122row4_col4" class="data row4 col4" >$28.88</td> 
    </tr></tbody> 
</table> 


