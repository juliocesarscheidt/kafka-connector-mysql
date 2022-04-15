package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

// UserDTO is the content of request
type UserDTO struct {
	ID        int64  `json:"id"`
	Name      string `json:"name"`
	Email     string `json:"email"`
	Password  string `json:"password"`
	CreatedAt int    `json:"created_at"`
	UpdatedAt int    `json:"updated_at"`
	DeleteAt  int    `json:"deleted_at"`
}

var users []UserDTO

func returnHTTPResponse(writter http.ResponseWriter, responseMap map[string]interface{}, status int) {
	res, err := json.Marshal(responseMap)
	if err != nil {
		fmt.Println("[ERROR]", err)
	}

	writter.WriteHeader(status)
	writter.Write([]byte(string(res)))
	return
}

func usersHandle() http.HandlerFunc {
	return func(writter http.ResponseWriter, req *http.Request) {
		writter.Header().Set("Content-Type", "application/json")

		_, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()

		defer req.Body.Close()

		fmt.Println("req.Method", req.Method)

		if req.Method == "GET" {
			usersGet(writter, req)
			return
		} else if req.Method == "POST" {
			usersCreate(writter, req)
			return
		}

		var responseHTTP = make(map[string]interface{})
		responseHTTP["status"] = "error"
		responseHTTP["message"] = "invalid method"
		returnHTTPResponse(writter, responseHTTP, http.StatusBadRequest)
	}
}

func usersGet(writter http.ResponseWriter, req *http.Request) {
	// fmt.Println(string(jsonData))
	var responseHTTP = make(map[string]interface{})
	responseHTTP["status"] = "ok"
	responseHTTP["data"] = users
	returnHTTPResponse(writter, responseHTTP, http.StatusOK)
}

func usersCreate(writter http.ResponseWriter, req *http.Request) {
	body, _ := ioutil.ReadAll(req.Body)
	fmt.Println(string(body))

	var responseHTTP = make(map[string]interface{})
	user := UserDTO{}
	fmt.Println(user)

	if err := json.Unmarshal([]byte(string(body)), &user); err != nil {
		fmt.Println("[ERROR]", err)

		responseHTTP["status"] = "error"
		responseHTTP["message"] = "invalid user format"
		returnHTTPResponse(writter, responseHTTP, http.StatusUnprocessableEntity)
		return
	}

	users = append(users, user)
	fmt.Println(users)

	responseHTTP["status"] = "ok"
	responseHTTP["data"] = user
	returnHTTPResponse(writter, responseHTTP, http.StatusOK)
}

func main() {
	port := 5000

	http.HandleFunc("/v1/users", usersHandle())

	fmt.Printf("Listening at port %d", port)
	http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
}
