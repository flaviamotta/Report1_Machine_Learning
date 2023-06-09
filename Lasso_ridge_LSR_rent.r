library(readr)
library(dplyr)
library(tidyverse)
library(magrittr)
library(ggplot2)
library(glmnet)
library(xtable)

colnames <- c("city", "area", "rooms", "bathroom", "park_spaces", "floor", "animal",
"furniture", "rent_am")

data <- read_csv("D:/__Mestrado/Lista 1/houses_to_rent_v2.csv",
na = "-", skip=1,
col_types = "cdddddffd",
col_names = colnames)

#Filter São Paulo, Rio de Janeiro and Belo Horizonte
data %<>% filter(city %in% c("São Paulo", "Rio de Janeiro", "Belo Horizonte"))
data$city <- as.factor(data$city)

#data splitting
#At first, the division of 80% and 20% was chosen. However, later, an analysis was made with the 
#confidence intervals in order to understand whether this chosen percentage is consistent with the
#desired interval. The results show that the chosen division is suitable for the database. This 
#because even though the amplitude is smaller in the division 70% - 30%, we obtain a higher estimated
#risk. We then decided to continue with the choice of 80% and 20%


set.seed(57)
data_split <- sample(c("Treino", "Teste"),
size = nrow(data),
prob = c(0.8, 0.2),
replace = TRUE)
table(data_split)

# Teste Treino
# 1772 6874

data_split70_30 <- sample(c("Treino", "Teste"),
size = nrow(data),
prob = c(0.7, 0.3),
replace = TRUE)
table(data_split70_30)
# Teste Treino
# 2578 6068

data_split90_10 <- sample(c("Treino", "Teste"),
size = nrow(data),
prob = c(0.9, 0.1),
replace = TRUE)
table(data_split90_10)
# Teste Treino
# 856 7790

#) LASSO - 70%-30%
fitLinear.cv70_30 <- cv.glmnet(x = X[data_split70_30 == "Treino",],
y = y[data_split70_30 == "Treino"],
alpha = 1)
#CV lasso - 70%-30%
lasso70_30 = glmnet(x = X[data_split70_30 == "Treino",],
y = y[data_split70_30 == "Treino"],
alpha = 1, lambda = fitLinear.cv70_30$lambda.min)
pred70_30 <- predict(lasso70_30, newx = X[data_split70_30 == "Teste", ])
mse_lasso70_30 = mean((y[data_split70_30=="Teste"]-pred70_30)^2)
erro_padrao_lasso70_30 = sqrt(mse_lasso70_30/length(y[data_split70_30=="Teste"]))

#) LASSO - 90%-10%
fitLinear.cv90_10 <- cv.glmnet(x = X[data_split90_10 == "Treino",],
y = y[data_split90_10 == "Treino"],
alpha = 1)
#CV lasso - 90%-10%
lasso90_10 = glmnet(x = X[data_split90_10 == "Treino",],
y = y[data_split90_10 == "Treino"],
alpha = 1, lambda = fitLinear.cv90_10$lambda.min)
pred90_10 <- predict(lasso90_10, newx = X[data_split90_10 == "Teste", ])
mse_lasso90_10 = mean((y[data_split90_10=="Teste"]-pred90_10)^2)
erro_padrao_lasso90_10 = sqrt(mse_lasso90_10/length(y[data_split90_10=="Teste"]))

####Confidence Interval (Intervalo de Confianca IC)
IC_Risco_70_30 = IC_risco(m = 2578,yteste = y[data_split70_30=="Teste"], 
ypredito = pred70_IC_Risco_80_20 = IC_risco(yteste = y[data_split=="Teste"], ypredito = pred)
IC_Risco_90_10 = IC_risco(m = 856,yteste = y[data_split90_10=="Teste"], ypredito = pred90_10)
rbind(unlist(IC_Risco_70_30), unlist(IC_Risco_80_20), unlist(IC_Risco_90_10))

#Since most of the observations were either apartments whose buildings had less than 6 floors or were houses,
#a new categorical variable floor2 was created, with the values house, when the property was a house; apto_4,
#for apartments in buildings with less than five floors; apto_5+, for apartments in a building with five or more
#floors, we chose by this division due to the fact that it is mandatory, by law, that buildings with 5 floors 
#or more have elevator. Furthermore, the variables: "animal" and "furniture" were transformed into a factor.

data$floor %>% hist(., breaks = 50)
data$floor %>% as.factor() %>% summary()
#2063 houses (NA)
#aptos with 4 floors or - (do not need elevator)
#aptos with 5 floors or + (need elevator)

data %<>% mutate(floor2 = data$floor)
data$floor2[data$floor < 5] <- "apto_4"
data$floor2[data$floor >= 5] <- "apto_5+"
data$floor2[data$floor %in% NA] <- "casa"
data$floor2 %<>% as.factor()
summary(data$floor2)
# apto_4 apto_5+ casa
# 2765 3818 2063

#After these changes, the three regressions were estimated, and for the lasso, the best
#value of \lambda, found by cross-validation on the training set, was 24.41898.

# model.matrix X
X <- data[,c(2:5,7,8,10,1)]
X = model.matrix(~.,data = X)
X <- X[,-1]

y = data %>% dplyr::select(rent_am) %>% as.matrix()
#i) LSR
mq = glmnet(x = X[data_split == "Treino",],
y = y[data_split == "Treino"],
alpha =0, lambda = 0)
y_pred_mq = predict(mq, newx = X[data_split == "Teste", ])
mse_mq = mean((y[data_split=="Teste"]-y_pred_mq)^2)
erro_padrao_mq = sqrt(mse_mq/length(y[data_split=="Teste"]))

#ii) LASSO
fitLinear.cv <- cv.glmnet(x = X[data_split == "Treino",],
y = y[data_split == "Treino"],
alpha = 1)
#Lambda CV
lambda = fitLinear.cv$lambda.min
lambda #Best value for lambda
plot(fitLinear.cv)

#Adjusting lasso with the best lambda
lasso = glmnet(x = X[data_split == "Treino",],
y = y[data_split == "Treino"],
alpha = 1, lambda = lambda)
coefficients(lasso)
pred <- predict(lasso, newx = X[data_split == "Teste", ])
mse_lasso = mean((y[data_split=="Teste"]-pred)^2)
erro_padrao_lasso = sqrt(mse_lasso/length(y[data_split=="Teste"]))

#iii) Ridge Regression
cv_ridge <- cv.glmnet(x = X[data_split == "Treino",],
y = y[data_split == "Treino"],
alpha = 0)
ajuste_ridge <- glmnet(x = X[data_split == "Treino",],
y = y[data_split == "Treino"],
alpha = 0)
round(coefficients(ajuste_ridge, s = cv_ridge$lambda.min), 4)
predito_ridge <- predict(ajuste_ridge,
s = cv_ridge$lambda.min,
newx = X[data_split == "Teste", ])
mse_ridge = mean((y[data_split=="Teste"]-predito_ridge)^2)
erro_padrao_ridge = sqrt(mse_ridge/length(y[data_split=="Teste"]))

### CI - Risk ###
IC_risco <- function(m = 1772, yteste, ypredito){
R_hat = mean((yteste - ypredito)^2)
W_k = (yteste - ypredito)^2
W_medio = mean(W_k)
sigma2_hat = mean((W_k - W_medio)^2)
l = 1.96 * sqrt(sigma2_hat/m)
LI = R_hat - l
LS = R_hat + l
return(list(R_hat = R_hat, sigma2_hat = sigma2_hat,
amplitude = 2*l, LI = LI, LS = LS))
}
IC_Risco_MQ = IC_risco(yteste = y[data_split=="Teste"], ypredito = y_pred_mq)
IC_Risco_Lasso = IC_risco(yteste = y[data_split=="Teste"], ypredito = pred)
IC_Risco_Ridge = IC_risco(yteste = y[data_split=="Teste"], ypredito = predito_ridge)
rbind(unlist(IC_Risco_MQ), unlist(IC_Risco_Lasso), unlist(IC_Risco_Ridge))
coef <- cbind(round(coefficients(mq), 4),
round(coefficients(lasso),4),
round(coefficients(ajuste_ridge, s = cv_ridge$lambda.min), 4))

#The standard errors of the three types of model were very close, in this sense, it is difficult to say which of the models had 
#a better predictive performance, because both the MSE and the amplitude of the confidence intervals were high for all three types
#of regression. One of the possible reasons why the MSE of all estimated models was high is the small amount of covariates available.
#One of the components of the expected risk is the intrinsic variance of the response variable, and this can only be reduced if the 
#amount of observed covariates is increased. Although the ridge regression showed the lowest value for the MSE and for the standard
#error, it is understood that the lasso is preferable, since it has the advantage of not using one of the covariates.

#The coefficients interpretation makes sense for the fit in focus. Larger properties with more rooms, bathrooms, parking spaces or 
#furniture are expected to have a higher rental value. We also noticed that the rent of apartments in buildings with 5 floors or more
#is higher on average than those with up to 4 floors. This is usually because larger residential buildings tend to also have a greater
#structure in common areas, such as leisure areas and other improvements, in addition to the mandatory use of elevators. With regard to
#cities, as expected, rent is on average more expensive in the city of São Paulo, followed by Rio de Janeiro and Belo Horizonte.



