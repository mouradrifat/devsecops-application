package main

deny contains msg if {
    input[i].Cmd == "FROM"
    val := split(input[i].Value[0], "/")
    count(val) > 1
    msg := sprintf("Line %d: use a trusted base image", [i])
}