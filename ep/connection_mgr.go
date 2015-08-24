package ep

import "fmt"

type RabbitAddress struct {
	User     string
	Password string
	Host     string
	Port     int
}

func (a *RabbitAddress) String() string {
	return fmt.Sprintf("amqp://%s:%s@%s:%d/", a.User, a.Password, a.Host, a.Port)
}

type RabbitAddressProvider interface {
	Get() RabbitAddress
}

// Satisfy the interface, but just pass through static data
type StaticRabbitAddressProvider struct {
	Address RabbitAddress
}

func (a *StaticRabbitAddressProvider) Get() RabbitAddress {
	return a.Address
}

// Load Connection String from Consul
// @todo
type ConsulRabbitAddressProvider struct {
}

func (a *ConsulRabbitAddressProvider) Get() RabbitAddress {
	var address RabbitAddress
	return address
}
