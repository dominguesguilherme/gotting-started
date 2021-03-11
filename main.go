package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	PORT := os.Getenv("PORT")

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello World from path: %s!\n", r.URL.Path)
	})
	http.ListenAndServe(":"+PORT, nil)
}
