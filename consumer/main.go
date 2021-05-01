package main

import (
	"fmt"
	"time"
	"os"
	"strings"
	"gopkg.in/confluentinc/confluent-kafka-go.v1/kafka"
)

func CreateKafkaConsumer(bootstrapServers string) *kafka.Consumer {
	configMap := &kafka.ConfigMap{
		"bootstrap.servers": bootstrapServers,
		"group.id":          "consumer-group-0",
		"auto.offset.reset": "earliest",
	}

	consumer, err := kafka.NewConsumer(configMap)
	if err != nil {
		fmt.Println(err.Error())
		return nil
	}

	return consumer
}

func main() {
	var (
		bootstrapServers = os.Getenv("CONSUMER_BOOTSTRAP_SERVERS")
		topics = os.Getenv("TOPICS")
	)

	currentTime := time.Now()
	fmt.Println("[INFO] Started", currentTime.Format("2006.01.02 15:04:05"))

	consumer := CreateKafkaConsumer(bootstrapServers)
	defer consumer.Close()

	// mysql_namespace.kafka_database.users
	topicsSlice := strings.Split(topics, ",")
	fmt.Println(topicsSlice)

	consumer.SubscribeTopics(topicsSlice, nil)

	for {
		msg, err := consumer.ReadMessage(-1)
		if err != nil {
			fmt.Printf("Consumer error: %v (%v)\n", err, msg)
			panic(err)
		}

		fmt.Printf("Message on %s: %s\n", msg.TopicPartition, string(msg.Value))
	}
}
