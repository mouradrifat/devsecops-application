package main

deny[msg] {
    input[i].Cmd == "FROM"
    not startswith(input[i].Value[0], "eclipse-temurin")
    msg := sprintf("Line %d: unauthorized base image %s", [i, input[i].Value[0]])
}