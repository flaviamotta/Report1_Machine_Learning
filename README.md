# Report1_Machine_Learning
Comparing the performance of Lasso, Ridge and Least Square regression in predicting the rent value of apartments in three cities: São Paulo,
Rio de Janeiro and Belo Horizonte.

At first, the division of 80% and 20% was chosen. However, later, an analysis was made with the 
confidence intervals in order to understand whether this percentage is consistent with the
desired interval. The results show that the chosen division is suitable for the database. This 
because even though the amplitude is smaller in the division 70% - 30%, we obtain a higher estimated
risk in this scenario. We then decided to continue with the choice of 80% and 20%

Since most of the observations were either apartments whose buildings had less than 6 floors or were houses,
a new categorical variable floor2 was created, with the values house, when the property was a house; apto_4,
for apartments in buildings with less than five floors; apto_5+, for apartments in a building with five or more
floors, we chose by this division due to the fact that it is mandatory, by law, that buildings with 5 floors 
or more have elevator. Furthermore, the variables: "animal" and "furniture" were transformed into factor.

After these changes, the three regressions were estimated, and for the lasso, the best value of \lambda, found by
cross-validation on the training set, was 24.41898.

The standard errors of the three types of model were very close, in this sense, it is difficult to say which of the models had 
a better predictive performance, because both the MSE and the amplitude of the confidence intervals were high for all three types
of regression. One of the possible reasons why the MSE of all estimated models was high is the small amount of covariates available.
One of the components of the expected risk is the intrinsic variance of the response variable, and this can only be reduced if the 
amount of observed covariates is increased. Although the ridge regression showed the lowest value for the MSE and for the standard
error, it is understood that the lasso is preferable, since it has the advantage of not using one of the covariates.

The coefficients interpretation makes sense for the fit in focus. Larger properties with more rooms, bathrooms, parking spaces or 
furniture are expected to have a higher rental value. We also noticed that the rent of apartments in buildings with 5 floors or more
is higher on average than those with up to 4 floors. This is usually because larger residential buildings tend to also have a greater
structure in common areas, such as leisure areas and other improvements, in addition to the mandatory use of elevators. With regard to
cities, as expected, rent is on average more expensive in the city of São Paulo, followed by Rio de Janeiro and Belo Horizonte.

