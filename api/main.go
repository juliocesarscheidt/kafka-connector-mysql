package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

// Data is the content of request
type Data struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
	Email string `json:"email"`
	Password string `json:"password"`
	CreatedAt int `json:"created_at"`
	UpdatedAt int `json:"updated_at"`
	DeleteAt int `json:"deleted_at"`
}

func returnHTTPResponse(writter http.ResponseWriter, responseMap map[string]interface{}, status int) {
	res, err := json.Marshal(responseMap)
	if err != nil {
		fmt.Println("[ERROR]", err)
	}

	writter.WriteHeader(status)
	writter.Write([]byte(string(res)))
	return
}

func usersCreate() http.HandlerFunc {
	return func(writter http.ResponseWriter, req *http.Request) {
		writter.Header().Set("Content-Type", "application/json")

		_, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()

		defer req.Body.Close()
		var responseHTTP = make(map[string]interface{})

		if req.Method != "POST" {
			responseHTTP["status"] = "error"
			responseHTTP["message"] = "invalid method"
			returnHTTPResponse(writter, responseHTTP, http.StatusBadRequest)
			return
		}

		body, _ := ioutil.ReadAll(req.Body)
		fmt.Println(string(body))

		data := Data{}
		if err := json.Unmarshal([]byte(string(body)), &data); err != nil {
			fmt.Println("[ERROR]", err)

			responseHTTP["status"] = "error"
			responseHTTP["message"] = "invalid data format"
			returnHTTPResponse(writter, responseHTTP, http.StatusUnprocessableEntity)
			return
		}

		jsonData, _ := json.Marshal(data)
		// fmt.Println(string(jsonData))

		responseHTTP["status"] = "ok"
		responseHTTP["data"] = string(jsonData)
		returnHTTPResponse(writter, responseHTTP, http.StatusOK)
	}
}

func main() {
	port := 5000

	fmt.Printf("Listening at port %d", port)
	// POST method
	http.HandleFunc("/v1/users", usersCreate())

	http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
}
