# Modelling-work-absenteeism
Modelling Work Absenteeism using the UCI dataset. The dataset is publicly available at https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=2ahUKEwiq_uiZh5bpAhVNhlwKHQJQCJsQFjAAegQIAhAB&url=http%3A%2F%2Farchive.ics.uci.edu%2Fml%2Fdatasets%2FAbsenteeism%2Bat%2Bwork&usg=AOvVaw0tjF3BsX2dB0XtY2aklfLH. After normalizing the data the linear regression was very good in modelling the data having achieved 3.986907e-15 RMSE and 1.589542e-29 MSE in the test set. The test set was 25% of the total data. 
What is really interesting is that the Bayesian Neural Network with 37 neurons only achieved 0.1032593 RMSE error. 
It's amazing how this is, a simple model versus a robust model. How a simple model, trained within seconds can outperform a robust model trained in minutes. Therefore, my suggestion is
# Start with easy models when modeling 
