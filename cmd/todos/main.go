package main

import (
    "net/http"

    "github.com/gin-gonic/gin"
)

type todo struct {
	ID   int64  `json:"id"`
	Task string `json:"task"`
	Done bool   `json:"done"`
}

func main() {
	todos := []todo{
		{
			ID:   1,
			Task: "Venture forth and continue exploring Nix and DevOps",
			Done: false,
		},
	}

    r := gin.Default()

    // Simple health endpoint for readiness/liveness probes
    r.GET("/health", func(c *gin.Context) {
        c.String(http.StatusOK, "ok")
    })

    r.GET("/todos", func(c *gin.Context) {
        c.JSON(http.StatusOK, todos)
    })

    // Bind explicitly to port 8080
    _ = r.Run(":8080")
}
