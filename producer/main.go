package main

import (
	"fmt"
	"time"
	"os"
	"strings"
	"gopkg.in/confluentinc/confluent-kafka-go.v1/kafka"
)

func CreateKafkaProducer(bootstrapServers string) *kafka.Producer {
	configMap := &kafka.ConfigMap{
		"bootstrap.servers": bootstrapServers,
	}

	producer, err := kafka.NewProducer(configMap)
	if err != nil {
		fmt.Println(err.Error())
		return nil
	}

	return producer
}

func Publish(message string, topic string, producer *kafka.Producer) error {
	messageData := &kafka.Message{
		TopicPartition: kafka.TopicPartition{Topic: &topic, Partition: kafka.PartitionAny},
		Value: []byte(message),
	}
	err := producer.Produce(messageData, nil)
	if err != nil {
		fmt.Println(err.Error())
		return err
	}

	return nil
}

func main() {
	var (
		bootstrapServers = os.Getenv("PRODUCER_BOOTSTRAP_SERVERS")
		topics = os.Getenv("TOPICS")
	)

	currentTime := time.Now()
	fmt.Println("[INFO] Started", currentTime.Format("2006.01.02 15:04:05"))

	forever := make(chan bool)

	producer := CreateKafkaProducer(bootstrapServers)
	defer producer.Close()

	// topic_0,topic_1,topic_2
	topicsSlice := strings.Split(topics, ",")
	fmt.Println(topicsSlice)

	for _, topic := range topicsSlice {
		Publish("Hello World", topic, producer)
		fmt.Println("[INFO] Sent Messages to Topic", topic, currentTime.Format("2006.01.02 15:04:05"))
	}

	<- forever
}
