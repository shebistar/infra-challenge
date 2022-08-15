package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	fmt.Println("Hivemind's Go Greeter")
	fmt.Println("You are running the service with this tag: ", os.Getenv("HELLO_TAG"))
	fmt.Println("This is my version: ", os.Getenv("VERSION"))
	http.HandleFunc("/", HelloServer)
	http.ListenAndServe(":8080", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	fmtStr := fmt.Sprintf("Hello, %s! I'm %s", GetIPFromRequest(r), os.Getenv("HOSTNAME"), "This is my HELLO_TAG", os.Getenv("HELLO_TAG"), "This is my VERSION", os.Getenv("VERSION"))
	fmt.Println(fmtStr)
	fmt.Fprintln(w, fmtStr)
}

func GetIPFromRequest(r *http.Request) string {
	if fwd := r.Header.Get("x-forwarded-for"); fwd != "" {
		return fwd
	}

	return r.RemoteAddr
}
