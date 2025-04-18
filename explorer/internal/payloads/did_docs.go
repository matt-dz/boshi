package payloads

type Service struct {
	ID              string `json:"id"`
	Type            string `json:"type"`
	ServiceEndpoint string `json:"serviceEndpoint"`
}

type DIDDocument struct {
	Service []Service `json:"service"`
}

type Record struct {
	URI   string `json:"uri"`
	CID   string `json:"cid"`
	Value struct {
		Type      string `json:"$type"`
		Title     string `json:"title"`
		Content   string `json:"content"`
		Timestamp string `json:"timestamp"`
	} `json:"value"`
}