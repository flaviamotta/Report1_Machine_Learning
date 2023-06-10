# Report1_Machine_Learning
This project focuses on comparing the performance of Lasso, Ridge, and Least Square regression models in predicting the rental values of apartments in three cities: São Paulo, Rio de Janeiro, and Belo Horizonte. The dataset includes various covariates such as property characteristics, location, and amenities.

Key Findings:

- Initially, an 80% - 20% split was chosen for training and testing. However, further analysis using confidence intervals revealed that this split is consistent with the desired interval, leading to the decision to proceed with this division.
- Due to a significant proportion of observations being either houses or apartments in buildings with less than six floors, a new categorical variable called "floor2" was created. It categorized properties as "house" for houses, "apto_4" for apartments in buildings with less than five floors, and "apto_5+" for apartments in buildings with five or more floors, considering the legal requirement for elevators in such buildings.
- The "animal" and "furniture" variables were transformed into factors to better represent their categorical nature.
- The three regression models (Lasso, Ridge, and Least Square) were estimated, and the Lasso model identified the best value of λ (24.41898) through cross-validation on the training set.
- The standard errors of the three models were comparable, making it challenging to determine which model exhibited better predictive performance. The mean squared error (MSE) and confidence interval widths were high for all three regression types, possibly due to the limited number of available covariates.
- Despite Ridge regression showing the lowest MSE and standard error, the Lasso model was considered preferable due to its advantage of excluding unnecessary covariates.
- The coefficient interpretation aligns with expectations, indicating that larger properties with more rooms, bathrooms, parking spaces, and furnished options tend to have higher rental values. Apartments in buildings with five or more floors typically command higher rents due to additional amenities, common areas, and the presence of elevators.
- Rent values were generally higher in São Paulo, followed by Rio de Janeiro and Belo Horizonte, as anticipated.


Overall, this project provides insights into the performance and interpretability of Lasso, Ridge, and Least Square regression models for rent prediction in different cities. The findings highlight the influence of property characteristics and location on rental values, aiding in decision-making processes for landlords and real estate professionals operating in these areas.
