package main

allowed := {
    "python:slim"
}

deny[msg] {
  base = input.docker.baseImage
  not valid(base)
  msg = sprintf("Not using a permitted base image: %v", [base])
}

valid(image) {
  allowed[image]  
}

valid(image) {
  startswith(image, "ghcr.io/garethr/snykt")  
}

valid(image) {
  startswith(image, "garethr/snykt/")  
}
