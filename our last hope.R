install.packages("imager")
library(keras)
library(imager)

model <- load_model_tf("C:/Users/Quesadilla/Documents/332/Project2/model/dandelion_model")
img <- image_load("C:/Users/Quesadilla/Documents/332/Project2/data-for-332.tar/data-for-332/data-for-332/data-for-332/dandelions/dandelion_yellow_flower_230715-1599547728.jpg")

loss_fn <- function(y_true, y_pred){
  mean(k_categorical_crossentropy(y_true, y_pred))
}

fgsm <- function(model, x, y, esp = 0.01){
  grad_fn <- k_gradients(loss_fn, model$trainable_weights)
  grad <- grad_fn(list(x, y))[[1]]
  
  x_adv <- x + esp * sign(grad)
  
  return(x_adv)
}

x_adv <- fgsm(model, img, 1, esp = 0.1)

pred <- model %>% predict(x_adv)

class_label <- class.ind2label(pred)